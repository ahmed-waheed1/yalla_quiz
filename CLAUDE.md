# Yalla Quiz (يلا كويز)

Real-time multiplayer trivia app in Flutter for Android, iOS and Web. Bundle ID `com.ahmedwaheed.yallaquiz`. Firebase project `yalla-quiz-8b2a9`.

## Already set up (don't redo)
- Packages in `pubspec.yaml`, asset folders, bundled Cairo font (weights 500–900).
- Firebase config in `lib/firebase_options.dart`; Anonymous Auth and Realtime Database (europe-west1) are enabled. Spark plan; `cloud_functions` was removed and comes back with Blaze.
- App icon and native splash are generated.
- Folder skeleton under `lib/core/` and `lib/features/`.

## Design source of truth
- `lib/core/theme/` (`yq_colors.dart`, `yq_typography.dart`, `yq_spacing.dart`, `yq_theme.dart`) comes from the designer. **Use it as-is; don't edit it.** Never hardcode colors, sizes, radii, shadows, durations or text styles outside it. If a token is missing, ask instead of inventing one.
- `MaterialApp` uses `YqTheme.build(brightness, locale)` for both `theme` and `darkTheme`, passing `context.locale` from easy_localization so line heights rebuild when the language changes.
- In widgets: `context.yqColors`, `context.yqText`, `context.yqElevation`; `YqSpace`, `YqRadius`, `YqMotion`, and `YqElevation.stomp(...)`/`stompSecondary(...)` for constants.
- `design/app/screens.md` is the per-screen spec. **Before building a screen, read its section and look at its PNGs** in `design/app/screens/phone/` (and `design/app/screens/tablet/` for host screens), in both `_en` and `_ar`.
- Section 0 of `screens.md` (global rules + shared components) applies everywhere. Build shared components once in `lib/core/widgets/` (`YqButton`, `YqIconButton`, `YqChip`, `YqSegmented`, `YqCodeInput`, `YqAvatar`, `YqPlayerTile`, `YqCard`, `YqBanner`, `YqToast`, …) and reuse them.
- The Lalezar wordmark is an **image asset**, never a font. UI text is always Cairo.
- Ignore `design/store/` and `design/icon/` (store and icon assets only).

## Numbers
Scores, timer, room code, counts such as "4/10" always use Western digits 0–9, tabular figures, and LTR layout in both languages: use `YqTypography.numeric` / `code` / `timer` and wrap the number in `Directionality(textDirection: TextDirection.ltr)`. Never mirror the room code, scores, brand mark or answer shapes.

## Localization and RTL
- easy_localization with `en` and `ar` (full RTL). Translations in `assets/translations/{en,ar}.json`.
- No hardcoded user-facing strings: every string goes through a key (`'home.create_room'.tr()`).
- Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional` and `BorderRadiusDirectional` everywhere; never the non-directional variants.
- Mirror directional icons (back chevron, forward/enter arrows, list chevrons, "host left" door) in RTL.

## Stack
- State: flutter_bloc with **Cubits**.
- DI: get_it (`lib/core/di/`).
- Routing: go_router (`lib/core/router/`).
- Models: freezed + json_serializable (run `dart run build_runner build --delete-conflicting-outputs` after changing them).
- Errors: fpdart. Repositories return `Either<Failure, T>` (or a `TaskEither`); they don't throw.
- Responsive: flutter_screenutil plus `LayoutBuilder` breakpoints: phone < 600, tablet < 1024, desktop ≥ 1024.

## Architecture
Feature-first clean architecture:
```
lib/features/<feature>/
  data/          # data sources (RTDB, assets, prefs), DTOs, repository implementations
  domain/        # entities, repository interfaces, use cases if needed
  presentation/  # cubits, states, pages, feature widgets
