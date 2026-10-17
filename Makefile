.PHONY: all build watch export test-latex clean help

TYPST := typst
MAIN_SRC := main.typ
MAIN_PDF := main.pdf

# Default target: compile Typst to PDF
all: build

## build       : Mengompilasi naskah Typst menjadi berkas PDF (main.pdf)
build:
	@echo "==> Mengompilasi $(MAIN_SRC) -> $(MAIN_PDF)..."
	$(TYPST) compile $(MAIN_SRC) $(MAIN_PDF)
	@echo "==> Selesai! Output: $(MAIN_PDF)"

## watch       : Menjalankan live reload / watch mode untuk auto-compile saat disimpan
watch:
	@echo "==> Menjalankan Typst watch mode pada $(MAIN_SRC)..."
	$(TYPST) watch $(MAIN_SRC)

## export      : Mengonversi seluruh bab Typst ke berkas LaTeX (.tex)
export:
	@echo "==> Menjalankan ekspor Typst ke LaTeX..."
	./export-to-latex.sh

## test-latex  : Menguji kompilasi berkas hasil ekspor LaTeX dengan pdflatex
test-latex: export
	@echo "==> Menguji kompilasi berkas LaTeX hasil ekspor..."
	cd latex-export && pdflatex -interaction=nonstopmode main.tex
	@echo "==> Kompilasi LaTeX sukses! Output: latex-export/main.pdf"

## clean       : Membersihkan berkas build dan keluaran ekspor sementara
clean:
	@echo "==> Membersihkan berkas sementara..."
	rm -rf latex-export
	rm -f chapters/*.pdf
	rm -f *.log
	@echo "==> Bersih!"

## help        : Menampilkan panduan penggunaan perintah make
help:
	@echo "Panduan Perintah Makefile Tugas Akhir IF ITB (Typst):"
	@echo "  make build       - Kompilasi berkas Typst ke main.pdf"
	@echo "  make watch       - Pantau perubahan berkas dan auto-compile secara live"
	@echo "  make export      - Konversi bab-bab Typst ke berkas LaTeX (.tex)"
	@echo "  make test-latex  - Uji build naskah hasil ekspor dengan compiler pdflatex"
	@echo "  make clean       - Hapus direktori ekspor dan berkas sementara"
