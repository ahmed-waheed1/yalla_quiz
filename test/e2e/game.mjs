// End-to-end: a 5-question game in the emulator with three browser sessions.
// Host (big screen, spectator) + Omar (en, phone) + Salma (ar, phone).
// See README.md for how to run it.
import { chromium } from 'playwright-core';
import { readFileSync, mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

import { serve } from './server.mjs';

const repo = fileURLToPath(new URL('../../', import.meta.url));
const PORT = 8080;
const APP = `http://localhost:${PORT}`;
const DB = 'http://127.0.0.1:9000';
const NS = 'yalla-quiz-8b2a9-default-rtdb';
const OUT = fileURLToPath(new URL('./shots/', import.meta.url));
mkdirSync(OUT, { recursive: true });

const server = await serve(`${repo}build/web`, PORT);
const questions = JSON.parse(readFileSync(`${repo}assets/questions/general.json`, 'utf8'));
const byId = Object.fromEntries(questions.map((q) => [q.id, q]));
const allOptions = new Set(questions.flatMap((q) => [...q.en.options, ...q.ar.options]));

const log = (...a) => console.log(`[${new Date().toISOString().slice(11, 19)}]`, ...a);
let failures = 0;
const check = (ok, what) => { log(ok ? 'PASS' : 'FAIL', what); if (!ok) failures++; };

async function db(path) {
  const r = await fetch(`${DB}/${path}.json?ns=${NS}`, { headers: { Authorization: 'Bearer owner' } });
  return r.json();
}

// Every session behaves like a foreground window (no background timer throttling).
const browser = await chromium.launch({
  executablePath: process.env.CHROME ?? '/usr/bin/google-chrome',
  headless: true,
  args: [
    '--disable-background-timer-throttling',
    '--disable-renderer-backgrounding',
    '--disable-backgrounding-occluded-windows',
  ],
});

async function open(name, { width, height, locale }) {
  const ctx = await browser.newContext({ viewport: { width, height }, locale });
  const page = await ctx.newPage();
  page.on('pageerror', (e) => log(`${name} pageerror:`, e.message.slice(0, 200)));
  page.on('console', (m) => { if (m.type() === 'error') log(`${name} console:`, m.text().slice(0, 200)); });
  return { name, ctx, page };
}

async function enableSemantics(page) {
  await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60000 });
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
  await page.waitForTimeout(1500);
}

async function goto(p, path) {
  await p.page.goto(APP + path);
  await enableSemantics(p.page);
}

const button = (page, text) =>
  page.locator('flt-semantics[role="button"]').filter({ hasText: new RegExp(`^\\s*${text}\\s*$`) }).first();

async function tap(p, text, timeout = 20000) {
  const b = button(p.page, text);
  try {
    await b.waitFor({ state: 'visible', timeout });
  } catch (e) {
    await shot(p, `fail_${p.name}_${text.replace(/\W+/g, '_')}`);
    const labels = await p.page.locator('flt-semantics[role="button"]').evaluateAll((els) => els.map((x) => (x.textContent || '').trim()));
    log(`${p.name} buttons:`, JSON.stringify(labels));
    throw e;
  }
  await b.click();
  log(`${p.name} tapped "${text}"`);
}

async function waitText(p, text, timeout = 30000) {
  await p.page.waitForFunction(
    (t) => [...document.querySelectorAll('flt-semantics')].some((e) => (e.textContent || '').includes(t)),
    text,
    { timeout },
  );
}

async function shot(p, name) {
  // Background tabs get no animation frames; bring the page forward first.
  await p.page.bringToFront();
  await p.page.waitForTimeout(900);
  await p.page.screenshot({ path: `${OUT}/${name}.png` });
}

async function profile(p, name) {
  const input = p.page.locator('input').first();
  await input.waitFor({ timeout: 30000 });
  await input.fill(name);
  await p.page.waitForTimeout(300);
  await tap(p, p.lang === 'ar' ? 'يلا بينا' : "Let's go").catch(async () => {
    // Fall back to the last button on the profile screen.
    await p.page.locator('flt-semantics[role="button"]').last().click();
  });
}

