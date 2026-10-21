// ==============================================================================
// Template Tugas Akhir Program Studi Sarjana Teknik Informatika
// Sekolah Teknik Elektro dan Informatika (STEI)
// Institut Teknologi Bandung (ITB)
// ==============================================================================

#let in-appendix = state("in-appendix", false)

#let appendix(body) = {
  in-appendix.update(true)
  counter(heading).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)
  set heading(numbering: (..nums) => {
    let list = nums.pos()
    if list.len() == 1 {
      "LAMPIRAN " + numbering("A", ..nums)
    } else {
      numbering("A.1", ..list)
    }
  })

  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    pagebreak(weak: true)
    v(1cm)
    align(center)[
      #set par(first-line-indent: 0pt)
      #text(size: 14pt, weight: "bold")[
        #if it.numbering != none {
          counter(heading).display(it.numbering)
          [\ ]
        }
        #upper(it.body)
      ]
    ]
    v(1.5em)
  }

  show heading.where(level: 2): it => block(width: 100%, breakable: false, above: 1.5em, below: 1em)[
    #set par(first-line-indent: 0pt)
    #text(size: 12pt, weight: "bold")[
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        [ ]
      }
      #it.body
    ]
  ]

  show heading.where(level: 3): it => block(width: 100%, breakable: false, above: 1.2em, below: 0.8em)[
    #set par(first-line-indent: 0pt)
    #text(size: 12pt, weight: "bold")[
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        [ ]
      }
      #it.body
    ]
  ]

  show heading.where(level: 4): it => block(width: 100%, breakable: false, above: 1em, below: 0.6em)[
    #set par(first-line-indent: 0pt)
    #text(size: 12pt, weight: "bold")[
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        [ ]
      }
      #it.body
    ]
  ]

  body
}

