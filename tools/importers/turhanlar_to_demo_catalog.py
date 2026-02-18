#!/usr/bin/env python3
"""Turhanlar Soba Şömine -> GürlerSobaProje demo katalog dönüştürücü.

Bu script, https://www.turhanlarsobasomine.com.tr sitesindeki ürün sayfalarını
(doksobaN.html + sacsobaN.html) okuyup Flutter demo katalog verisini üretir.

Kullanım:
  python3 tools/importers/turhanlar_to_demo_catalog.py \
    --out packages/shared/lib/src/repos/demo_catalog_data.dart

Notlar:
- Sadece yetkili olduğunuz içerikler için kullanın.
- Ağ erişimi gerekir.
"""

from __future__ import annotations

import argparse
import html as html_lib
import os
import re
import sys
import time
import urllib.parse
import urllib.request
from dataclasses import dataclass
from typing import Iterable

BASE = "https://www.turhanlarsobasomine.com.tr/"


@dataclass(frozen=True)
class ParsedProduct:
    url: str
    category_name: str
    category_slug: str
    name: str
    slug: str
    short_desc: str | None
    long_desc_md: str | None
    dimensions_w: float | None
    dimensions_h: float | None
    dimensions_d: float | None
    image_urls: list[str]
    pdf_urls: list[str]


def fetch(url: str, *, timeout: int = 25) -> str:
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": "GurlersobaProjeImporter/1.0 (+https://gurlersoba.com)"
        },
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        data = resp.read()
    return data.decode(charset, "ignore")


def download(url: str, dest_path: str, *, timeout: int = 40) -> None:
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": "GurlersobaProjeImporter/1.0 (+https://gurlersoba.com)"
        },
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        data = resp.read()
    with open(dest_path, "wb") as f:
        f.write(data)


_TAG_RE = re.compile(r"<[^>]+>")


def strip_tags(html: str) -> str:
    return _TAG_RE.sub("", html)


def first_tag_text(html: str, tag: str) -> str | None:
    m = re.search(fr"<{tag}[^>]*>(.*?)</{tag}>", html, re.I | re.S)
    if not m:
        return None
    txt = strip_tags(m.group(1))
    txt = html_lib.unescape(txt).strip()
    return re.sub(r"\s+", " ", txt)