/// Taps answer [index] of the question on screen (buttons labelled with options).
async function answer(p, index) {
  const buttons = p.page.locator('flt-semantics[role="button"]');
  await p.page.waitForFunction(
    (opts) => [...document.querySelectorAll('flt-semantics[role="button"]')]
      .filter((e) => opts.includes((e.textContent || '').trim())).length >= 4,
    [...allOptions],
    { timeout: 30000 },
  );
  const labels = await buttons.evaluateAll((els, opts) =>
    els.map((e) => (e.textContent || '').trim()).filter((t) => opts.includes(t)), [...allOptions]);
  await button(p.page, labels[index].replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).click();
  log(`${p.name} answered #${index} (${labels[index]})`);
}

async function waitStatus(code, status, index, timeout = 40000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    const r = await db(`rooms/${code}`);
    if (r && r.status === status && (index === undefined || r.currentQuestionIndex === index)) return r;
    await new Promise((res) => setTimeout(res, 200));
  }
  throw new Error(`timeout waiting for ${status} q${index}`);
}

/// Every contestant's lastPoints/score after question [q] must match the formula.
function checkScores(room, q, before) {
  const ans = (room.answers && room.answers[q]) || {};
  const correct = byId[room.questionIds[q]].answer;
  const dur = room.settings.timePerQuestion * 1000;
  for (const [uid, p] of Object.entries(room.players)) {
    if (p.spectator) {
      check(p.score === 0 && !(p.lastPoints > 0), `q${q}: spectator ${p.name} not scored`);
      continue;
    }
    const a = ans[uid];
    let pts = 0;
    if (a && a.option === correct) {
      const left = Math.min(dur, Math.max(0, dur - (a.answeredAt - room.questionStartedAt)));
      pts = 500 + Math.round((500 * left) / dur);
    }
    check(p.lastPoints === pts, `q${q}: ${p.name} lastPoints ${p.lastPoints} == ${pts}`);
    check(p.score === (before[uid] ?? 0) + pts, `q${q}: ${p.name} score ${p.score} == ${(before[uid] ?? 0)} + ${pts}`);
  }
  check(room.scoredQuestionIndex === q, `q${q}: scoredQuestionIndex == ${q}`);
}

const scoresOf = (room) => Object.fromEntries(Object.entries(room.players).map(([u, p]) => [u, p.score]));

