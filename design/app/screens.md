# Yalla Quiz — screen specs

Build reference for Flutter. Token names refer to `lib/core/theme/` (`YqColors`, `YqTypography`, `YqSpace`, `YqRadius`, `YqElevation`, `YqMotion`) and `design-tokens.json`. Pixel values are logical dp. Every screen has a PNG in `screens/phone/` (375×812 @2x, `_en` + `_ar`) and the host screens in `screens/tablet/` (834×1194 @2x). PNGs show the **light** theme; dark uses the same layout with `YqColors.dark`.

Sample data used everywhere: room `K7XP2Q`, question "What's the capital of Morocco?" / "إيه عاصمة المغرب؟" (answer Rabat), players Nour, Omar, Salma, Youssef, Mariam, Karim, Laila, Hamza (نور، عمر، سلمى، يوسف، مريم، كريم، ليلى، حمزة).

---

## 0. Global rules

**Scaffold**
- Background `bg` with a dot grid: 24 × 24 spacing, dot radius 1.6, colour `bgPattern`. Paint once with a `CustomPainter` behind the body.
- Top inset: content starts at `x14` (56) from the top of the screen. That already includes the status bar, so don't add a SafeArea top on top of it. Bottom padding is `x10` (40), or 36 on game screens.
- Side gutter `gutter` (20). Host screens use `hostGutter` (40).
- Primary actions sit at the bottom (`Spacer()` then the buttons). Content scrolls if the text scale pushes it past the screen.

**RTL**
- Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional` and `Row`, which mirrors automatically.
- Mirror these icons: back chevron, forward arrow, "enter/join" arrow, list chevrons, the "host left" door.
- The timer ring drains counter-clockwise in RTL (apply `Transform.flip(flipX: true)` to the ring painter only, never to the number).
- Progress bars and vote bars fill from the start edge.
- Never mirror: the room code, scores, the brand mark, the answer shapes.

**Numbers**
- Western digits 0–9 and tabular figures (`YqTypography.numeric`, `code`, `timer`) in both locales.
- Wrap each number in `Directionality(textDirection: TextDirection.ltr)`.

**Line heights:** `YqTypography.forLocale(locale)`. Arabic uses the same sizes with taller lines.

**Touch targets:** at least 48 × 48 (`minTouch`). Answer buttons are 64 tall, primary buttons 58.

**Reduced motion:** if `MediaQuery.disableAnimationsOf(context)`, every move below becomes a 120 ms fade (`YqMotion.reducedFade`), with no confetti and no shake.

**Haptics:** `HapticFeedback.selectionClick` on chip/segment changes, `mediumImpact` on answer lock-in, `heavyImpact` on wrong answer and "Yalla!".

### Shared components (build these once)

**`YqButton(variant: primary | secondary, loading, enabled, icon)`**
- Height 58, radius `lg` 18, label `button` 18/800, icon 22 with a 10 gap.
- **Primary:** fill `primary`, text `onPrimary`, stomp `YqElevation.stomp(primaryDeep)`.
- **Secondary:** fill `surface`, 2.5 `ink` border, `stompSecondary(ink)`.
- **Disabled:** `surfaceAlt` fill, `inkMuted` text, no shadow.
- **Pressed:** translateY 4, stomp offset 5→1 (`instant` 80 ms).
- **Loading:** spinner 22 replaces the icon, keeps the width, blocks taps.

**`YqIconButton`**
- 48 × 48, radius `md` 16, fill `surface`, 1.5 `line` inner border, icon 24 stroke 2.4.

**`YqChip` / pill**
- Radius `pill`, padding 6 × 12.
- **Score pill:** `surface` with a 1.5 `line` border, `numeric` 15/900.
- **Meta pill:** `surfaceAlt`, `label` 13 in `inkMuted`.

**`YqSegmented`**
- Track `surfaceAlt`, radius `lg`, 4 padding, 4 gap. Segments are 48 tall, radius 14, `label` 15–16/800, unselected text `inkMuted`.
- Selected segment: fill `inverse`, text `onInverse`, shadow `0 3 0 rgba(0,0,0,.2)`.

**`YqCodeInput(length: 6)`**
- Boxes 48 × 62, gap 7, radius `sm` 12, glyph 28/900. Always LTR. Accepts A–Z and 2–9 only (no O/0, I/1), auto-uppercases, and pasting fills all six.
- **Empty:** 2 `line` border.
- **Filled:** 2 `ink` border.
- **Focused:** 3 `focus` border with a caret.
- **Error:** 2.5 `danger` border on a `dangerSoft` fill, then shake ±6 ×3 over 300 ms with `heavyImpact`.

**`YqAvatar(seed, size)`**
- Circle base colour, one abstract shape (arch, half-moon, triangle, leaf, diamond, two circles, square), plus a 4.5 dot. Eight presets; see `03_profile_setup`.
- Ghost (player joining): `#9C8DB3` / `#C9BCDA`, pulsing between 0.4 and 0.9 opacity every 1.4 s.

