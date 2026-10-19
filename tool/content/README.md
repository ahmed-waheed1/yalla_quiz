# Question content tooling

Each generated category has a source file, `<category>_src.py`. `build.py` turns it into the app asset `assets/questions/<category>.json` and the review table `design/content/<category>_review.md`. Edit the source and rebuild; don't edit the JSON or the review file by hand. The generated categories are geography, food, movies_tv, music and football. `general.json` is hand-written and has no source.

## Source format

Each row in `Q` is:

```python
(
    "medium", "arab",                          # difficulty: easy | medium | hard; region: arab | intl
    "What's the capital of Oman?",             # English question
    ["Muscat", "Salalah", "Sohar", "Nizwa"],   # English options, the correct one FIRST
    "إيه عاصمة عُمان؟",                          # Arabic question
    ["مسقط", "صلالة", "صحار", "نزوى"],          # Arabic options, same order
    "HIGH", "",                                # confidence: HIGH | LOW; a note for the review
),
```

`build.py` places the correct option at a seeded position. Answers are spread 13/13/12/12 across the four positions, and no position repeats more than twice in a row. The other options keep their order. The seed is fixed per category, so a rebuild keeps every answer where it was.

## Edit a question

1. Change the row in `tool/content/<category>_src.py`, keeping the correct option first.
2. Rebuild from the repo root:

   ```sh
   python3 tool/content/build.py <category>        # or several: geography food …
   ```

3. Check the result with `git diff` and `flutter test`. `test/features/game/questions_asset_test.dart` checks the asset.

The build stops with an error unless the category still has exactly 50 questions, 20 easy, 20 medium and 10 hard, 20 arab and 30 intl, 4 distinct options per language, and no repeated question. Replace a question rather than adding one.

Question ids are positional (`<category>_001` is row 1). Inserting or removing a row renumbers every row after it and moves their answers. That's fine before a release, but afterwards prefer replacing a row in place.

## New category

1. Copy an existing `*_src.py` to `<category>_src.py`, and write `INTRO`, `REGION` and the 50 rows.
2. Add a seed for it to `SEEDS` in `build.py`.
3. Build it, then follow "Editing questions and adding a category" in the main [README](../../README.md).
