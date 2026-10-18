// Security rules tests for database.rules.json. Run with `npm test` in this
// folder; it starts the RTDB emulator through `firebase emulators:exec`.
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { get, ref, serverTimestamp, set, update } from 'firebase/database';

const CODE = 'K7XP2Q';
const ROOM = `rooms/${CODE}`;
const IDS = ['general_001', 'general_002', 'general_003', 'general_004', 'general_005'];

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-yalla-quiz',
    database: { rules: readFileSync(new URL('../../database.rules.json', import.meta.url), 'utf8') },
  });
});

after(async () => env?.cleanup());

beforeEach(async () => env.clearDatabase());

const db = (uid) => env.authenticatedContext(uid).database();
const write = (uid, paths) => update(ref(db(uid), ROOM), paths);

const player = (over = {}) => ({
  name: 'Nour',
  avatarSeed: 0,
  joinedAt: Date.now(),
  connected: true,
  score: 0,
  ...over,
});

const room = (over = {}) => ({
  hostId: 'host',
  status: 'lobby',
  createdAt: Date.now(),
  settings: { category: 'general', questionCount: 5, timePerQuestion: 10, maxPlayers: 8 },
  currentQuestionIndex: 0,
  players: { host: player(), p1: player(), p2: player() },
  ...over,
});

/// A room mid-game: question [q] running, earlier questions scored.
const inGame = (status, q, over = {}) =>
  room({
    status,
    questionIds: IDS,
    usedQuestionIds: Object.fromEntries(IDS.map((id) => [id, true])),
    currentQuestionIndex: q,
    questionStartedAt: Date.now(),
    phaseStartedAt: Date.now(),
    ...(q > 0 || status === 'reveal' || status === 'leaderboard' || status === 'finished'
      ? { scoredQuestionIndex: status === 'question' ? q - 1 : q }
      : {}),
    players: {
      host: player({ score: 1000, streak: 1, lastPoints: 1000 }),
      p1: player({ score: 600, streak: 1, lastPoints: 600 }),
      p2: player({ score: 0, streak: 0, lastPoints: 0 }),
    },
    ...over,
  });

const seed = (data) =>
  env.withSecurityRulesDisabled((ctx) => set(ref(ctx.database(), ROOM), data));

const read = async (path) => {
  let value;
  await env.withSecurityRulesDisabled(async (ctx) => {
    value = (await get(ref(ctx.database(), `${ROOM}/${path}`))).val();
  });
  return value;
};

const startGame = (over = {}) => ({
  status: 'countdown',
  phaseStartedAt: serverTimestamp(),
  questionIds: IDS,
  ...Object.fromEntries(IDS.map((id) => [`usedQuestionIds/${id}`, true])),
  currentQuestionIndex: 0,
  scoredQuestionIndex: null,
  answers: null,
  'players/host/score': 0,
  'players/p1/score': 0,
  'players/p2/score': 0,
  ...over,
});

/// The question → reveal write for question [q], adding [points] per player.
const scoreWrite = (q, points, over = {}) => {
  const old = { host: 1000, p1: 600, p2: 0 };
  const paths = { status: 'reveal', phaseStartedAt: serverTimestamp(), scoredQuestionIndex: q };
  for (const [uid, p] of Object.entries(points)) {
    paths[`players/${uid}/score`] = old[uid] + p;
    paths[`players/${uid}/lastPoints`] = p;
    paths[`players/${uid}/streak`] = p > 0 ? 2 : 0;
  }
  return { ...paths, ...over };
};

describe('room lifecycle (phase 1 regression)', () => {
  test('host creates a room, spectating or playing', async () => {
    await assertSucceeds(
      set(ref(db('host'), ROOM), {
        ...room({ players: { host: { ...player(), joinedAt: serverTimestamp(), spectator: true } } }),
        createdAt: serverTimestamp(),
      }),
    );
  });

  test('a fresh room code cannot be overwritten, a stale one can', async () => {
    await seed(room());
    const fresh = () => ({
      ...room({ hostId: 'other', players: { other: { ...player(), joinedAt: serverTimestamp() } } }),
      createdAt: serverTimestamp(),
    });
    await assertFails(set(ref(db('other'), ROOM), fresh()));
    await seed(inGame('question', 2, { createdAt: Date.now() - 3 * 3600 * 1000 }));
    await assertSucceeds(set(ref(db('other'), ROOM), fresh()));
  });

  test('players join in the lobby only, and rejoin at any status', async () => {
    await seed(room());
    const newPlayer = { ...player(), joinedAt: serverTimestamp() };
    await assertSucceeds(set(ref(db('p3'), `${ROOM}/players/p3`), newPlayer));
    await seed(inGame('question', 1));
    await assertFails(set(ref(db('p4'), `${ROOM}/players/p4`), newPlayer));
    await assertSucceeds(update(ref(db('p1'), `${ROOM}/players/p1`), { connected: true, name: 'Omar' }));
  });

  test('only the host can delete the room', async () => {
    await seed(room());
    await assertFails(set(ref(db('p1'), ROOM), null));
    await assertSucceeds(set(ref(db('host'), ROOM), null));
  });
});

