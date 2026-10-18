# ITB Informatics Undergraduate Thesis (Tugas Akhir) Template in Typst

> ⚠️ **DISCLAIMER / WORK IN PROGRESS (WIP)**  
> Template ini masih dalam tahap **pengembangan aktif (Work in Progress)** dan merupakan proyek eksperimental independen untuk mahasiswa Teknik Informatika STEI ITB.  
> 
> Beberapa bagian tata letak, fungsi penomoran, atau alur ekspor ke LaTeX mungkin masih memiliki kekurangan atau sewaktu-waktu mengalami *breaking change*. Selalu periksa kembali dokumen hasil kompilasi PDF dengan pedoman penulisan resmi program studi.  
> 
> 💡 **Feel Free to Contribute!**  
> Jika Anda menemukan bug, anomali formatting, atau memiliki ide perbaikan (tata letak, sitasi, maupun skrip ekspor), silakan buat **Pull Request (PR)** atau buka **Issue**. Kontribusi dari teman-teman mahasiswa dan alumni sangat diapresiasi!

---

Template Typst untuk penyusunan **Laporan Tugas Akhir (TA) Program Studi Sarjana Teknik Informatika**, Sekolah Teknik Elektro dan Informatika (STEI), Institut Teknologi Bandung (ITB).

Template ini dirancang agar:
1. **Performa Tinggi**: Menggunakan engine Typst (berbasis Rust) dengan kompilasi cepat (~10-30 ms pada live reload) dan sintaks bersih.
2. **Sesuai Pedoman TA IF ITB**:
   - Margin format 4-3-3-3 (Kiri 4 cm, Atas 3 cm, Kanan 3 cm, Bawah 3 cm).
   - Tipografi Times New Roman 12 pt, spasi 1.5 baris, perataan rata kanan-kiri (*justified*).
   - Format penomoran judul bab baku: `BAB I: PENDAHULUAN`, subbab `I.1`, subsubbab `I.1.1`.
   - Lambang Ganesha ITB tepat 3.5 cm pada sampul luar.
   - Halaman depan (Abstrak, Kata Pengantar, Daftar Isi, Daftar Gambar, Daftar Tabel) bernomor Romawi kecil (`iii` dst.), bagian bab bernomor Arab (`1`, `2`, dst.).
   - Struktur 5 bab baku IF ITB:
     * BAB I: Pendahuluan (6 subbab wajib: Latar Belakang, Rumusan Masalah, Tujuan, Batasan Masalah, Metodologi, Sistematika Pembahasan).
     * BAB II: Studi Literatur.
     * BAB III: Analisis dan Perancangan Solusi.
     * BAB IV: Implementasi dan Evaluasi.
     * BAB V: Kesimpulan dan Saran.
3. **[TODO / Eksperimental] Konversi ke LaTeX Otomatis**: Mendukung ekspor otomatis bab-bab naskah ke format LaTeX (`.tex`) menggunakan skrip bawaan (`./export-to-latex.sh`). Fitur ini masih dalam tahap penyempurnaan aktif (WIP).

---

## Struktur Folder

```text
.
├── main.typ                  # Berkas dokumen utama (metadata & pemanggilan bab)
├── main.pdf                  # Pratinjau PDF hasil kompilasi
├── export-to-latex.sh        # Skrip otomatis ekspor Typst ke LaTeX (.tex)
├── template/
│   └── if-thesis.typ         # Tata letak, halaman muka, & aturan format IF ITB
├── chapters/                 # Berkas isi naskah per bab
│   ├── 01-pendahuluan.typ
│   ├── 02-studi-literatur.typ
│   ├── 03-analisis-perancangan.typ
│   ├── 04-implementasi-evaluasi.typ
│   └── 05-kesimpulan-saran.typ
├── assets/
│   └── logo-itb.jpg          # Lambang resmi Ganesha ITB (tinggi 3.5 cm)
└── .vscode/
    └── settings.json         # Konfigurasi auto-export PDF di VSCode (Tinymist)
```

---

## Cara Penggunaan

### 1. Prasyarat
Pastikan `typst` dan `pandoc` sudah terpasang.

### 2. Mengisi Data Dokumen
Buka berkas `main.typ`, lalu sesuaikan parameter pada blok berikut:
```typst
#show: if-thesis.with(
  title: "JUDUL TUGAS AKHIR ANDA",
  title-en: "YOUR THESIS TITLE IN ENGLISH",
  author: "NAMA LENGKAP",
  nim: "135XXXXX",
  advisor1: "Nama Pembimbing I, Gelar",
  nip1: "NIP Pembimbing I",
  advisor2: none, // Isi jika ada pembimbing kedua
  nip2: none,
  date: "Tanggal Pengesahan",
  month-year: "Bulan Tahun",
  ...
)
```

### 3. Kompilasi PDF
- **Kompilasi Manual**:
  ```bash
  typst compile main.typ main.pdf
  ```
- **Kompilasi Otomatis (Watch Mode / Live Reload)**:
  ```bash
  typst watch main.typ
  ```
  Setiap kali berkas `.typ` disimpan, berkas `main.pdf` akan langsung diperbarui.

- **Di VSCode / Cursor**:
  Pasang ekstensi **Tinymist Typst** (`myriad-dreamin.tinymist`). Dokumen akan otomatis di-export ke PDF setiap kali disimpan (`Ctrl + S`).

---

## Ekspor ke Format LaTeX (Eksperimental / WIP)

> ⚠️ **Catatan / TODO**: Fitur ekspor otomatis ke LaTeX ini masih bersifat **eksperimental (Work in Progress)** dan terus disempurnakan. Hasil konversi mungkin memerlukan penyesuaian manual terutama pada macro khusus, tabel kompleks, atau pemformatan sitasi sebelum dikompilasi dengan pdflatex.

Jika sewaktu-waktu naskah ingin dialihkan atau dimasukkan ke template LaTeX resmi ITB, jalankan:
```bash
./export-to-latex.sh
```
Skrip akan mengonversi semua bab di dalam folder `chapters/*.typ` menjadi berkas LaTeX (`.tex`) di dalam folder `latex-export/`:
- `= Pendahuluan` otomatis menjadi `\chapter{Pendahuluan}`
- `== Latar Belakang` otomatis menjadi `\section{Latar Belakang}`
- Formula matematika, tabel, dan daftar terkonversi ke sintaks LaTeX standar.
