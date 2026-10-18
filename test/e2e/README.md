# End-to-end game test

Plays a full 5-question game against the Firebase emulators with three
browser sessions, and checks the database after every question.

- **Host "Nour"**: a 1280×800 window, so the room defaults to *Host on big screen*.
- **Omar** (English) and **Salma** (Arabic): 390×844 phone windows, so the room is mixed-language.

What it covers:

- create → join through the invite link → start (5 questions, `usedQuestionIds` recorded);
- early advance once both players have answered;
- a question that runs out the timer (only Omar answers);
- the host closing their browser mid-question, Omar taking over, and that question scored once;
- every `lastPoints`/`score` checked against `500 + 500 * timeLeft / duration`, and `scoredQuestionIndex`;
- *Play again*: the dropped host pruned, scores reset, used questions kept, and the next game picking new ones.

## Run

Needs Node, the Firebase CLI, Flutter and Chrome.

```sh
cd test/e2e
npm install
npm run build   # flutter build web against the emulators (YQ_EMULATOR=true)
npm test        # starts the auth + database emulators, serves build/web on :8080, plays the game
```

It takes about two minutes and prints a `PASS`/`FAIL` line per check, ending with
`ALL CHECKS PASSED` (exit 0) or the number of failures (exit 1). Screenshots of
each step go to `test/e2e/shots/`.

Chrome defaults to `/usr/bin/google-chrome`; set `CHROME=/path/to/chrome` to use another.
Background timer throttling is turned off so every window behaves like a foreground
one (the host's game loop runs in its window).
