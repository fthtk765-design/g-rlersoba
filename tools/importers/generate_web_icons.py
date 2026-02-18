#!/usr/bin/env python3
"""Tek bir logo PNG'den Flutter Web favicon + PWA icon seti üretir.

Kullanım:
  python3 tools/importers/generate_web_icons.py \
    --src apps/public_site/web/icons/Icon-512.png \
    --web-root apps/public_site/web

Not:
- Pillow (PIL) gerekir.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image


def resize_square(im: Image.Image, size: int) -> Image.Image:
    return im.resize((size, size), resample=Image.LANCZOS)


def resize_maskable(im: Image.Image, size: int, safe_ratio: float = 0.78) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    inner = max(1, int(size * safe_ratio))
    art = im.resize((inner, inner), resample=Image.LANCZOS)
    x = (size - inner) // 2
    y = (size - inner) // 2
    canvas.alpha_composite(art, (x, y))
    return canvas


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", required=True, help="Kaynak logo PNG yolu")
    ap.add_argument("--web-root", required=True, help="Flutter web root (web klasörü)")
    ap.add_argument("--safe-ratio", type=float, default=0.78, help="Maskable safe-area oranı")
    args = ap.parse_args()

    src = Path(args.src)
    web_root = Path(args.web_root)
    icons_dir = web_root / "icons"

    img = Image.open(src).convert("RGBA")

    web_root.mkdir(parents=True, exist_ok=True)
    icons_dir.mkdir(parents=True, exist_ok=True)

    # index.html -> favicon.png (web root)
    resize_square(img, 48).save(web_root / "favicon.png", optimize=True)

    # PWA icons
    resize_square(img, 192).save(icons_dir / "Icon-192.png", optimize=True)
    resize_square(img, 512).save(icons_dir / "Icon-512.png", optimize=True)

    resize_maskable(img, 192, safe_ratio=args.safe_ratio).save(icons_dir / "Icon-maskable-192.png", optimize=True)
    resize_maskable(img, 512, safe_ratio=args.safe_ratio).save(icons_dir / "Icon-maskable-512.png", optimize=True)

    # opsiyonel: icons/favicon.png
    resize_square(img, 48).save(icons_dir / "favicon.png", optimize=True)

    print("OK:")
    print("-", web_root / "favicon.png")
    print("-", icons_dir / "Icon-192.png")
    print("-", icons_dir / "Icon-512.png")
    print("-", icons_dir / "Icon-maskable-192.png")
    print("-", icons_dir / "Icon-maskable-512.png")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
