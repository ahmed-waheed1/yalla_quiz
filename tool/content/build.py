"""Builds assets/questions/<category>.json and design/content/<category>_review.md
from tool/content/<category>_src.py, where the correct option is always listed first.

Usage (from the repo root): python3 tool/content/build.py <category> [<category> ...]

The source module defines Q (rows of difficulty, region, en q, en options,
ar q, ar options, confidence, note), INTRO (a sentence for the review) and
REGION (labels for "arab" and "intl")."""
import importlib
import json
import random
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
sys.path.insert(0, str(HERE))

# Fixed per category so rebuilding keeps every answer where it was.
SEEDS = {
    "geography": 20261019,
    "food": 20261020,
    "movies_tv": 20261021,
    "music": 20261022,
    "football": 20261023,
}


def build(category):
    if category not in SEEDS:
        sys.exit(f"No seed for {category!r}: add one to SEEDS in {Path(__file__).name}")
    src = importlib.import_module(f"{category}_src")
    Q, INTRO, REGION = src.Q, src.INTRO, src.REGION

    # --- sanity checks on the source ---
    assert len(Q) == 50, len(Q)
    difficulty = Counter(q[0] for q in Q)
    assert difficulty == {"easy": 20, "medium": 20, "hard": 10}, difficulty
    regions = Counter(q[1] for q in Q)
    assert regions == {"arab": 20, "intl": 30}, regions
    seen = set()
    for d, r, enq, eno, arq, aro, conf, note in Q:
        assert len(eno) == 4 and len(set(eno)) == 4, enq
        assert len(aro) == 4 and len(set(aro)) == 4, arq
        assert conf in ("HIGH", "LOW"), enq
        assert enq not in seen and arq not in seen, enq
        seen.update((enq, arq))

    # --- balanced answer positions: 13/13/12/12, shuffled, no run longer than 2 ---
    rng = random.Random(SEEDS[category])
    while True:
        positions = [0] * 13 + [1] * 13 + [2] * 12 + [3] * 12
        rng.shuffle(positions)
        if all(not (positions[i] == positions[i + 1] == positions[i + 2]) for i in range(48)):
            break

    def place(options, pos):
        """Moves options[0] (the correct one) to [pos]; the others keep their order."""
        rest = options[1:]
        return rest[:pos] + [options[0]] + rest[pos:]

    items = []
    for i, ((d, r, enq, eno, arq, aro, conf, note), pos) in enumerate(zip(Q, positions), 1):
        items.append({
            "id": f"{category}_{i:03d}",
            "en": {"q": enq, "options": place(eno, pos)},
            "ar": {"q": arq, "options": place(aro, pos)},
            "answer": pos,
            "meta": (d, r, conf, note, eno[0], aro[0]),
        })

    def dumps(o):
        return json.dumps(o, ensure_ascii=False).replace('","', '", "')

    lines = ["["]
    for i, it in enumerate(items):
        lines += [
            "  {",
            f'    "id": {dumps(it["id"])},',
            f'    "en": {{ "q": {dumps(it["en"]["q"])}, "options": {dumps(it["en"]["options"])} }},',
            f'    "ar": {{ "q": {dumps(it["ar"]["q"])}, "options": {dumps(it["ar"]["options"])} }},',
            f'    "answer": {it["answer"]}',
            "  }" + ("," if i < len(items) - 1 else ""),
        ]
    lines.append("]")
    text = "\n".join(lines) + "\n"
    for it, p in zip(items, json.loads(text)):
        assert p["en"]["options"][p["answer"]] == it["meta"][4]
        assert p["ar"]["options"][p["answer"]] == it["meta"][5]
    (REPO / "assets" / "questions" / f"{category}.json").write_text(text)

    # --- review table ---
    def cell(s):
        return s.replace("|", "\\|")

    def count(pred):
        return sum(1 for it in items if pred(it["meta"]))

    low = [it for it in items if it["meta"][2] == "LOW"]
    dist = Counter(it["answer"] for it in items)
    md = [
        f"# {category.capitalize()} questions — review",
        "",
        f"`assets/questions/{category}.json`: 50 questions. {INTRO}",
        "Difficulty and region are for review only; they aren't stored in the asset.",
        "",
        f"- **Mix:** {count(lambda m: m[1] == 'arab')} {REGION['arab']}, "
        f"{count(lambda m: m[1] == 'intl')} {REGION['intl'].lower()}.",
        f"- **Difficulty:** {count(lambda m: m[0] == 'easy')} easy, "
        f"{count(lambda m: m[0] == 'medium')} medium, {count(lambda m: m[0] == 'hard')} hard.",
        f"- **Correct answer position:** 0 → {dist[0]}, 1 → {dist[1]}, 2 → {dist[2]}, 3 → {dist[3]}.",
        "- **Confidence:** HIGH = sure of the fact and the wording in both languages. LOW = something to",
        "  check (the note says what).",
        "",
        "## Check first (LOW)",
        "",
    ]
    md += [f"- `{it['id']}` — {it['en']['q']} — {it['meta'][3]}" for it in low] or ["Nothing marked LOW."]
    md += [
        "",
        "## All questions",
        "",
        "| id | difficulty | region | English | Arabic | correct (en / ar) | confidence | notes |",
        "|---|---|---|---|---|---|---|---|",
    ]
    for it in items:
        d, r, conf, note, en_ok, ar_ok = it["meta"]
        md.append(
            f"| `{it['id']}` | {d} | {REGION[r]} | {cell(it['en']['q'])} | {cell(it['ar']['q'])} | "
            f"{cell(en_ok)} / {cell(ar_ok)} | {'**LOW**' if conf == 'LOW' else 'HIGH'} | {cell(note)} |"
        )
    (REPO / "design" / "content" / f"{category}_review.md").write_text("\n".join(md) + "\n")
    print(category, "positions", dict(sorted(dist.items())), "LOW", len(low))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    for name in sys.argv[1:]:
        build(name)
