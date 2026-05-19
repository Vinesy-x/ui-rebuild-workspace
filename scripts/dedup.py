#!/usr/bin/env python3
import shutil
import sys
from pathlib import Path
from PIL import Image
import imagehash

RAW_DIR = Path("frames/raw")
DEDUP_DIR = Path("frames/dedup")
THRESHOLD = 5

DEDUP_DIR.mkdir(parents=True, exist_ok=True)

paths = sorted(RAW_DIR.glob("*.png"))
print(f"Raw frames: {len(paths)}")

kept = []  # list of (path, hash)
removed = 0
for p in paths:
    try:
        h = imagehash.phash(Image.open(p))
    except Exception as e:
        print(f"  ! skip {p.name}: {e}", file=sys.stderr)
        continue
    is_dup = any((h - kh) < THRESHOLD for _, kh in kept)
    if is_dup:
        removed += 1
        continue
    kept.append((p, h))
    shutil.copy2(p, DEDUP_DIR / p.name)

print(f"Kept: {len(kept)}  Removed: {removed}")
print(f"Output: {DEDUP_DIR}")