lib/core/        # di, router, theme, constants, utils, services, widgets, network
```
Features: home, profile, room, lobby, game, results, settings. Presentation never imports `firebase_*` directly; it talks to repositories.

## Firebase (Spark plan: no Cloud Functions)
- The host device runs the game loop and calculates scores. All scoring lives in **one service** (`ScoringService`) with no Flutter or UI dependencies, so it can move to a Cloud Function later.
- Score = `correct ? 500 + 500 * timeLeft / duration : 0`.
- RTDB security rules (`database.rules.json`) are the referee: players can only write their own answer, once, for the current question, before time runs out.
- The timer is always computed from `questionStartedAt` (server timestamp) + `.info/serverTimeOffset`. Never use a local countdown as the source of truth.
- Presence uses `onDisconnect`. If the host leaves, reassign the host or close the room.
- Questions come from `assets/questions/*.json`; each question has `en` and `ar` text.

- **RTDB URL:** `kDatabaseUrl` in `lib/core/constants/app_constants.dart` (europe-west1). flutterfire doesn't write it to `firebase_options.dart`, which gets regenerated, so don't edit that file. DI registers `FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: kDatabaseUrl)`; always inject that instance and never use `FirebaseDatabase.instance`.
- **Presentation never touches Firebase.** RTDB access lives in `features/room/data/datasources/room_remote_data_source.dart`, behind `RoomRepository`.

### RTDB schema (approved)
```
rooms/{code}                     code: 6 chars, A–Z and 2–9 without O/0, I/1 (regex ^[A-HJ-NP-Z2-9]{6}$)
  hostId: uid
  status: lobby|countdown|question|reveal|leaderboard|finished
  createdAt: server timestamp
  settings: { category, questionCount: 5|10|15, timePerQuestion: 10|15|20, maxPlayers: 8 }
  questionIds: [questionId, ...]          host picks at game start; clients read the bundled asset by id
  usedQuestionIds/{questionId}: true      every id this room has played; "Play again" avoids them
  currentQuestionIndex: int
  scoredQuestionIndex: int                last question whose scores were written (scoring guard)
  questionStartedAt: server timestamp     timer source of truth
  phaseStartedAt: server timestamp        countdown / reveal / leaderboard timing
  players/{uid}
    name (1–12), avatarSeed (0–7), joinedAt (server ts), connected   ← written by the player
    spectator                                                         ← the host only, in the lobby
    score, streak, lastPoints                                         ← written by the host only
  answers/{qIndex}/{uid}: { option: 0–3, answeredAt: server timestamp }
```
- **Spectator host.** A host who chose "Host on big screen" has `spectator: true`: they can't answer and are left out of early advance, the leaderboard, the podium and the "2+ players to start" count (`Room.contestants`).
- **Answers** stay for the whole game (vote counts, fastest player) and are cleared when a game starts or restarts. RTDB returns `answers` as a list when the question keys are dense; `RoomModel` handles both shapes.
- **No question language in the room.** Every question has `en` and `ar`, and each player sees their own app language (`context.locale`), so mixed-language rooms work.
- **Profile is local.** Name and avatar live on the device in shared_preferences, not in RTDB.
- **Question files.** `assets/questions/<category>.json` is a list of `{ "id", "en": { "q", "options": [4] }, "ar": { "q", "options": [4] }, "answer": 0–3 }`. The available categories are the files listed in the asset manifest.

### Security rules (`database.rules.json`, deploy with `firebase deploy --only database`)
- **Reads.** Reading `rooms/` as a whole is denied, so codes can't be enumerated. Any authenticated user can read `rooms/$code`.
- **Create.** A write that creates `rooms/$code` needs `hostId == auth.uid` and either no room at that code or a `createdAt` more than 2 h old. A taken code gets `permission-denied` and the client retries with a new code.
- **Delete.** Only the host can delete the room.
- **Host-only fields.** `status`, `settings`, `questionIds`, `currentQuestionIndex`, `questionStartedAt`, `phaseStartedAt`, and every player's `score`/`streak`/`lastPoints`.
- **Joining.** A new `players/$uid` can only be created by that uid while `status == 'lobby'`, with `score == 0` and `joinedAt == now`.
- **Rejoining.** An existing player can rejoin at any status by setting `connected: true`, and keeps their score.
- **Leaving.** A player can delete their own node.
- **`hostId` changes.** The current host can hand over to an existing player. Any player can claim host when the current host's node is gone or has `connected == false`.
- **Phases.** `status` only moves lobby → countdown → question → reveal → leaderboard → question … and reveal → finished on the last question, then finished → lobby ("Play again"). Every change needs a fresh `phaseStartedAt` (and `questionStartedAt` when entering a question), and neither can be written without a status change, so a repeated phase write can't restart a timer. Countdown needs exactly `questionCount` `questionIds` and index 0; leaderboard → question needs index + 1. `currentQuestionIndex` only changes with a status change. `questionIds`/`usedQuestionIds` only change on lobby → countdown; `settings` only in the lobby.
- **Scoring (idempotent).** question → reveal must set `scoredQuestionIndex = currentQuestionIndex` in the same write, and `scoredQuestionIndex` only ever increases, so a question can be scored once. Each `score` must be its old value + the new `lastPoints`, in a write that moves `scoredQuestionIndex`, or 0 when the status becomes lobby/countdown.
- **Play again.** The host may delete players with `connected == false` in the write that returns to the lobby, and may delete the whole `answers` node (never single answers).
- **Answers.** `answers/$q/$uid` is accepted only when all of these hold:
  - it's written by that uid, who is a non-spectator player, and no answer exists yet (one per player);
  - `status == 'question'` and `$q == currentQuestionIndex`;
  - `answeredAt == now`;
  - `now <= questionStartedAt + timePerQuestion*1000 + 1000` (1 s grace; scoring floors `timeLeft` at 0).
- **Validation.** Unknown fields are rejected everywhere.
- **Tests.** `cd test/rules && npm install && npm test` runs `test/rules/rooms.test.js` against the RTDB emulator. Add a case for every rule change.
- **Client-side checks.** The 8-player cap is checked when joining; a rare race can let a 9th player in, which is accepted. The answer key ships in the bundled assets, which is also accepted for now.

### Presence and host takeover
- **Presence.** While in a room, `RoomRepository.maintainPresence` listens to `.info/connected`. On every reconnect it arms `onDisconnect().update({connected: false})`, then sets `connected: true`.
- **Host drops.** The others wait `RoomRules.hostReconnectGrace` (10 s). Then the connected player with the earliest `joinedAt` claims host with a transaction on `hostId` (`HostSuccession` in `features/room/domain/services/`).
- **Host leaves deliberately.** Hand over to the successor and remove yourself in one multi-path update. If nobody else is left, delete the room.
- **Game loop.** `GameEngine` (`features/game/domain/services/`) is the pure phase state machine: room in, next `GameCommand` (`room/domain/entities/game_command.dart`) and its due time out. `GameHostDriver` runs it on the host, scheduling on the injected `Clock`/`Scheduler` (`core/services/clock.dart`; `ServerClock` in the app, `FakeClock` in tests) and re-reading the latest snapshot when a timer fires, so a new host resumes from whatever phase RTDB is in. Each command is one multi-path update (`room/data/datasources/game_writes.dart`). Phase lengths are `GameTiming` in `app_constants.dart`. Game-loop tests run whole games on `FakeGameServer` (`test/helpers/`), which mirrors the rules.
- **Leftover rooms.** Without Functions, rooms everyone abandoned stay until a new room reuses the code after 2 h.

## UI conventions
- Screens use `YqScaffold` (dot grid, x14 top inset, gutter, bottom actions pinned below scrolling content). Phone-style screens are centred at 480 wide on tablet and desktop. Lobby switches to the host big-screen layout (spec 15) at ≥ 600.
- Component dimensions from `screens.md` that aren't tokens (e.g. tile 92, segment radius 14) are named constants inside the component, never inline magic numbers in screens.
- Toggles use `YqSwitch` (the "on" thumb is `surface` for contrast in dark).
- Avatar artwork data is in `lib/core/theme/yq_avatar_palette.dart` (extracted from the design source); category colours are in `features/room/presentation/widgets/category_style.dart`.
- **Brand artwork** (`core/widgets/yq_brand.dart`): `YqWordmark`, `YqHeroIllustration`, `YqYallaArtwork` and `YqBrandRow` use the SVGs in `assets/images/` through the generated `Assets.images` paths, picking light/dark by theme and en/ar by locale. Sizes and usage notes are in `design/brand/README.md`; the hero is never mirrored and the Yalla artwork is already tilted (the countdown animates on top). Use the SVGs only: the PNGs in `design/brand/2.0x/` are reference, not assets. `test/core/brand_assets_test.dart` checks which file each screen shows.
- **Image assets.** Use the generated `Assets` (`lib/gen/assets.gen.dart`, flutter_gen) for image files.
- Haptics go through `getIt<Haptics>()`, which respects the Vibration setting.
- **Screen awake.** `LobbyPage` wraps the room in `KeepScreenAwake` (wakelock_plus via `getIt<ScreenAwake>()`): on from the countdown to the final results, released in the lobby and on leaving. The host's device also shows "Keep this screen open" under the game (not on the countdown), since the game loop runs there.
- **Sounds** go through `getIt<SoundService>()` (`core/services/sound_service.dart`), which respects the Sound effects setting and skips files that aren't there. Drop these into `assets/sounds/`: `countdown_tick.mp3`, `yalla.mp3`, `lock_in.mp3`, `timer_tick.mp3`, `time_up.mp3`, `correct.mp3`, `wrong.mp3`, `leaderboard.mp3`, `victory.mp3`. In the game, `GameFeedback` pairs each moment with its haptic and sound.
- **Game screens.** `LobbyPage` (`/lobby/:code`) is the room for its whole life: it provides `LobbyCubit` (session, presence, host takeover) and `GameCubit`, and shows the lobby or `GameView` by `status`. `GameView` picks the phase screen; a spectator host on a screen ≥ 600 gets the big-screen layouts (16–19), everyone else the phone ones. Anything that changes with time (timers, countdowns, reveal suspense, podium timing) uses `GameTimeSelector`, which reads the server clock every frame and is timed from `phaseStartedAt`/`questionStartedAt`, so a reconnecting device lands on the right frame.
- **`inverse` is the night *panel* colour only** (home hero card, splash, the shuffle button). In dark it equals `surfaceAlt`. Selected/active states and toasts use **`ink` fill with `bg` text** instead, which is what the design canvas uses in both themes (`YqSegmented`, `YqToast`). Icons and text on `primary` use `onPrimary`. `test/core/contrast_test.dart` pins the WCAG ratios for every token pair the shared components use. Add new pairs there.
- **Route transitions.** Every route sets one via `YqTransitions.page` (`core/router/yq_transitions.dart`). Use `slide` for in-flow pushes (it enters from the end edge and mirrors in RTL), `fade` (fade-through) for context switches done with `go`, and `none` for hard cuts ("Yalla!" → question). All use `YqMotion.base` and `YqMotion.out`, with no animation under reduced motion. Unknown paths redirect to Home.
- **One Material library only.** The app (and the designer's theme files) use `package:flutter/material.dart`. Some newer packages are built on the standalone `material_ui` package instead (e.g. pinput 7, go_router 18's page detection, animations 3, google_fonts 9), whose `Material`/`MaterialApp`/`Theme` are *different types*: their widgets can't see our `Material` ancestors, theme or localizations. pinput was dropped for this reason (`YqCodeInput` is built on Flutter's `TextField`). Before using widgets from a package, check its imports for `package:material_ui`.

## Tests
- `test/screens/phase1_screens_test.dart` renders every screen and state in light and dark, `en` and `ar` (phone, plus tablet for the lobby) with fake repositories and fails on any `FlutterError`: missing ancestors, overflow, build exceptions. Add every new screen and state there.
- The harness (`test/helpers/pump_app.dart`) loads the real Cairo font so overflow checks match devices.
- **End to end.** `test/e2e/` plays a full 5-question game in the emulators with three browser sessions (big-screen host + an English and an Arabic phone player), including a timeout, a host drop with takeover and Play again, and checks every score in the database. Run it after changes to the game loop, rules or room flow: `cd test/e2e && npm install && npm run build && npm test` (see its README).

## Workflow
- **Branch per task.** Do each task on its own branch. When `flutter analyze` and `flutter test` are both clean, merge it into `main` (`--no-ff`) and delete the branch without asking.
- **Exception:** stop and ask before merging if the change touches the RTDB schema, `database.rules.json`, or dependencies (`pubspec.yaml`).
- Run `flutter analyze` and `flutter test` after every step; both must be clean.
- Run `dart format` on files you change; the repo is formatted at width 100 (`formatter: page_width` in `analysis_options.yaml`). Generated files (`*.g.dart`, `*.freezed.dart`, `lib/gen/`, `firebase_options.dart`) and the designer's theme files are left as they are.
- After changing freezed/json models: `dart run build_runner build`.
- **Local Firebase.** Run `firebase emulators:start --only auth,database` (uses `database.rules.json`) and `flutter run --dart-define=YQ_EMULATOR=true`. For a physical device, add `--dart-define=YQ_EMULATOR_HOST=<your LAN IP>`.
- Don't edit the designer's theme files or the generated Firebase config.

## Later
- **Answer privacy:** players can read `answers/` during a question, so a technical player could see others' picks. Accepted for a casual game; move answers server-side with Cloud Functions on Blaze.
- **iOS swipe-back:** in-flow pushes should use `CupertinoPage` on iOS so the swipe-back gesture works (`CupertinoPage` is from `package:flutter/cupertino.dart`, not material_ui). This can't be tested on Linux; do it when a Mac is available.