describe('spectator', () => {
  test('only the host can be a spectator, and only in the lobby', async () => {
    await seed(room());
    await assertSucceeds(set(ref(db('host'), `${ROOM}/players/host/spectator`), true));
    await assertSucceeds(set(ref(db('host'), `${ROOM}/players/host/spectator`), false));
    await assertFails(set(ref(db('p1'), `${ROOM}/players/p1/spectator`), true));
    await assertSucceeds(set(ref(db('p1'), `${ROOM}/players/p1/spectator`), false));
    const joiner = { ...player(), joinedAt: serverTimestamp(), spectator: true };
    await assertFails(set(ref(db('p3'), `${ROOM}/players/p3`), joiner));

    await seed(inGame('question', 0));
    await assertFails(set(ref(db('host'), `${ROOM}/players/host/spectator`), true));
  });

  test('a spectator cannot answer', async () => {
    await seed(inGame('question', 0, { players: { host: player({ spectator: true }), p1: player() } }));
    const answer = { option: 1, answeredAt: serverTimestamp() };
    await assertFails(set(ref(db('host'), `${ROOM}/answers/0/host`), answer));
    await assertSucceeds(set(ref(db('p1'), `${ROOM}/answers/0/p1`), answer));
  });
});

describe('start game', () => {
  test('host starts with exactly questionCount questions', async () => {
    await seed(room());
    await assertFails(write('p1', startGame()));
    await assertFails(write('host', startGame({ questionIds: IDS.slice(0, 4) })));
    await assertSucceeds(write('host', startGame()));
    assert(await read('status') === 'countdown');
    assert((await read('usedQuestionIds')).general_005 === true);
  });

  test('questionIds and usedQuestionIds only change when the game starts', async () => {
    await seed(inGame('question', 1));
    await assertFails(write('host', { questionIds: IDS.slice().reverse() }));
    await assertFails(write('host', { 'usedQuestionIds/general_009': true }));
  });

  test('question ids must look like ids', async () => {
    await seed(room());
    await assertFails(write('host', startGame({ questionIds: ['../x', ...IDS.slice(1)] })));
    await assertFails(write('host', startGame({ 'usedQuestionIds/General': true })));
  });

  test('settings are frozen once the game starts', async () => {
    await seed(room());
    await assertSucceeds(write('host', { 'settings/questionCount': 10 }));
    await seed(inGame('question', 1));
    await assertFails(write('host', { 'settings/questionCount': 10 }));
  });

  test('cannot start from the lobby straight into a question', async () => {
    await seed(room({ questionIds: IDS }));
    await assertFails(
      write('host', {
        status: 'question',
        questionStartedAt: serverTimestamp(),
        phaseStartedAt: serverTimestamp(),
      }),
    );
  });
});