def slugify(text: str) -> str:
    text = text.strip().lower()
    # TR karakter normalize
    text = (
        text.replace("ı", "i")
        .replace("İ", "i")
        .replace("ş", "s")
        .replace("ğ", "g")
        .replace("ü", "u")
        .replace("ö", "o")
        .replace("ç", "c")
    )
    # & vb
    text = text.replace("&", " ve ")
    # alfanümerik + boşluk + tire dışını at
    text = re.sub(r"[^a-z0-9\s-]", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    text = text.replace(" ", "-")
    text = re.sub(r"-+", "-", text)
    return text


def private_lower_camel_from_slug(prefix: str, slug: str) -> str:
    parts = [p for p in slug.split("-") if p]
    if not parts:
        return prefix
    return prefix + "".join(p[:1].upper() + p[1:] for p in parts)


def make_abs(url: str, base: str) -> str:
    return urllib.parse.urljoin(base, url)


def extract_links(html: str) -> list[str]:
    return re.findall(r'href=["\"]([^"\"]+)["\"]', html, re.I)


def extract_imgs(html: str) -> list[str]:
    return re.findall(r'<img[^>]+src=["\"]([^"\"]+)["\"]', html, re.I)


def extract_product_text_md(html: str) -> str | None:
    # İlk h2'dan sonra gelen div.text içeriğini al
    m_h2 = re.search(r"</h2>", html, re.I)
    if not m_h2:
        return None
    after = html[m_h2.end() :]
    m_div = re.search(r'<div\s+class=["\"]text["\"][^>]*>(.*?)</div>', after, re.I | re.S)
    if not m_div:
        return None
    inner = m_div.group(1)

    inner = inner.replace("<br>", "\n").replace("<br/>", "\n").replace("<br />", "\n")
    inner = re.sub(r"</p\s*>", "\n\n", inner, flags=re.I)
    inner = re.sub(r"<p[^>]*>", "", inner, flags=re.I)

    # strong -> başlık gibi
    inner = re.sub(r"<\s*strong\s*>", "**", inner, flags=re.I)
    inner = re.sub(r"<\s*/\s*strong\s*>", "**", inner, flags=re.I)

    text = strip_tags(inner)
    text = html_lib.unescape(text)

    # madde işaretleri
    lines = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            lines.append("")
            continue
        if line.startswith("•"):
            line = "- " + line.lstrip("•").strip()
        lines.append(line)

    out = "\n".join(lines)
    out = re.sub(r"\n{3,}", "\n\n", out).strip()
    return out or None


def extract_badge_short_desc(html: str) -> str | None:
    # Ürün metninden sonra gelen span içinde tek satır bir motto var
    # Sadece kısa ve anlamlıysa al.
    # (Örn: ŞIK VE FONKSİYONEL TASARIM)
    m = re.search(r"<span[^>]*>(.*?)</span>", html, re.I | re.S)
    if not m:
        return None
    txt = strip_tags(m.group(1))
    txt = html_lib.unescape(txt).strip()
    txt = re.sub(r"\s+", " ", txt)
    if not txt:
        return None
    if len(txt) > 90:
        return None
    # footer/social vb kaçın
    if any(x in txt.lower() for x in ["copyright", "adres", "bülten"]):
        return None
    return txt


_NUM_RE = re.compile(r"(\d+(?:[\.,]\d+)?)")


def _find_cm_value(text: str, label: str) -> float | None:
    # label: Yükseklik/Genişlik/En/Derinlik
    m = re.search(label + r"\s*:\s*(\d+(?:[\.,]\d+)?)\s*cm", text, re.I)
    if not m:
        return None
    val = m.group(1).replace(",", ".")
    try:
        return float(val)
    except ValueError:
        return None


def parse_product(url: str) -> ParsedProduct | None:
    html = fetch(url)

    category_name = first_tag_text(html, "h1") or "Ürünler"
    name = first_tag_text(html, "h2")
    if not name:
        return None

    category_slug = slugify(category_name)
    slug = slugify(name)

    long_desc_md = extract_product_text_md(html)
    short_desc = extract_badge_short_desc(html)

    # dimensions from long_desc
    h = w = d = None
    if long_desc_md:
        h = _find_cm_value(long_desc_md, "Yükseklik")
        w = _find_cm_value(long_desc_md, "Genişlik")
        d = _find_cm_value(long_desc_md, "Derinlik")
        if d is None:
            d = _find_cm_value(long_desc_md, "En")

    imgs = []
    for src in extract_imgs(html):
        src_low = src.lower()
        if not src_low.endswith((".jpg", ".jpeg", ".png", ".webp")):
            continue
        if "assets/images/" in src_low:
            continue
        if "logo" in src_low:
            continue
        abs_url = make_abs(src, url)
        if abs_url not in imgs:
            imgs.append(abs_url)

    pdfs = []
    for href in extract_links(html):
        if not href.lower().endswith(".pdf"):
            continue
        abs_url = make_abs(href, url)
        if abs_url not in pdfs:
            pdfs.append(abs_url)

    return ParsedProduct(
        url=url,
        category_name=category_name,
        category_slug=category_slug,
        name=name,
        slug=slug,
        short_desc=short_desc,
        long_desc_md=long_desc_md,
        dimensions_w=w,
        dimensions_h=h,
        dimensions_d=d,
        image_urls=imgs,
        pdf_urls=pdfs,
    )


def discover_product_urls() -> list[str]:
    # Liste sayfaları link veriyor: dokumsoba.html => doksoba1..8, sacsoba.html => sacsoba1..4
    urls: set[str] = set()
    for listing in ["dokumsoba.html", "sacsoba.html"]:
        listing_url = urllib.parse.urljoin(BASE, listing)
        html = fetch(listing_url)
        for href in extract_links(html):
            if not href.lower().endswith(".html"):
                continue
            abs_url = make_abs(href, listing_url)
            if re.search(r"/(dok|sac)soba\d+\.html$", abs_url):
                urls.add(abs_url)
    # stabil sıralama
    return sorted(urls)


def _dart_str(s: str) -> str:
    # Tek tırnaklı Dart string. Dart tek tırnaklı string literal'lerinde ham newline
    # olamaz; bu yüzden satır sonlarını \n kaçışına çeviriyoruz.
    s = s.replace("\\", "\\\\")
    s = s.replace("'", "\\'")
    s = s.replace("\r\n", "\n").replace("\r", "\n")
    s = s.replace("\n", "\\n")
    return "'" + s + "'"


def generate_dart(products: list[ParsedProduct]) -> str:
    # Categories
    categories_by_slug: dict[str, str] = {}
    for p in products:
        categories_by_slug[p.category_slug] = p.category_name

    category_slugs = sorted(categories_by_slug.keys())

    lines: list[str] = []
    lines.append("// GENERATED CODE - DO NOT MODIFY BY HAND.")
    lines.append("// Üretim: tools/importers/turhanlar_to_demo_catalog.py")
    lines.append("")
    lines.append("import '../models/category.dart';")
    lines.append("import '../models/product.dart';")
    lines.append("import '../models/product_media.dart';")
    lines.append("")

    # category consts
    for idx, cslug in enumerate(category_slugs, start=1):
        cid = f"cat_{cslug}"
        cname = categories_by_slug[cslug]
        const_name = private_lower_camel_from_slug("_cat", cslug)
        lines.append(f"const {const_name} = Category(")
        lines.append(f"  id: {_dart_str(cid)},")
        lines.append(f"  name: {_dart_str(cname)},")
        lines.append(f"  slug: {_dart_str(cslug)},")
        lines.append(f"  sortOrder: {idx},")
        lines.append("  isActive: true,")
        lines.append(");")
        lines.append("")

    lines.append("const List<Category> demoCategories = <Category>[")
    for cslug in category_slugs:
        const_name = private_lower_camel_from_slug("_cat", cslug)
        lines.append(f"  {const_name},")
    lines.append("];\n")

    # products
    lines.append("const List<Product> demoProducts = <Product>[")
    # featured: ilk 6 ürün
    featured_set = {p.slug for p in products[:6]}

    for p in products:
        pid = f"prd_{p.slug}"
        cid = f"cat_{p.category_slug}"
        lines.append("  Product(")
        lines.append(f"    id: {_dart_str(pid)},")
        lines.append(f"    categoryId: {_dart_str(cid)},")
        lines.append(f"    name: {_dart_str(p.name)},")
        lines.append(f"    slug: {_dart_str(p.slug)},")
        if p.short_desc:
            lines.append(f"    shortDesc: {_dart_str(p.short_desc)},")
        if p.long_desc_md:
            lines.append(f"    longDesc: {_dart_str(p.long_desc_md)},")
        # dimensions
        dims_parts = []
        if p.dimensions_w is not None:
            dims_parts.append(f"w: {p.dimensions_w:g}")
        if p.dimensions_h is not None:
            dims_parts.append(f"h: {p.dimensions_h:g}")
        if p.dimensions_d is not None:
            dims_parts.append(f"d: {p.dimensions_d:g}")
        if dims_parts:
            lines.append(f"    dimensions: ProductDimensions({', '.join(dims_parts)}),")
        lines.append(f"    isFeatured: {'true' if p.slug in featured_set else 'false'},")
        lines.append("    isPublished: true,")
        lines.append("  ),")
    lines.append("];\n")

    # media
    lines.append("const List<ProductMedia> demoMedia = <ProductMedia>[")
    for p in products:
        pid = f"prd_{p.slug}"
        order = 0
        for i, img in enumerate(p.image_urls):
            mid = f"med_{p.slug}_img_{i+1}"
            lines.append("  ProductMedia(")
            lines.append(f"    id: {_dart_str(mid)},")
            lines.append(f"    productId: {_dart_str(pid)},")
            lines.append("    kind: ProductMediaKind.image,")
            lines.append(f"    url: {_dart_str(img)},")
            lines.append(f"    altText: {_dart_str(p.name)},")
            lines.append(f"    sortOrder: {order},")
            lines.append("  ),")
            order += 1
        for j, pdf in enumerate(p.pdf_urls):
            mid = f"med_{p.slug}_pdf_{j+1}"
            lines.append("  ProductMedia(")
            lines.append(f"    id: {_dart_str(mid)},")
            lines.append(f"    productId: {_dart_str(pid)},")
            lines.append("    kind: ProductMediaKind.pdf,")
            lines.append(f"    url: {_dart_str(pdf)},")
            lines.append(f"    altText: {_dart_str('PDF - ' + p.name)},")
            lines.append(f"    sortOrder: {order},")
            lines.append("  ),")
            order += 1

    lines.append("];\n")
    return "\n".join(lines)


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--out",
        required=True,
        help="Dart çıktı dosyası (örn: packages/shared/lib/src/repos/demo_catalog_data.dart)",
    )
    ap.add_argument(
        "--sleep",
        type=float,
        default=0.25,
        help="İstekler arası bekleme (sn)",
    )
    ap.add_argument(
        "--download-images-dir",
        default=None,
        help="Görselleri indireceğiniz klasör (örn: apps/public_site/web/imported/turhanlar)",
    )
    ap.add_argument(
        "--image-url-prefix",
        default=None,
        help="Dart içinde kullanılacak görsel URL prefix'i (örn: /imported/turhanlar)",
    )
    args = ap.parse_args(argv)

    urls = discover_product_urls()
    if not urls:
        print("Ürün linki bulunamadı.", file=sys.stderr)
        return 2

    parsed: list[ParsedProduct] = []
    for url in urls:
        try:
            p = parse_product(url)
        except Exception as e:  # noqa: BLE001
            print(f"Hata: {url}: {e}", file=sys.stderr)
            continue
        if p is None:
            print(f"Atlandı (ürün değil): {url}", file=sys.stderr)
            continue
        parsed.append(p)
        time.sleep(args.sleep)

    if args.download_images_dir:
        prefix = args.image_url_prefix or ""
        prefix = prefix.rstrip("/")
        download_dir = args.download_images_dir
        rewritten: list[ParsedProduct] = []
        for p in parsed:
            new_imgs: list[str] = []
            for src in p.image_urls:
                base_name = urllib.parse.urlparse(src).path.split("/")[-1]
                base_name = re.sub(r"[^A-Za-z0-9._-]", "_", base_name)
                file_name = f"{p.slug}_{base_name}" if base_name else f"{p.slug}.jpg"
                dest_path = os.path.join(download_dir, file_name)
                try:
                    if not os.path.exists(dest_path):
                        download(src, dest_path)
                        time.sleep(args.sleep)
                except Exception as e:  # noqa: BLE001
                    print(f"Görsel indirilemedi: {src}: {e}", file=sys.stderr)
                    continue
                if prefix:
                    new_imgs.append(f"{prefix}/{file_name}")
                else:
                    new_imgs.append(file_name)

            rewritten.append(
                ParsedProduct(
                    url=p.url,
                    category_name=p.category_name,
                    category_slug=p.category_slug,
                    name=p.name,
                    slug=p.slug,
                    short_desc=p.short_desc,
                    long_desc_md=p.long_desc_md,
                    dimensions_w=p.dimensions_w,
                    dimensions_h=p.dimensions_h,
                    dimensions_d=p.dimensions_d,
                    image_urls=new_imgs,
                    pdf_urls=p.pdf_urls,
                )
            )
        parsed = rewritten

    # stabil: kategori + isim sırası
    parsed.sort(key=lambda x: (x.category_name.lower(), x.name.lower()))

    dart = generate_dart(parsed)

    out_path = args.out
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(dart)

    print(f"Yazıldı: {out_path} (ürün: {len(parsed)})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
