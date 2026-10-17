#!/usr/bin/env bash
# Script konversi Laporan Typst ke LaTeX untuk Laporan TA IF ITB
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

# Salin berkas referensi BibTeX
if [ -f "$DIR/references.bib" ]; then
  echo "  - Menyalin references.bib ke $OUT_DIR/"
  cp "$DIR/references.bib" "$OUT_DIR/references.bib"
fi

# Buat master main.tex di dalam latex-export agar siap di-compile langsung dengan pdflatex
cat << 'EOF' > "$OUT_DIR/main.tex"
\documentclass[12pt, a4paper, onecolumn, oneside, final]{report}

\usepackage[top=3cm, bottom=3cm, left=4cm, right=3cm]{geometry}
\usepackage{mathptmx}
\usepackage{setspace}
\onehalfspacing

\usepackage[indonesian]{babel}
\usepackage{amsmath, amssymb}
\usepackage{calc}
\usepackage{array}
\providecommand{\ul}[1]{\underline{#1}}
\newcounter{none}
\usepackage{graphicx}
\usepackage{longtable, booktabs}
\usepackage{hyperref}
\usepackage[style=apa, backend=biber]{biblatex}
\addbibresource{references.bib}

\begin{document}

\input{01-pendahuluan.tex}
\input{02-studi-literatur.tex}
\input{03-analisis-perancangan.tex}
\input{04-implementasi-evaluasi.tex}
\input{05-kesimpulan-saran.tex}

\printbibliography

\appendix
\input{99-lampiran.tex}

\end{document}
EOF

echo "==> Selesai! Seluruh berkas LaTeX tersimpan di: $OUT_DIR"
echo "    Dapat diuji dengan: cd $OUT_DIR && pdflatex -interaction=nonstopmode main.tex"
