#import "template/if-thesis.typ": if-thesis, appendix

#show: if-thesis.with(
  title: "<JUDUL TUGAS AKHIR>",
  title-en: "<ENGLISH THESIS TITLE>",
  author: "<NAMA MAHASISWA>",
  nim: "135XXXXX",
  advisor1: "<Nama Pembimbing I, Gelar>",
  nip1: "<NIP Pembimbing I>",
  advisor2: none, // Isi dengan "<Nama Pembimbing II, Gelar>" jika ada
  nip2: none,    // Isi dengan "<NIP Pembimbing II>" jika ada
  date: "<Tanggal Pengesahan>",
  month-year: "<Bulan Tahun>",
  abstract-id: [
    Tuliskan ringkasan abstrak bahasa Indonesia di sini. Abstrak memuat permasalahan yang dikaji, metode/teknik keinformatikaan yang digunakan untuk menyelesaikan masalah, hasil yang dicapai, dan kesimpulan. Panjang abstrak maksimal 300 kata dan ditulis dalam satu spasi.
  ],
  keywords-id: ("Kata Kunci 1", "Kata Kunci 2", "Kata Kunci 3"),
  abstract-en: [
    Write the English abstract here. It summarizes the research problem, methodology, key findings, and conclusions. Maximum 300 words, single-spaced.
  ],
  keywords-en: ("Keyword 1", "Keyword 2", "Keyword 3"),
  preface: [
    Puji dan syukur dipanjatkan ke hadirat Tuhan Yang Maha Esa atas berkat dan rahmat-Nya sehingga Laporan Tugas Akhir ini dapat diselesaikan. Penulis mengucapkan terima kasih yang sebesar-besarnya kepada:
    + Dosen Pembimbing yang telah memberikan bimbingan, arahan, dan masukan berharga.
    + Para dosen dan staf pengajar Program Studi Sarjana Teknik Informatika STEI ITB.
    + Rekan-rekan mahasiswa dan seluruh pihak yang telah mendukung pelaksanaan tugas akhir ini.
  ],
  glossary: [
    #figure(
      table(
        columns: (2.5cm, 1fr),
        align: (left, left),
        [Singkatan], [Keterangan],
        [AI], [Artificial Intelligence (Kecerdasan Buatan)],
        [API], [Application Programming Interface],
        [ITB], [Institut Teknologi Bandung],
        [STEI], [Sekolah Teknik Elektro dan Informatika],
        [TA], [Tugas Akhir],
      ),
      caption: [Daftar Singkatan yang Digunakan dalam Laporan],
    )
  ],
)

// ==========================================
// DAFTAR BAB ISI LAPORAN TEKNIK INFORMATIKA
// ==========================================

#include "chapters/01-pendahuluan.typ"
#include "chapters/02-studi-literatur.typ"
#include "chapters/03-analisis-perancangan.typ"
#include "chapters/04-implementasi-evaluasi.typ"
#include "chapters/05-kesimpulan-saran.typ"

// ==========================================
// DAFTAR PUSTAKA
// ==========================================

#pagebreak()
#bibliography("references.bib", style: "apa", title: [DAFTAR PUSTAKA])

// ==========================================
// LAMPIRAN
// ==========================================

#show: appendix
#include "chapters/99-lampiran.typ"
