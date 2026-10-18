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
  currentQuestionIndex: int
  questionStartedAt: server timestamp     timer source of truth
  phaseStartedAt: server timestamp        countdown / reveal / leaderboard timing
  players/{uid}
    name (1–12), avatarSeed (0–7), joinedAt (server ts), connected   ← written by the player
    score, streak, lastPoints                                         ← written by the host only
  answers/{qIndex}/{uid}: { option: 0–3, answeredAt: server timestamp }
```
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
- **Answers.** `answers/$q/$uid` is accepted only when all of these hold:
  - it's written by that uid, who is a player, and no answer exists yet (one per player);
  - `status == 'question'` and `$q == currentQuestionIndex`;
  - `answeredAt == now`;
  - `now <= questionStartedAt + timePerQuestion*1000 + 1000` (1 s grace; scoring floors `timeLeft` at 0).
- **Validation.** Unknown fields are rejected everywhere.
- **Client-side checks.** The 8-player cap is checked when joining; a rare race can let a 9th player in, which is accepted. The answer key ships in the bundled assets, which is also accepted for now.

### Presence and host takeover
- **Presence.** While in a room, `RoomRepository.maintainPresence` listens to `.info/connected`. On every reconnect it arms `onDisconnect().update({connected: false})`, then sets `connected: true`.
- **Host drops.** The others wait `RoomRules.hostReconnectGrace` (10 s). Then the connected player with the earliest `joinedAt` claims host with a transaction on `hostId` (`HostSuccession` in `features/room/domain/services/`).
- **Host leaves deliberately.** Hand over to the successor and remove yourself in one multi-path update. If nobody else is left, delete the room.
- **Leftover rooms.** Without Functions, rooms everyone abandoned stay until a new room reuses the code after 2 h.

## UI conventions
- Screens use `YqScaffold` (dot grid, x14 top inset, gutter, bottom actions pinned below scrolling content). Phone-style screens are centred at 480 wide on tablet and desktop. Lobby switches to the host big-screen layout (spec 15) at ≥ 600.
- Component dimensions from `screens.md` that aren't tokens (e.g. tile 92, segment radius 14) are named constants inside the component, never inline magic numbers in screens.
- Avatar artwork data is in `lib/core/theme/yq_avatar_palette.dart` (extracted from the design source); category colours are in `features/room/presentation/widgets/category_style.dart`.
- **Placeholders.** `YqWordmark` and `YqHeroIllustration` (`core/widgets/yq_brand.dart`) show the brand mark until the Lalezar wordmark and the hero SVG land in `assets/images/`; swap them there only. The splash shows no wordmark until then.
- **Image assets.** Use the generated `Assets` (`lib/gen/assets.gen.dart`, flutter_gen) for image files.
- Haptics go through `getIt<Haptics>()`, which respects the Vibration setting.

## Workflow
- Run `flutter analyze` after every step and keep it at zero issues. `flutter test` must pass.
- After changing freezed/json models: `dart run build_runner build`.
- **Local Firebase.** Run `firebase emulators:start --only auth,database` (uses `database.rules.json`) and `flutter run --dart-define=YQ_EMULATOR=true`. For a physical device, add `--dart-define=YQ_EMULATOR_HOST=<your LAN IP>`.
- Don't edit the designer's theme files or the generated Firebase config.
