"""Frame id / filename helpers."""
from __future__ import annotations

import re
from pathlib import Path

_FPS_RE = re.compile(r"_fps_(\d+)\.png$")


def fps_id_from_filename(name: str) -> str:
    """`...prefix_fps_0094.png` -> `fps_0094`."""
    m = _FPS_RE.search(name)
    if not m:
        raise ValueError(f"no fps id in {name!r}")
    return f"fps_{m.group(1)}"


def frame_path_for(fps_id: str, src_dir: Path) -> Path | None:
    """Find the on-disk frame file matching a `fps_XXXX` id."""
    digits = fps_id.removeprefix("fps_")
    return next(src_dir.glob(f"*_fps_{digits}.png"), None)
