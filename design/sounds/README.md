# Voice recordings

Source recordings for the voice lines in `assets/sounds/voice/`. The app doesn't use these files directly.

- `voice_countdown_ar.mp3`: the Arabic "3, 2, 1, Yalla!". It was split into `voice_count_3_ar`, `voice_count_2_ar`, `voice_count_1_ar` and `voice_yalla_ar` with:

  ```
  python3 tool/split_countdown.py design/sounds/voice_countdown_ar.mp3 ar
  ```

  The script finds the three pauses between the four phrases, trims the silence at the start of each clip, and writes the clips at 24 kHz mono 96 kbps. The app plays each clip when its digit appears, so the countdown stays in sync however fast the voice speaks.

- English: record the same four phrases with pauses of at least 0.25 s between them, save the recording as `voice_countdown_en.mp3` here, and run the script with `en`.