**`YqPlayerTile(host, you, joining, answered)`**
- 92 tall in the phone 4-column grid, radius 20, `surface` fill, 1.5 `line` border.
- Avatar 44, name 13/800 truncated with an ellipsis.
- **You:** 3 `primary` inner ring.
- **Host:** 22 × 22 `accent` badge with a crown, at the top end corner.
- **Answered (in game):** 24 `success` check badge on the avatar.

**`YqTimerRing(remaining, total)`**
- **Phone:** 96, radius 40, stroke 9, round caps. Track `surfaceAlt`, fill `surface`, starts at 12 o'clock. Number in `timer` 34/900.
- **Colour:** `timerCalm` above 50%, `timerWarn` at 50% or less, `timerPanic` at 5 s or less (pulse to 1.08 at 1 Hz with a light haptic each second). At 0 it turns `inkMuted`.
- **Host:** 176, stroke 16, `hostTimer` 68.

**`YqAnswerButton(index, state)`**
- 64 tall, radius 18, 16 horizontal padding, shape icon 26 + label 19/800, 14 gap.
- Colours from `answers[index]` (`fill`, `onFill`, `deep`). Shapes: a1 triangle, a2 diamond, a3 circle, a4 square.
- **States:**
  - `idle`: stomp shadow.
  - `pressed`: translateY 4, stomp 1.
  - `locked`: no shadow, translateY 4, 3 `ink` outline offset 3, plus a lock pill at the end (`#140A2B` fill, 12/800, lock icon 13).
  - `dimmed`: opacity 0.4.
  - `timeUp`: fill `surfaceAlt`, text `inkMuted`.
- Reveal uses `YqVoteRow` instead (see 09).

**`YqLeaderboardRow(rank, delta, you)`**
- 60 tall, radius 18, `surface` fill, 1.5 `line` border.
- Rank badge 30 × 30, radius 10: #1 `accent` on night text, #2–3 `ink` on `bg`, others `surfaceAlt`.
- Avatar 38, name 16/800.
- Delta chip: up = `successSoft`/`success`, down = `dangerSoft`/`danger`, none = `surfaceAlt`/`inkMuted`. Always arrow + number, never colour alone.
- Score `numeric` 17/900, end-aligned, 62 wide.
- **You:** 3 `primary` ring.

**`YqBanner(kind: warning | success | danger)`**
- At least 56 tall, radius 16–18, soft fill (`warningSoft` / `successSoft` / `dangerSoft`) with a 1.5 border in the strong colour.
- Icon 22, title 15–16/900, body 12.5–13/600 `inkMuted`.
- Pins under the app bar and pushes content down.

**`YqToast`**
- Pill, `inverse` fill, `onInverse` text, 48 tall, `modal` shadow, floats 24 above the bottom inset, auto-hides after 2.4 s.

**`YqCard`:** radius `xl` 24, `surface`, 1.5 `line` inner border. Add `card` elevation for hero cards.

---

## 01 Splash — `01_splash_*`

