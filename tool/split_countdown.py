"""Splits a spoken "3, 2, 1, Yalla!" recording into the four countdown clips.

Usage: python3 tool/split_countdown.py <recording.mp3> <lang>

Writes assets/sounds/voice/voice_count_3_<lang>.mp3, _count_2_, _count_1_ and
voice_yalla_<lang>.mp3. The recording must have exactly four phrases separated
by pauses of at least 0.25 s. Each clip starts at its first sound (leading
silence trimmed) and ends shortly after its phrase, so the app can play each
one exactly when its digit appears. Needs ffmpeg with libmp3lame.
"""
import re
import subprocess
import sys

GAP_DB = -40  # louder than this is speech when finding the pauses
GAP_SECONDS = 0.25
ONSET_DB = -50  # quieter than this is trimmed from each clip's start
PRE_ROLL = 0.02  # kept before the first sound
TAIL = 0.08  # kept after each phrase
FADE = 0.03
NAMES = ["count_3", "count_2", "count_1", "yalla"]


def ffmpeg(*args):
    return subprocess.run(
        ["ffmpeg", "-hide_banner", "-nostats", *args], capture_output=True, text=True, check=True
    ).stderr


def main(src, lang):
    log = ffmpeg("-i", src, "-af", f"silencedetect=n={GAP_DB}dB:d={GAP_SECONDS}", "-f", "null", "-")
    h, m, s = re.search(r"Duration: (\d+):(\d+):([\d.]+)", log).groups()
    duration = 3600 * int(h) + 60 * int(m) + float(s)
    starts = [float(s) for s in re.findall(r"silence_start: ([\d.]+)", log)]
    ends = [float(s) for s in re.findall(r"silence_end: ([\d.]+)", log)]
    # Pauses between phrases, not the silence at either end of the file.
    gaps = [(s, e) for s, e in zip(starts, ends) if s > 0.01 and e < duration - 0.1]
    if len(gaps) != 3:
        sys.exit(f"Expected 3 pauses between 4 phrases, found {len(gaps)}: {gaps}")

    bounds = [0.0] + [g for gap in gaps for g in gap] + [duration]
    for i, name in enumerate(NAMES):
        start, end = bounds[2 * i], bounds[2 * i + 1]
        end = min(end + TAIL, bounds[2 * i + 2] if i < 3 else duration)
        start = max(0.0, start - PRE_ROLL)
        out = f"assets/sounds/voice/voice_{name}_{lang}.mp3"
        length = end - start
        ffmpeg(
            "-y", "-ss", f"{start:.3f}", "-t", f"{length:.3f}", "-i", src,
            "-af",
            f"silenceremove=start_periods=1:start_threshold={ONSET_DB}dB:start_silence={PRE_ROLL},"
            f"areverse,afade=t=in:d={FADE},areverse",
            "-ac", "1", "-ar", "24000", "-c:a", "libmp3lame", "-b:a", "96k", out,
        )
        print(f"{out}: {start:.3f}–{end:.3f} s")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    main(sys.argv[1], sys.argv[2])
