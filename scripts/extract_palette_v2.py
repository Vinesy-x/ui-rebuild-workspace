#!/usr/bin/env python3
"""v2 palette extraction — works directly on frames/selected (no analysis/*.json deps).

Quantizes each frame to 8 colors, aggregates across all frames, merges
similar colors (Manhattan distance < 60), and saves a REFERENCE_ONLY palette
JSON for design-brief.
"""
from __future__ import annotations

import json
from collections import Counter
from pathlib import Path
from PIL import Image

SRC = Path("frames/selected")
OUT = Path("design-brief/tokens/design-tokens.json")

QUANTIZE_K = 8
THUMB_SIZE = (128, 256)
MERGE_MANHATTAN = 60

OUT.parent.mkdir(parents=True, exist_ok=True)


def quantize_palette(img_path: Path, k: int = QUANTIZE_K):
    img = Image.open(img_path).convert("RGB")
    img = img.resize(THUMB_SIZE, Image.LANCZOS)
    q = img.quantize(colors=k, method=Image.Quantize.MAXCOVERAGE)
    palette = q.getpalette()[:k * 3]
    color_counts = Counter(q.getdata())
    return [
        (f"#{palette[i*3]:02X}{palette[i*3+1]:02X}{palette[i*3+2]:02X}", n)
        for i, n in color_counts.most_common(k)
    ]


def hex2rgb(h: str):
    return int(h[1:3], 16), int(h[3:5], 16), int(h[5:7], 16)


paths = sorted(SRC.glob("*.png"))
print(f"Sampling palette from {len(paths)} frames...")

all_colors: Counter = Counter()
per_frame = {}
for p in paths:
    pal = quantize_palette(p)
    per_frame[p.stem] = [c[0] for c in pal]
    for hex_color, count in pal:
        all_colors[hex_color] += count

merged = []
for hex_color, count in all_colors.most_common():
    r, g, b = hex2rgb(hex_color)
    matched = False
    for i, (mh, mc, mr, mg, mb) in enumerate(merged):
        if abs(r-mr) + abs(g-mg) + abs(b-mb) < MERGE_MANHATTAN:
            merged[i] = (mh, mc + count, mr, mg, mb)
            matched = True
            break
    if not matched:
        merged.append((hex_color, count, r, g, b))

merged.sort(key=lambda x: -x[1])

print("\nTop 20 colors:")
for i, (h, c, r, g, b) in enumerate(merged[:20], 1):
    print(f"  {i:2d}. {h}  ({c:6d})  rgb({r:3d},{g:3d},{b:3d})")

out_data = {
    "_meta": {
        "status": "REFERENCE_ONLY — palette facts extracted from the source video. NOT a binding token system.",
        "instructions_for_design": "Use these as starting reference. Feel free to rename, regroup, add, or discard. The PNG frames in analysis/ are the ultimate visual source of truth.",
        "extracted_from": f"{len(paths)} selected frames",
        "method": "PIL quantize k=8 → Manhattan-merge ΔE<60"
    },
    "palette_top_20": [
        {"hex": h, "weight": c, "rgb": [r, g, b]} for h, c, r, g, b in merged[:20]
    ],
    "per_frame_palette": per_frame
}
OUT.write_text(json.dumps(out_data, indent=2, ensure_ascii=False))
print(f"\nWrote {OUT}")