describe('phase transitions', () => {
  const toQuestion = (q) => ({
    status: 'question',
    currentQuestionIndex: q,
    questionStartedAt: serverTimestamp(),
    phaseStartedAt: serverTimestamp(),
  });

  test('countdown → question 0 needs fresh timestamps', async () => {
    await seed(inGame('countdown', 0));
    await assertFails(write('host', { status: 'question', phaseStartedAt: serverTimestamp() }));
    await assertFails(write('host', toQuestion(1)));
    await assertFails(write('p1', toQuestion(0)));
    await assertSucceeds(write('host', toQuestion(0)));
  });

  test('question → reveal on every question, including the first', async () => {
    for (let q = 0; q < IDS.length; q++) {
      await seed(inGame('question', q));
      await assertSucceeds(write('host', scoreWrite(q, { host: 500, p1: 0, p2: 0 })));
    }
  });

  test('reveal → leaderboard on every question but the last, finished only on the last', async () => {
    for (let q = 0; q < IDS.length; q++) {
      const last = q === IDS.length - 1;
      await seed(inGame('reveal', q));
      const toLeaderboard = write('host', { status: 'leaderboard', phaseStartedAt: serverTimestamp() });
      await (last ? assertFails(toLeaderboard) : assertSucceeds(toLeaderboard));
      await seed(inGame('reveal', q));
      const toFinished = write('host', { status: 'finished', phaseStartedAt: serverTimestamp() });
      await (last ? assertSucceeds(toFinished) : assertFails(toFinished));
    }
  });

  test('reveal → leaderboard, except after the last question', async () => {
    await seed(inGame('reveal', 3));
    await assertFails(write('host', { status: 'finished', phaseStartedAt: serverTimestamp() }));
    await assertSucceeds(write('host', { status: 'leaderboard', phaseStartedAt: serverTimestamp() }));
  });

  test('reveal → finished after the last question', async () => {
    await seed(inGame('reveal', 4));
    await assertFails(write('host', { status: 'leaderboard', phaseStartedAt: serverTimestamp() }));
    await assertSucceeds(write('host', { status: 'finished', phaseStartedAt: serverTimestamp() }));
  });

  test('leaderboard → the next question only (no repeat, no skip)', async () => {
    await seed(inGame('leaderboard', 1));
    await assertFails(write('host', toQuestion(1)));
    await assertFails(write('host', toQuestion(3)));
    await assertSucceeds(write('host', toQuestion(2)));
  });

  test('phases cannot be skipped', async () => {
    await seed(inGame('question', 1));
    await assertFails(write('host', { status: 'leaderboard', phaseStartedAt: serverTimestamp() }));
    await assertFails(write('host', { status: 'finished', phaseStartedAt: serverTimestamp() }));
    await assertFails(write('host', { status: 'lobby', currentQuestionIndex: 0 }));
    await seed(inGame('countdown', 0));
    await assertFails(write('host', scoreWrite(0, { p1: 500 })));
  });

  test('the question index only moves with a phase change', async () => {
    await seed(inGame('question', 1));
    await assertFails(write('host', { currentQuestionIndex: 2 }));
    await assertFails(write('host', { currentQuestionIndex: 5, status: 'reveal' }));
  });

  test('a repeated phase write cannot restart the timer or extend the phase', async () => {
    await seed(inGame('question', 2));
    await assertFails(
      write('host', {
        status: 'question',
        currentQuestionIndex: 2,
        questionStartedAt: serverTimestamp(),
        phaseStartedAt: serverTimestamp(),
      }),
    );
    await assertFails(write('host', { questionStartedAt: serverTimestamp() }));
    await seed(inGame('leaderboard', 2));
    await assertFails(write('host', { status: 'leaderboard', phaseStartedAt: serverTimestamp() }));
  });

  test('a status change needs a fresh phaseStartedAt', async () => {
    await seed(inGame('reveal', 1));
    await assertFails(write('host', { status: 'leaderboard', phaseStartedAt: Date.now() - 1000 }));
  });
});

describe('scoring', () => {
  test('question → reveal writes scores once', async () => {
    await seed(inGame('question', 2));
    await assertSucceeds(write('host', scoreWrite(2, { host: 900, p1: 0, p2: 750 })));
    assert(await read('players/host/score') === 1900);
    assert(await read('scoredQuestionIndex') === 2);
  });

  test('scoring the same question again is rejected', async () => {
    await seed(inGame('question', 2));
    await assertSucceeds(write('host', scoreWrite(2, { p1: 500 })));
    // Same write again (e.g. a timer firing twice), and a scores-only replay.
    await assertFails(write('host', scoreWrite(2, { p1: 500 })));
    await assertFails(
      write('host', { 'players/p1/score': 1600, 'players/p1/lastPoints': 500 }),
    );
    assert(await read('players/p1/score') === 1100);
  });

  test('a new host scoring a question that is already scored is rejected', async () => {
    await seed(
      inGame('reveal', 2, {
        hostId: 'p1',
        players: {
          host: player({ score: 1000, connected: false }),
          p1: player({ score: 600, lastPoints: 600 }),
          p2: player(),
        },
      }),
    );
    await assertFails(write('p1', scoreWrite(2, { p1: 500 })));
  });

  test('a new host scores a question the old host left unscored', async () => {
    await seed(
      inGame('question', 2, {
        hostId: 'p1',
        players: {
          host: player({ score: 1000, lastPoints: 1000, connected: false }),
          p1: player({ score: 600, lastPoints: 600 }),
          p2: player(),
        },
      }),
    );
    await assertFails(write('host', scoreWrite(2, { host: 500 })));
    await assertSucceeds(write('p1', scoreWrite(2, { host: 0, p1: 500, p2: 0 })));
  });

  test('reveal needs scoredQuestionIndex for the current question', async () => {
    await seed(inGame('question', 2));
    await assertFails(write('host', { status: 'reveal', phaseStartedAt: serverTimestamp() }));
    await assertFails(write('host', scoreWrite(2, { p1: 500 }, { scoredQuestionIndex: 1 })));
  });

  test('score must equal the old score plus lastPoints', async () => {
    await seed(inGame('question', 2));
    await assertFails(
      write('host', scoreWrite(2, { p1: 500 }, { 'players/p1/score': 2000 })),
    );
  });

  test('lastPoints is capped at 1000', async () => {
    await seed(inGame('question', 2));
    await assertFails(write('host', scoreWrite(2, { p1: 1001 })));
  });

  test('players cannot write scores', async () => {
    await seed(inGame('question', 2));
    await assertFails(write('p1', scoreWrite(2, { p1: 500 })));
  });
});

