#!/usr/bin/env bash
# Script konversi Bab Typst ke LaTeX untuk Laporan TA IF ITB
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
OUT_DIR="$DIR/latex-export"
mkdir -p "$OUT_DIR"

echo "==> Mengekspor bab Typst ke format LaTeX (.tex)..."

for f in "$DIR"/chapters/*.typ; do
  name="$(basename "$f" .typ)"
  out="$OUT_DIR/$name.tex"
  echo "  - Mengonversi $name.typ -> $name.tex"
  pandoc --from typst --to latex --top-level-division=chapter "$f" -o "$out"
done

echo "==> Selesai! Berkas LaTeX tersimpan di: $OUT_DIR"