try {
  const host = await open('host', { width: 1280, height: 800, locale: 'en-US' });
  const omar = await open('omar', { width: 390, height: 844, locale: 'en-US' });
  const salma = await open('salma', { width: 390, height: 844, locale: 'ar-EG' });
  salma.lang = 'ar';

  // Host: profile → home → create (5 questions, big screen by default).
  await goto(host, '/');
  await profile(host, 'Nour');
  await tap(host, 'Create room');
  await tap(host, '5');
  await waitText(host, 'This screen shows the questions');
  await shot(host, '01_create_host_big_screen');
  await tap(host, 'Open the room');
  await host.page.waitForURL(/\/lobby\/[A-Z2-9]{6}$/, { timeout: 30000 });
  const code = host.page.url().split('/').pop();
  log('room', code);
  const created = await db(`rooms/${code}`);
  const hostUid = created.hostId;
  check(created.players[hostUid].spectator === true, 'host is a spectator (big screen default)');

  // Players join through the invite link (profile first).
  for (const [p, name] of [[omar, 'Omar'], [salma, 'Salma']]) {
    await goto(p, `/join?code=${code}`);
    await profile(p, name);
    // An invite link with a full code joins by itself; tap Join only if it didn't.
    await p.page.waitForURL(/\/lobby\//, { timeout: 8000 }).catch(async () => {
      await tap(p, p.lang === 'ar' ? 'ادخل الأوضة' : 'Join room');
      await p.page.waitForURL(/\/lobby\//, { timeout: 30000 });
    });
  }
  await waitText(host, '3/8');
  await shot(host, '02_lobby_host');
  await shot(salma, '02_lobby_salma_ar');

  const players = (await db(`rooms/${code}`)).players;
  const uidOf = (name) => Object.entries(players).find(([, p]) => p.name === name)[0];
  const omarUid = uidOf('Omar');

  // Start.
  await tap(host, 'Start game');
  let room = await waitStatus(code, 'countdown');
  check(room.questionIds.length === 5, 'five questions picked');
  check(Object.keys(room.usedQuestionIds).length === 5, 'usedQuestionIds recorded');
  await omar.page.waitForTimeout(800);
  await shot(omar, '03_get_ready_omar');

  let before = scoresOf(room);
  for (let q = 0; q < 5; q++) {
    room = await waitStatus(code, 'question', q);
    const t0 = Date.now();
    // Watch for the reveal from now on, so a slow UI step can't miss it.
    const revealed = waitStatus(code, 'reveal', q, 60000).then((r) => ({ r, at: Date.now() }));
    await omar.page.waitForTimeout(1200);
    if (q === 0) await shot(host, `04_q${q}_host_big_screen`);

    if (q === 2) {
      // Timeout path: only Omar answers.
      await answer(omar, 1);
      await waitText(salma, 'الوقت خلص', 30000);
      await shot(salma, `05_q${q}_salma_time_up_ar`);
    } else if (q === 3) {
      // The host closes the big screen mid-question; Omar takes over.
      await answer(salma, 0);
      await host.ctx.close();
      log('host closed their browser');
      await answer(omar, 0);
    } else {
      await answer(omar, q % 4);
      await shot(omar, `05_q${q}_omar_locked`);
      await answer(salma, (q + 1) % 4);
    }
    const lastAnswer = Date.now();

    const { r: revealRoom, at: revealedAt } = await revealed;
    room = revealRoom;
    const took = (revealedAt - t0) / 1000;
    log(`q${q} revealed after ${took.toFixed(1)} s`);
    if (q === 2) check(took > 19, `q${q}: waited for the timer (${took.toFixed(1)} s)`);
    else if (q === 3) check(room.hostId === omarUid, `q${q}: Omar took over as host`);
    else {
      const after = Math.max(0, revealedAt - lastAnswer) / 1000;
      check(after < 2, `q${q}: early advance, revealed ${after.toFixed(1)} s after the last answer`);
    }
    checkScores(room, q, before);
    before = scoresOf(room);

    await omar.page.waitForTimeout(1200);
    await shot(omar, `06_q${q}_reveal_omar`);
    await shot(salma, `06_q${q}_reveal_salma_ar`);
    if (q === 0) await shot(host, `06_q${q}_reveal_host_big_screen`);

    if (q < 4) {
      room = await waitStatus(code, 'leaderboard', q);
      await omar.page.waitForTimeout(1500);
      await shot(omar, `07_q${q}_leaderboard_omar`);
      if (q === 0) await shot(host, `07_q${q}_leaderboard_host`);
    }
  }

  room = await waitStatus(code, 'finished');
  check(room.scoredQuestionIndex === 4, 'all five questions scored once');
  await omar.page.waitForTimeout(2500);
  await shot(omar, '08_final_omar');
  await shot(salma, '08_final_salma_ar');

  // Play again: Salma first (waits in the lobby), then Omar (the new host).
  await tap(salma, 'نلعب تاني');
  await waitText(salma, 'مستني');
  await tap(omar, 'Play again');
  room = await waitStatus(code, 'lobby');
  check(!room.players[hostUid], 'disconnected host pruned on Play again');
  check(Object.values(room.players).every((p) => p.score === 0 && (p.streak ?? 0) === 0), 'scores reset');
  check(!room.answers && !room.questionIds && room.scoredQuestionIndex === undefined, 'game state cleared');
  check(Object.keys(room.usedQuestionIds).length === 5, 'usedQuestionIds kept');
  await omar.page.waitForTimeout(1500);
  await shot(omar, '09_lobby_again_omar');

  // A second game avoids the first game's questions.
  const firstIds = new Set(Object.keys(room.usedQuestionIds));
  await tap(omar, 'Start game');
  room = await waitStatus(code, 'countdown');
  check(room.questionIds.every((id) => !firstIds.has(id)), 'second game has no repeated questions');
  check(room.players[omarUid].spectator !== true, 'Omar plays as host');
} catch (e) {
  failures++;
  log('ERROR', e.stack || e);
} finally {
  await browser.close();
  server.close();
  log(failures === 0 ? 'ALL CHECKS PASSED' : `${failures} FAILURE(S)`);
  process.exit(failures === 0 ? 0 : 1);
}
