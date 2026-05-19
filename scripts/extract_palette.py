#!/usr/bin/env python3
"""Sample dominant colors from canonical frames using PIL quantize.

Outputs aggregated palette for Step 6 token derivation. Merges colors whose
Manhattan distance is <60 (not Euclidean — note this when comparing to ΔE).
"""
from __future__ import annotations

import json
from collections import Counter
from pathlib import Path

from PIL import Image

from lib.ids import fps_id_from_filename

SRC = Path("frames/selected")
ANALYSIS = Path("analysis")

QUANTIZE_K = 8
THUMB_SIZE = (128, 256)
MERGE_MANHATTAN = 60

canonical = []
for p in sorted(ANALYSIS.glob("frame_fps_*.json")):
    obj = json.loads(p.read_text())
    if "ref_canonical" not in obj:
        canonical.append(obj["frame_id"])

print(f"Canonical frames: {len(canonical)}")

frame_index = {fps_id_from_filename(p.name): p for p in SRC.glob("*.png")}


def quantize_palette(img_path: Path, k: int = QUANTIZE_K):
    img = Image.open(img_path).convert("RGB")
    img = img.resize(THUMB_SIZE, Image.LANCZOS)
    q = img.quantize(colors=k, method=Image.Quantize.MAXCOVERAGE)
    palette = q.getpalette()[:k * 3]
    color_counts = Counter(q.getdata())
    out = []
    for idx, count in color_counts.most_common(k):
        r, g, b = palette[idx * 3:idx * 3 + 3]
        out.append((f"#{r:02X}{g:02X}{b:02X}", count))
    return out


def hex2rgb(h: str) -> tuple[int, int, int]:
    return int(h[1:3], 16), int(h[3:5], 16), int(h[5:7], 16)


all_colors: Counter = Counter()
per_frame: dict[str, list[tuple[str, int]]] = {}
for fid in canonical:
    img_path = frame_index.get(fid)
    if not img_path:
        continue
    pal = quantize_palette(img_path)
    per_frame[fid] = pal
    for hex_color, count in pal:
        all_colors[hex_color] += count

merged: list[tuple[str, int, int, int, int]] = []
for hex_color, count in all_colors.most_common():
    r, g, b = hex2rgb(hex_color)
    matched = False
    for i, (mh, mc, mr, mg, mb) in enumerate(merged):
        if abs(r - mr) + abs(g - mg) + abs(b - mb) < MERGE_MANHATTAN:
            merged[i] = (mh, mc + count, mr, mg, mb)
            matched = True
            break
    if not matched:
        merged.append((hex_color, count, r, g, b))

merged.sort(key=lambda x: -x[1])

print("\nTop 25 merged colors across all canonicals:")
print("rank  hex      count       rgb")
for i, (h, c, r, g, b) in enumerate(merged[:25], 1):
    print(f"  {i:2d}.  {h}  {c:7d}   rgb({r:3d},{g:3d},{b:3d})")

out_data = {
    "canonical_count": len(canonical),
    "per_frame_palette": {fid: [c[0] for c in pal] for fid, pal in per_frame.items()},
    "aggregated_top25": [{"hex": h, "weight": c, "rgb": [r, g, b]} for h, c, r, g, b in merged[:25]],
}
Path("tokens/_palette_raw.json").write_text(json.dumps(out_data, indent=2, ensure_ascii=False))
print(f"\nSaved tokens/_palette_raw.json")
