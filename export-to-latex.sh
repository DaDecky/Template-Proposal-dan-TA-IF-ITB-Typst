#!/usr/bin/env bash
# Script ekspor Laporan Typst ke LaTeX resmi Teknik Informatika ITB
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$DIR"

echo "==> Mengekspor naskah Typst ke LaTeX lengkap standar IF ITB..."
python3 export_latex.py

echo "==> Menguji kompilasi pdflatex pada naskah LaTeX hasil ekspor..."
cd latex-export
pdflatex -interaction=nonstopmode main.tex >/dev/null 2>&1 || true
pdflatex -interaction=nonstopmode main.tex
echo "==> Selesai! Berkas PDF LaTeX tersimpan di: $DIR/latex-export/main.pdf"