#let if-thesis(
  title: "<JUDUL TUGAS AKHIR>",
  title-en: "<ENGLISH THESIS TITLE>",
  author: "<NAMA MAHASISWA>",
  nim: "135XXXXX",
  advisor1: "<Nama Pembimbing I, Gelar>",
  nip1: "<NIP Pembimbing I>",
  advisor2: none,
  nip2: none,
  date: "<Tanggal Pengesahan>",
  month-year: "<Bulan Tahun>",
  abstract-id: none,
  keywords-id: (),
  abstract-en: none,
  keywords-en: (),
  preface: none,
  glossary: none,
  font: "Liberation Serif",
  body
) = {
  // --- 1. Pengaturan Kertas & Batas Margin (Standar ITB: Kiri 4cm, Atas 3cm, Kanan 3cm, Bawah 3cm) ---
  set page(
    paper: "a4",
    margin: (left: 4cm, top: 3cm, right: 3cm, bottom: 3cm),
  )

  // --- 2. Tipografi (Times-equivalent 12pt, Spasi 1.5, Justified) ---
  set text(
    font: font,
    size: 12pt,
    lang: "id",
  )
  set par(
    justify: true,
    leading: 1.25em,
    first-line-indent: (amount: 1.25cm, all: true),
  )

  // --- 3. Format Penomoran Gambar, Tabel, dan Persamaan ---
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: image): set figure(supplement: [Gambar])
  show figure.where(kind: table): set figure(supplement: [Tabel])
  set math.equation(supplement: [Persamaan])

  set figure(numbering: n => context {
    let loc = here()
    let is-app = in-appendix.at(loc)
    let ch = counter(heading).get().first()
    let ch-str = if is-app { numbering("A", ch) } else if ch > 0 { str(ch) } else { "" }
    if ch-str != "" { [#ch-str.#n] } else { [#n] }
  })

  set math.equation(numbering: n => context {
    let loc = here()
    let is-app = in-appendix.at(loc)
    let ch = counter(heading).get().first()
    let ch-str = if is-app { numbering("A", ch) } else if ch > 0 { str(ch) } else { "" }
    if ch-str != "" { [(#ch-str.#n)] } else { [(#n)] }
  })

  show outline: it => {
    set par(first-line-indent: 0pt, justify: false, leading: 1em)
    it
  }

  show list: set par(first-line-indent: 0pt)
  show enum: set par(first-line-indent: 0pt)

  show outline.entry: it => context {
    if it.element.func() == figure and (it.element.kind == image or it.element.kind == table) {
      let fig = it.element
      let loc = fig.location()
      let is-app = in-appendix.at(loc)
      let ch = counter(heading).at(loc).first()
      let ch-str = if is-app { numbering("A", ch) } else if ch > 0 { str(ch) } else { "" }
      let k = if fig.kind == image { "Gambar" } else { "Tabel" }
      let n = counter(figure.where(kind: fig.kind)).at(loc).first()
      let num = if ch-str != "" { ch-str + "." + str(n) } else { str(n) }
      let label-text = k + " " + num

      block(width: 100%, breakable: false, below: 0.8em)[
        #set par(first-line-indent: 0pt, hanging-indent: 2.4cm, justify: false)
        #link(loc)[#box(width: 2.4cm)[#label-text]#fig.caption.body]
        #box(width: 1fr, it.fill)
        #it.page()
      ]
    } else {
      it
    }
  }

  // --- 4. Format Penomoran Bab & Subbab Teknik Informatika ITB ---
  set heading(numbering: (..nums) => {
    let list = nums.pos()
    if list.len() == 1 {
      "BAB " + numbering("I", ..nums)
    } else {
      numbering("I.1", ..list)
    }
  })

  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    pagebreak(weak: true)
    v(1cm)
    align(center)[
      #set par(first-line-indent: 0pt, justify: false)
      #text(size: 14pt, weight: "bold")[
        #if it.numbering != none {
          counter(heading).display(it.numbering)
          [\ ]
        }
        #upper(it.body)
      ]
    ]
    v(1.5em)
  }

  show heading.where(level: 2): it => block(width: 100%, breakable: false, above: 1.5em, below: 1em)[
    #set par(first-line-indent: 0pt, justify: false)
    #text(size: 12pt, weight: "bold")[
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        [ ]
      }
      #it.body
    ]
  ]

  show heading.where(level: 3): it => block(width: 100%, breakable: false, above: 1.2em, below: 0.8em)[
    #set par(first-line-indent: 0pt, justify: false)
    #text(size: 12pt, weight: "bold")[
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        [ ]
      }
      #it.body
    ]
  ]

  show heading.where(level: 4): it => block(width: 100%, breakable: false, above: 1em, below: 0.6em)[
    #set par(first-line-indent: 0pt, justify: false)
    #text(size: 12pt, weight: "bold")[
      #if it.numbering != none {
        counter(heading).display(it.numbering)
        [ ]
      }
      #it.body
    ]
  ]

  // ==========================================
  // HALAMAN SAMPUL / COVER (Tanpa Nomor Halaman)
  // ==========================================
  [
    #set page(numbering: none)
    #set par(first-line-indent: 0pt, leading: 0.9em, justify: false)
    #align(center + top)[
      #v(0.5cm)
      #text(size: 14pt, weight: "bold")[
        #upper(title)
      ]

      #v(1.8cm)
      #text(size: 14pt, weight: "bold")[
        LAPORAN TUGAS AKHIR
      ]

      #v(1.2cm)
      #text(size: 12pt)[
        Disusun sebagai syarat kelulusan tingkat sarjana
      ]

      #v(1.2cm)
      #text(size: 12pt)[
        Oleh\
        #v(0.4cm)
        #text(size: 14pt, weight: "bold")[#upper(author)]\
        #v(0.2cm)
        NIM : #nim
      ]

      #v(1.5cm)
      #image("../assets/logo-itb.jpg", height: 3.5cm)

      #v(1.5cm)
      #text(size: 12pt, weight: "bold")[
        PROGRAM STUDI SARJANA TEKNIK INFORMATIKA\
        SEKOLAH TEKNIK ELEKTRO DAN INFORMATIKA\
        INSTITUT TEKNOLOGI BANDUNG\
        #month-year
      ]
    ]
  ]

  // ==========================================
  // LEMBAR PENGESAHAN (Tanpa Nomor Halaman)
  // ==========================================
  pagebreak()
  [
    #set page(numbering: none)
    #set par(first-line-indent: 0pt, leading: 0.9em, justify: false)
    #align(center + top)[
      #v(0.5cm)
      #text(size: 14pt, weight: "bold")[
        #upper(title)
      ]

      #v(1.2cm)
      #text(size: 14pt, weight: "bold")[
        LAPORAN TUGAS AKHIR
      ]

      #v(1cm)
      #text(size: 12pt)[
        Oleh\
        #v(0.3cm)
        #text(size: 12pt, weight: "bold")[#upper(author)]\
        NIM : #nim\
        #v(0.3cm)
        Program Studi Sarjana Teknik Informatika\
        Sekolah Teknik Elektro dan Informatika\
        Institut Teknologi Bandung
      ]

      #v(1.2cm)
      #text(size: 12pt)[
        Telah disetujui dan disahkan sebagai Laporan Tugas Akhir\
        di Bandung, pada tanggal #date
      ]

      #v(1.5cm)
      #if advisor2 != none [
        #grid(
          columns: (1fr, 1fr),
          align(center)[
            Pembimbing I,
            #v(2.5cm)
            #underline(advisor1)\
            NIP. #nip1
          ],
          align(center)[
            Pembimbing II,
            #v(2.5cm)
            #underline(advisor2)\
            NIP. #nip2
          ]
        )
      ] else [
        #align(center)[
          Pembimbing,
          #v(2.5cm)
          #underline(advisor1)\
          NIP. #nip1
        ]
      ]
    ]
  ]

  // ==========================================
  // LEMBAR PERNYATAAN KEASLIAN (Tanpa Nomor Halaman)
  // ==========================================
  pagebreak()
  [
    #set page(numbering: none)
    #set par(first-line-indent: 0pt, leading: 1.25em)
    #v(0.5cm)
    #align(center)[
      #text(size: 14pt, weight: "bold")[LEMBAR PERNYATAAN]
    ]
    #v(1.5cm)
    Dengan ini saya menyatakan bahwa:
    #v(0.5cm)
    + Pengerjaan dan penulisan Laporan Tugas Akhir ini dilakukan tanpa menggunakan bantuan yang tidak dibenarkan.
    + Segala bentuk kutipan dan acuan terhadap tulisan orang lain yang digunakan di dalam penyusunan laporan tugas akhir ini telah dituliskan dengan baik dan benar.
    + Laporan Tugas Akhir ini belum pernah diajukan pada program pendidikan di perguruan tinggi mana pun.

    #v(0.8cm)
    Jika terbukti melanggar hal-hal di atas, saya bersedia dikenakan sanksi sesuai dengan Pelanggaran Peraturan Akademik dan Kemahasiswaan Institut Teknologi Bandung.
    
    #v(2cm)
    #align(right)[
      #block(width: 6cm)[
        Bandung, #date\
        #v(2.5cm)
        #underline(author)\
        NIM : #nim
      ]
    ]
  ]

  // ==========================================
  // BAGIAN DEPAN / FRONTMATTER (Nomor Romawi Kecil: iii, iv, ...)
  // ==========================================
  set page(
    numbering: "i",
    number-align: center + bottom,
  )
  counter(page).update(3) // Halaman iii untuk Abstrak

  // --- ABSTRAK INDONESIA ---
  if abstract-id != none [
    #pagebreak()
    #align(center)[
      #set par(justify: false)
      #text(size: 14pt, weight: "bold")[ABSTRAK]
      #v(0.5em)
      #text(size: 12pt, weight: "bold")[#upper(title)]
      #v(0.5em)
      #text(size: 12pt)[
        Oleh\
        #upper(author)\
        NIM : #nim
      ]
    ]
    #v(1.5em)
    #set par(leading: 0.9em, justify: true, first-line-indent: 1.25cm)
    #abstract-id
    #v(1em)
    #set par(first-line-indent: 0pt)
    *Kata Kunci:* #keywords-id.join(", ")
  ]

  // --- ABSTRACT ENGLISH ---
  if abstract-en != none [
    #pagebreak()
    #align(center)[
      #set par(justify: false)
      #text(size: 14pt, weight: "bold")[ABSTRACT]
      #v(0.5em)
      #text(size: 12pt, weight: "bold")[#upper(title-en)]
      #v(0.5em)
      #text(size: 12pt)[
        By\
        #upper(author)\
        NIM : #nim
      ]
    ]
    #v(1.5em)
    #set par(leading: 0.9em, justify: true, first-line-indent: 1.25cm)
    #abstract-en
    #v(1em)
    #set par(first-line-indent: 0pt)
    *Keywords:* #keywords-en.join(", ")
  ]

  // --- KATA PENGANTAR ---
  if preface != none [
    #pagebreak()
    #align(center)[
      #text(size: 14pt, weight: "bold")[KATA PENGANTAR]
    ]
    #v(1.5em)
    #preface
  ]

  // --- DAFTAR ISI, DAFTAR GAMBAR, DAFTAR TABEL ---
  pagebreak()
  outline(title: [DAFTAR ISI], depth: 3, indent: auto)

  pagebreak()
  outline(title: [DAFTAR GAMBAR], target: figure.where(kind: image))

  pagebreak()
  outline(title: [DAFTAR TABEL], target: figure.where(kind: table))

  // --- DAFTAR SINGKATAN DAN ISTILAH ---
  if glossary != none [
    #pagebreak()
    #align(center)[
      #text(size: 14pt, weight: "bold")[DAFTAR SINGKATAN DAN ISTILAH]
    ]
    #v(1.5em)
    #glossary
  ]

  // ==========================================
  // BAGIAN UTAMA (BAB I - BAB V): Angka Arab 1, 2, ...
  // ==========================================
  pagebreak()
  set page(
    numbering: "1",
    number-align: center + bottom,
  )
  counter(page).update(1)

  body
}