describe('answers', () => {
  const answer = () => ({ option: 2, answeredAt: serverTimestamp() });

  test('one answer per player, for the current question, before time runs out', async () => {
    await seed(inGame('question', 1));
    await assertFails(set(ref(db('p1'), `${ROOM}/answers/0/p1`), answer()));
    await assertFails(set(ref(db('p1'), `${ROOM}/answers/1/p2`), answer()));
    await assertSucceeds(set(ref(db('p1'), `${ROOM}/answers/1/p1`), answer()));
    await assertFails(set(ref(db('p1'), `${ROOM}/answers/1/p1`), answer()));

    await seed(inGame('question', 1, { questionStartedAt: Date.now() - 12000 }));
    await assertFails(set(ref(db('p2'), `${ROOM}/answers/1/p2`), answer()));
  });

  test('no answers outside the question phase or from non-players', async () => {
    await seed(inGame('reveal', 1));
    await assertFails(set(ref(db('p1'), `${ROOM}/answers/1/p1`), answer()));
    await seed(inGame('question', 1));
    await assertFails(set(ref(db('x'), `${ROOM}/answers/1/x`), answer()));
  });

  test('only the host can clear answers, and only all of them', async () => {
    // Two answers: deleting the only one would empty `answers`, which is a full clear.
    await seed(
      inGame('reveal', 1, {
        answers: { 1: { p1: { option: 0, answeredAt: 1 }, p2: { option: 1, answeredAt: 2 } } },
      }),
    );
    await assertFails(write('p1', { answers: null }));
    await assertFails(write('host', { 'answers/1/p1': null }));
    await assertFails(write('host', { 'answers/1/p1/option': 3 }));
    await assertSucceeds(write('host', { answers: null }));
  });
});

describe('play again', () => {
  const reset = (over = {}) => ({
    status: 'lobby',
    currentQuestionIndex: 0,
    questionIds: null,
    scoredQuestionIndex: null,
    answers: null,
    phaseStartedAt: null,
    questionStartedAt: null,
    'players/host/score': 0,
    'players/host/streak': 0,
    'players/host/lastPoints': 0,
    'players/p1/score': 0,
    'players/p1/streak': 0,
    'players/p1/lastPoints': 0,
    ...over,
  });

  const finished = () =>
    inGame('finished', 4, {
      players: {
        host: player({ score: 3000 }),
        p1: player({ score: 2000 }),
        p2: player({ score: 900, connected: false }),
      },
    });

  test('host resets scores, prunes disconnected players and keeps usedQuestionIds', async () => {
    await seed(finished());
    await assertSucceeds(write('host', reset({ 'players/p2': null })));
    assert(await read('status') === 'lobby');
    assert(await read('players/p2') === null);
    assert(await read('players/p1/score') === 0);
    assert((await read('usedQuestionIds')).general_001 === true);
  });

  test('connected players cannot be pruned', async () => {
    await seed(finished());
    const paths = reset({ 'players/p1': null });
    for (const key of Object.keys(paths)) if (key.startsWith('players/p1/')) delete paths[key];
    await assertFails(write('host', paths));
  });

  test('only the host resets, and only from finished', async () => {
    await seed(finished());
    await assertFails(write('p1', reset()));
    await seed(inGame('leaderboard', 2));
    await assertFails(write('host', reset()));
  });

  test('disconnected players cannot be pruned mid-game', async () => {
    await seed(inGame('question', 2, { players: { host: player(), p2: player({ connected: false }) } }));
    await assertFails(write('host', { 'players/p2': null }));
  });

  test('scores cannot be zeroed mid-game', async () => {
    await seed(inGame('leaderboard', 2));
    await assertFails(write('host', { 'players/p1/score': 0 }));
  });
});

function assert(condition) {
  if (!condition) throw new Error('assertion failed');
}