- **Layout:** full-bleed `inverse` (#1E0F3D). Centred column: brand mark 180, 18 gap, wordmark (artwork asset, Lalezar), tagline 20/700 in `accent`.
- **Background:** the 8-point star at 620, colour `inverse2`, 55% opacity, behind everything.
- **Footer:** three 10 px loading dots in `primary`, 64 from the bottom.
- **Copy:** "Yalla, let's go!" / "يلا بينا!".
- **Animation (plays once, about 1.1 s, then routes to Home or Profile):**
  - Mark pops scale 0→1.12→1 with a −14° to 0° rotation over 0–220 ms, `snap`.
  - Spark scales and rotates in at 200–380 ms.
  - Wordmark rises 28 px and fades in at 180–360 ms, `out`.
  - Tagline fades in at 330–480 ms.
  - The star rotates slowly (40 s per turn).
- **Native splash:** `flutter_native_splash` uses the same colour and mark position, so the hand-off is seamless (config in the icon package).

## 02 Home — `02_home_*`

- **App bar** (top 56, gutter 20):
  - Wordmark image (height about 34) at the start.
  - `YqIconButton` settings (sliders icon) at the end → 12 Settings.
- **Greeting row** (12 below): avatar 52, 12 gap, caption "Hey Nour!" 13/600 `inkMuted` over `title` 24/800 "Ready for a round?".
- **Hero card** (20 below):
  - Radius 28, fill `inverse`, padding 20, `card` elevation.
  - Illustration 295 × 214: answer shapes on a star. Use an SVG asset, don't mirror it.
  - Title 22/900 `onInverse`, body 14/600 at 85% opacity.
- **Bottom stack** (gap 14, bottom 40):
  - Primary "Create room" with a plus icon → 04.
  - Secondary "Join room" with the enter icon (mirrored in RTL) → 05.
- **First launch:** if no profile exists, route to 03 first.

## 03 Profile setup — `03_profile_setup_*`

- **App bar:** back + title "Your player" (`titleSm`).
- **Avatar preview:** 132, centred, 16 top padding. Shuffle `YqIconButton` with `inverse` fill and a 4 `bg` ring at the bottom end, offset −10 / −4.
- **Name field** (16 below):
  - Label `titleSm`.
  - Field 60 tall, radius 18, 20/800 text, 3 `focus` border when focused, `maxLength` 12, trimmed.
  - Row below: hint 13/600 `inkMuted` and counter "4/12" (`numeric`).
- **Avatar picker:**
  - Title row "Pick your look" + hint, then a 4-column grid, gap 12, cells 68 with avatar 60.
  - Selected cell: 3 `bg` + 3 `primary` double ring and a 24 `primary` check badge at the top end.
- **Bottom:** primary "Let's go" with the forward arrow (mirrored), enabled when the name is 1–12 characters.
- **Animation:**
  - Shuffle: avatar cross-fades and scales 0.9→1 over 240 ms, `snap`.
  - Picking an avatar: ring scales in over 160 ms.

## 04 Create room — `04_create_room_*`

- **App bar:** back + "Set up your room".
- **Category:**
  - Label 14/800 `inkMuted`, then a 2-column grid, gap 10.
  - Category chips 52 tall, radius 16, `surface` with a 1.5 `line` border. Selected: 3 `primary` ring.
  - Each chip has a 30 × 30 colour square (radius 10) holding a 16 shape icon, then the label 15/800.
- **Three `YqSegmented` groups**, 20 apart, each with a label:
  - Questions 5 / 10 / 15 (default 10).
  - Time per question 10 / 15 / 20 s (default 20).
  - Questions language English / العربية (default: the UI language).
- **Bottom:**
  - Summary caption 14/700 `inkMuted`, centred ("10 questions · 20 s each · about 5 min").
  - Primary "Open the room" → creates the room → 06 as host.
  - Loading state while the room is being created.

## 05 Join room — `05_join_room_{typing|complete|error_invalid|error_full}_*`

- **App bar:** back + "Join a room".
- **Hero** (28 top): `headline` "Got a code?" with body text below in `inkMuted`.
- **Code** (24 below):
  - Label "Room code · A–Z, 2–9" 14/800 `inkMuted`.
  - `YqCodeInput`, centred, always LTR.
- **Error card** under the boxes, gap 14:
  - Radius 18, `dangerSoft` fill, 1.5 `danger` border, icon 24 + title 16/800 + body 14/600.
  - `error_invalid`: alert icon, "That code doesn't exist".
  - `error_full`: users icon, "This room is full (8/8)".
- **Divider:** 2 px `line` rules with "or" in the middle, then a secondary "Scan QR code" button (scan icon) that opens the camera scanner.
- **Bottom:** primary "Join room".
  - Disabled until all six characters are in.
  - `complete`: enabled and auto-submits.
  - In the error states it stays disabled until the code changes.
- **Animation:** each box scales 1.08→1 as a character lands (80 ms). On error the boxes shake ×3 (300 ms) and the error card slides down 8 px and fades in (240 ms).

## 06 Lobby — `06_lobby_{host|host_waiting_disabled|player_waiting}_*`

- **App bar:**
  - Close (×) to leave the room. Confirm first if you are the host.
  - Title "Lobby".
  - Meta pill "General · 10 Q" (`surfaceAlt`) at the end.
- **Code card** (10 below):
  - `YqCard` + `card` elevation, padding 16, row with gap 14.
  - Start column: label 13/800, code `code` 34/900 with 0.08em spacing, and a copy button (44 tall, radius 12, `surfaceAlt`). Copying shows a `YqToast` "Code copied".
  - QR code 96 at the end (white tile, radius 6%, encodes the deep link).
- **Share:**
  - Secondary button "Share invite" (52 tall) opens the system share sheet with "Join my Yalla Quiz room! Code K7XP2Q".
  - The message preview sits below as a caption.
- **Players section** (16 below):
  - Live dot: 9 px `success` with a 5 px 18% halo, pulsing every 1.4 s.
  - "Waiting for your friends…" `titleSm` 16, count "4/8" `numeric` at the end.
  - 4-column grid of `YqPlayerTile`, gap 8. A ghost tile is always appended while the room isn't full.
- **Bottom by role:**
  - `host` with 2+ players: primary "Start game" → 07.
  - `host_waiting_disabled` with 1 player: caption "You need at least 2 players to start", plus the disabled button.
  - `player_waiting`: status card 64 tall, `surfaceAlt`, radius 18, spinner 22 in `primary`, "Waiting for the host to start…" 16/800.
- **Animation:** a joining tile replaces the ghost with scale 0.6→1 over 240 ms (`snap`) and a light haptic. Tiles that leave fade out over 160 ms.

## 07 Get ready — `07_get_ready_{3|2|1|yalla}_*`

- **Digits (3, 2, 1):**
  - Column centred: `headline` 34 "Get ready!" at top 128, then meta 15/700 `inkMuted` ("Question 1 of 10 · General").
  - Ring 240 (radius 104, stroke 16, `primary` on a `surfaceAlt` track) 64 below, with a faint shockwave ring behind it.
  - Digit 136/900 tabular. The ring drains a third per second.
  - Footer: avatar stack (36, −8 overlap, 3 `bg` ring) and "6 players ready".
- **`yalla`:**
  - Full-bleed `primary` with answer shapes and a 14% night star.
  - "Yalla!" / "يلا!" in the Lalezar artwork about 150 tall, rotated −4°.
  - Subline 20/800 on night text.
- **Animation (1 s per digit):**
  - Digit enters scale 2.2→1 with a fade (300 ms, `snap`), holds, then exits to 0.6 with a fade (200 ms).
  - A shockwave ring expands 0.7→1.5 and fades.
  - `selectionClick` on each digit.
  - "Yalla!": rotates −8°→0° and scales 0→1.15→1 over 400 ms, the primary flood fills behind it, `heavyImpact`, then cuts to 08.

## 08 Question — `08_question_{unanswered|selected|timeup}_*`

- **Header** (top 56):
  - Start: "Question 4 of 10" 14/800 `inkMuted`, with 10 progress segments below (8 tall, radius 4, gap 4). Past segments `ink`, current `primary`, future `surfaceAlt`.
  - End: score pill `numeric`.
- **Timer:** `YqTimerRing` 96, centred, 18 below the header.
- **Question card** (14 below): `YqCard`, padding 18, min height 124, category 13/800 `inkMuted` over question 23/800 (`question` style + line height).
- **Answers** (18 below): four `YqAnswerButton`s, gap 12.
- **Footer by state:**
  - `unanswered` (timer 14 s, calm green): "Pick your answer!" 15/800 plus "2/8 answered" `numeric` `inkMuted`.
  - `selected` (timer 6 s, warn): the chosen answer is `locked`, the other three `dimmed`. Status card 56 tall: avatar stack 28 (answered players, live), "Locked in! Waiting for the rest…" 14/800, "5/8".
  - `timeup` (timer 0, `inkMuted`): all answers `timeUp`. `danger` banner with the clock icon: "Time's up!" and "No answer this round — next one is yours."
- **Animation:**
  - Lock-in: press (stomp 5→1, scale 0.97, 0–80 ms), release to 1.03→1 with the outline drawing in and the lock pill sliding from the end edge (80–300 ms, `snap`). Others fade to 0.4 (120–320 ms, `fast`). `mediumImpact`.
  - Timer panic pulse in the last 5 s.
  - Question enters with a 12 px fade-up (`base`).
  - Answers stagger in 60 ms apart.

## 09 Reveal — `09_reveal_{correct|wrong}_*`

- **Header:** "Question 4 of 10" + updated score pill (3,330 correct / 2,480 wrong).
- **Result banner** (14 below):
  - Radius 28, padding 20.
  - `correct`: `successSoft` fill, 2 `success` border, 64 `success` check circle, "Nailed it!" 26/900, sub 13/700 "Fast-answer bonus · streak ×3", points "+850" `numeric` 40/900 in `success`.
  - `wrong`: `dangerSoft` fill, `danger` × circle, "So close!", "It was Rabat · streak reset", "+0".
- **Question:** repeated at 18/800.
- **Vote rows** (`YqVoteRow`, gap 10):
  - 62 tall, radius 18, `surface`.
  - Bar fills from the start edge at `count/players` width, in the answer fill at 25% alpha.
  - Shape tile 38 (radius 12, answer fill), label 17/800, "You" pill (`ink` fill, 12/800) on your pick, count `numeric`.
  - Correct row: 3 `success` outline offset 2 plus a 28 check badge.
  - Your wrong pick: 3 dashed `danger` outline plus a 28 × badge.
  - Other rows: opacity 0.6.
- **Footer:** "Leaderboard in 3…" plus a 6 px progress bar (`primary` on `surfaceAlt`) that drains over 3 s, then → 10.
- **Animation:**
  - 600 ms suspense hold (the timer ring spins once), then the correct row pops 1.08→1.03 (`snap`).
  - A wrong pick shakes ±6 ×3 (`heavyImpact`).
  - Vote bars grow 0→width over 500 ms, staggered 60 ms.
  - Points count 0→850 over 700 ms (`out`) and float up 10 px.
  - Correct answers get `lightImpact` ×2.

## 10 Leaderboard — `10_leaderboard_*`

- **Header** (top 56): "After question 4 of 10" 14/800 `inkMuted` over `title` 30/900 "Leaderboard". `successSoft` chip at the end: "↑ You climbed 2".
- **Rows:** eight `YqLeaderboardRow`s, gap 8. Your row has the `primary` ring.
- **Footer:** "Question 5 in 5…" caption, centred.
- **Animation:**
  - Rows start in the previous order for 300 ms.
  - Each row then slides to its new rank over 500 ms (`inOut`), using a `Stack` with `AnimatedPositioned` keyed by player id, top = rank × 68.
  - Rows moving up scale to 1.03 mid-flight and draw above the others.
  - Delta chips pop in at 800 ms.
  - Your row pulses once, with `selectionClick`.

## 11 Final results — `11_final_results_*`

- **Header** (top 60, centred): "Game over · 10 questions" 14/800 `inkMuted` over "Nour takes the crown!" 28/900.
- **Podium** (18 below):
  - Three columns in visual order 2nd / 1st / 3rd, gap 10. Row mirrors in RTL.
  - Avatars 60 / 76 / 56 with a 4 ring in the column colour.
  - Name 15/800, score 13/800 `inkMuted`.
  - Blocks: heights 104 / 144 / 78, radius 18 at the top and 6 at the bottom, colours `podiumSilver` / `accent` / `primary`, rank 38/900 night.
  - Crown 34 in `accent` above #1.
- **Rest of ranking:** rows 42 tall (radius 14, ranks 4–8), gap 6.
- **Bottom row** (gap 12): secondary "Home" (flex 1) and primary "Play again" (flex 1.4, same settings → 06).
- **Confetti:** the four answer shapes plus 8-point stars, kept to the side margins so it never covers text.
- **Animation:**
  - Columns rise 3rd → 2nd → 1st, 150 ms stagger, 600 ms each, `back`. Avatars drop onto them.
  - Crown spins down onto #1 over 500 ms with `heavyImpact`.
  - Confetti for 2 s.
  - The ranking list slides up last. Buttons fade in after 1.4 s so nobody taps away mid-celebration.

## 12 Settings — `12_settings_*`

- **App bar:** back + "Settings".
- **Cards** (gap 14), each `YqCard` with padding 16:
  1. **Language:** globe icon + label, `YqSegmented` English | العربية, hint 13/600. Switching it rebuilds `MaterialApp` with the new locale (layout direction flips).
  2. **Theme:** moon icon, `YqSegmented` Light | Dark | System, with sun / moon / device icons 18.
  3. **Toggles** (rows 56–60, divided by 1.5 `line`): Sound effects (with a sub caption) and Vibration. Switch 56 × 34: track `success` on / `line` off, white 28 thumb. In RTL the on state sits at the start (left).
  4. **Profile row:** avatar 44, name 16/800, "Edit name & avatar" 12/600, chevron (mirrored) → 03.
- **Footer:** "Yalla Quiz · v1.0.0" 12/700 `inkMuted`, centred.

## 13 Empty & error states — `13_state_{reconnecting|host_left|room_not_found}_*`

- **`reconnecting`** (overlay on whatever game screen is showing; the PNG shows it over 08):
  - `YqBanner(warning)` pinned at top 56: spinner in `warning`, "Connection lost — reconnecting…" with body "Hang tight, your score is safe. The round pauses for you.", attempt counter "3/5".
  - Underlying content at 40% opacity and 30% saturation, and non-interactive.
  - The timer shows a pause glyph (the round is paused server-side).
  - Bottom: secondary "Retry now".
  - On success: switch to `YqBanner(success)` "Back online!" for 1.5 s, then remove it. After 5 failed attempts → `room_not_found`-style screen with "Back home".
- **`host_left`** and **`room_not_found`** (full screen):
  - Centred illustration 200: `surfaceAlt` circle radius 78 with answer-shape confetti, and a 76 stroke icon (door for host left, mirrored in RTL; magnifier for not found).
  - `headline` 28/900, then body 16/500 `inkMuted`.
  - Bottom stack (gap 14):
    - `host_left`: primary "Back home", secondary "Start a new room".
    - `room_not_found`: primary "Try another code" (→ 05), secondary "Home".
- **Animation:** the illustration scales in 0.9→1 over 240 ms (`snap`) and the text fades up.

---

## Host big screen (tablet 834 × 1194 / desktop 1440 × 900) — `screens/tablet/*`

Shown on a TV or laptop while players answer on their phones. Gutter 40.

**Shared top bar**
- Start: brand icon 44, wordmark 40, pill.
- End: room chip ("Room K7XP2Q", pill, `surface`, 17/800). A "4/10" chip appears in-game.

| File | Screen | Layout |
|---|---|---|
| `14_host_join_code_tablet` | Join | Centred card (radius 40, padding 56 × 40, `surface`, 2 `line`): "Join on your phone" 30/900, code 112/900 with 0.08em spacing, QR 300, steps line 20/700 `inkMuted`. Footer: avatar stack 56 plus "3 joined so far". |
| `15_host_lobby_tablet` | Lobby | Live dot 16 + "Waiting for your friends…" 42/900 + count 36/900. 3-column `YqPlayerTile` grid (tile 200, avatar 96, name 24/800, gap 20). Footer: QR 96 + code 30/900 at the start, primary "Start game" (76 tall, 24/800) at the end. |
| `16_host_question_tablet` | Question | Timer 176 centred, meta 18/800, question `hostQuestion` 50/900 (max width 700). 2 × 2 answer tiles (196 tall, radius 28, padding 24, icon 56, text `hostAnswer` 36/900, stomp 8), gap 20. Footer: answered avatar stack plus "5/8" and "Answer on your phone". |
| `17_host_reveal_tablet` | Reveal | Question 44/900. 2 × 2 tiles 220 tall: correct has a 6 `success` outline offset 5 and a 52 check; others at 35% opacity. Each tile has a 14 vote bar plus count. Bottom banner (`successSoft`, radius 28): fastest player avatar 64 + "Nour answered fastest" 26/900 + "+950" 44/900. |
| `18_host_leaderboard_tablet` | Leaderboard | Title 56/900. Eight rows 96 tall, avatar 62, text 28. Same reorder animation as 10. |
| `19_host_final_results_tablet` | Final | Title 52/900, podium at 1.45× the phone sizes, ranks 4–8 as 58-tall rows, confetti in the side margins. |

**Desktop (1440 × 900)**
- Same structure, with the question area and timer in one row: question 64/900 at the start, timer 200 at the end.
- Answers 2 × 2 at 168 tall with text 42.
- The lobby splits into a code + QR card (520 wide) beside the player grid.
