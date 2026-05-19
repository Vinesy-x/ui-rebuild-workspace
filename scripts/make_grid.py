#!/usr/bin/env python3
"""Pack selected frames into per-batch thumbnail grids for classification."""
from pathlib import Path

from lib.grid import build_grid

SRC = Path("frames/selected")
BATCHES = [
    ("frames/_grid_part1.png", 0,   40),
    ("frames/_grid_part2.png", 40,  80),
    ("frames/_grid_part3.png", 80, 999),
]

paths = sorted(SRC.glob("*.png"))
print(f"Total: {len(paths)} frames")

for out_path, lo, hi in BATCHES:
    subset = [(p, f"{i+1:03d}") for i, p in enumerate(paths) if lo <= i < hi]
    if not subset:
        continue
    size = build_grid(out_path, subset, cols=5)
    print(f"Wrote {out_path}  size={size}  frames={len(subset)}")
