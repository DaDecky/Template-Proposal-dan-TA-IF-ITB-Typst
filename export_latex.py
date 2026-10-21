#!/usr/bin/env python3
"""
Exporter: Typst to Full ITB Informatics LaTeX Thesis
Converts Typst thesis source into a complete, publication-ready ITB LaTeX project.
"""

import os
import re
import shutil
import subprocess
import sys

def main():
    root_dir = os.path.dirname(os.path.abspath(__file__))
    export_dir = os.path.join(root_dir, "latex-export")
    os.makedirs(os.path.join(export_dir, "chapters"), exist_ok=True)
    os.makedirs(os.path.join(export_dir, "assets"), exist_ok=True)

    # 1. Copy assets
    assets_src_dir = os.path.join(root_dir, "assets")
    if os.path.exists(assets_src_dir):
        for f in os.listdir(assets_src_dir):
            src_f = os.path.join(assets_src_dir, f)
            if os.path.isfile(src_f):
                shutil.copy2(src_f, os.path.join(export_dir, "assets", f))
                # also keep logo-itb at root of latex-export for backwards compatibility
                if f == "logo-itb.jpg":
                    shutil.copy2(src_f, os.path.join(export_dir, "logo-itb.jpg"))

    bib_src = os.path.join(root_dir, "references.bib")
    if os.path.exists(bib_src):
        shutil.copy2(bib_src, os.path.join(export_dir, "references.bib"))

    # 2. Extract metadata from main.typ
    main_typ_path = os.path.join(root_dir, "main.typ")
    metadata = {
        "title": "<JUDUL TUGAS AKHIR>",
        "title_en": "<ENGLISH THESIS TITLE>",
        "author": "<NAMA MAHASISWA>",
        "nim": "135XXXXX",
        "advisor1": "<Nama Pembimbing I, Gelar>",
        "nip1": "<NIP Pembimbing I>",
        "advisor2": "",
        "nip2": "",
        "date": "<Tanggal Pengesahan>",
        "month_year": "<Bulan Tahun>",
        "abstract_id": "",
        "keywords_id": "Kata Kunci 1, Kata Kunci 2, Kata Kunci 3",
        "abstract_en": "",
        "keywords_en": "Keyword 1, Keyword 2, Keyword 3",
        "preface": "",
    }

    if os.path.exists(main_typ_path):
        with open(main_typ_path, "r", encoding="utf-8") as f:
            content = f.read()

        def extract_str(field):
            m = re.search(r'\b' + field + r':\s*"([^"]*)"', content)
            return m.group(1) if m else None

        def extract_bracket(field):
            m = re.search(r'\b' + field + r':\s*\[(.*?)\]\s*,?\s*\n', content, re.DOTALL)
            return m.group(1).strip() if m else None

        def extract_array(field):
            m = re.search(r'\b' + field + r':\s*\((.*?)\)', content, re.DOTALL)
            if m:
                items = [x.strip().strip('"').strip("'") for x in m.group(1).split(",") if x.strip()]
                return ", ".join(items)
            return None

        val = extract_str("title")
        if val: metadata["title"] = val
        val = extract_str("title-en")
        if val: metadata["title_en"] = val
        val = extract_str("author")
        if val: metadata["author"] = val
        val = extract_str("nim")
        if val: metadata["nim"] = val
        val = extract_str("advisor1")
        if val: metadata["advisor1"] = val
        val = extract_str("nip1")
        if val: metadata["nip1"] = val
        val = extract_str("advisor2")
        if val: metadata["advisor2"] = val
        val = extract_str("nip2")
        if val: metadata["nip2"] = val
        val = extract_str("date")
        if val: metadata["date"] = val
        val = extract_str("month-year")
        if val: metadata["month_year"] = val

        val = extract_bracket("abstract-id")
        if val: metadata["abstract_id"] = val
        val = extract_array("keywords-id")
        if val: metadata["keywords_id"] = val

        val = extract_bracket("abstract-en")
        if val: metadata["abstract_en"] = val
        val = extract_array("keywords-en")
        if val: metadata["keywords_en"] = val

        val = extract_bracket("preface")
        if val: metadata["preface"] = val

    # Convert Typst abstract/preface snippets to LaTeX
    def typst_to_latex_snippet(text):
        if not text:
            return ""
        # Quick clean of markdown/typst formatting for preamble snippets
        clean = text.replace("\\<", "<").replace("\\>", ">")
        p = subprocess.run(
            ["pandoc", "--from", "typst", "--to", "latex"],
            input=clean,
            text=True,
            capture_output=True,
            check=False,
        )
        return p.stdout.strip() if p.returncode == 0 else clean

    tex_abstract_id = typst_to_latex_snippet(metadata["abstract_id"])
    tex_abstract_en = typst_to_latex_snippet(metadata["abstract_en"])
    tex_preface = typst_to_latex_snippet(metadata["preface"])

    # 3. Convert all chapter files using Pandoc
    chapters_dir = os.path.join(root_dir, "chapters")
    chapter_files = sorted(os.listdir(chapters_dir)) if os.path.exists(chapters_dir) else []
    exported_main_chapters = []
    exported_appendix_chapters = []

    for cf in chapter_files:
        if not cf.endswith(".typ"):
            continue
        cpath = os.path.join(chapters_dir, cf)
        out_name = cf[:-4] + ".tex"
        out_path = os.path.join(export_dir, "chapters", out_name)
        print(f"  - Mengonversi chapters/{cf} -> chapters/{out_name}")
        subprocess.run(
            ["pandoc", "--from", "typst", "--to", "latex", "--top-level-division=chapter", cpath, "-o", out_path],
            check=True
        )
        # Clean pandoc artifacts in the generated .tex
        with open(out_path, "r", encoding="utf-8") as f:
            tex_content = f.read()

        # Fix table definitions or unescaped brackets
        tex_content = tex_content.replace("\\def\\LTcaptype{none}", "% LTcaptype")
        tex_content = tex_content.replace("\\ul{", "\\underline{")
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(tex_content)

        if cf.startswith("99") or "lampiran" in cf:
            exported_appendix_chapters.append(f"chapters/{out_name}")
        else:
            exported_main_chapters.append(f"chapters/{out_name}")

    # 4. Generate master main.tex
    advisor2_block = ""
    if metadata["advisor2"] and metadata["advisor2"] != "none":
        advisor2_block = f"""
    \\begin{{minipage}}{{0.45\\textwidth}}
      \\centering
      Pembimbing I,\\\\ [2.5cm]
      \\underline{{{metadata['advisor1']}}}\\\\
      NIP. {metadata['nip1']}
    \\end{{minipage}}
    \\hfill
    \\begin{{minipage}}{{0.45\\textwidth}}
      \\centering
      Pembimbing II,\\\\ [2.5cm]
      \\underline{{{metadata['advisor2']}}}\\\\
      NIP. {metadata['nip2']}
    \\end{{minipage}}
"""
    else:
        advisor2_block = f"""
    Pembimbing,\\\\ [2.5cm]
    \\underline{{{metadata['advisor1']}}}\\\\
    NIP. {metadata['nip1']}
"""

    main_inputs = "\n".join([f"\\input{{{c}}}" for c in exported_main_chapters])
    appendix_inputs = "\n".join([f"\\input{{{c}}}" for c in exported_appendix_chapters])

    main_tex_content = f"""\\documentclass[indonesian, 12pt, a4paper, onecolumn, oneside, final]{{report}}

% ==============================================================================
% Konfigurasi Format Naskah Tugas Akhir Sarjana Teknik Informatika ITB
% ==============================================================================

\\usepackage[top=3cm, bottom=3cm, left=4cm, right=3cm]{{geometry}}
\\usepackage{{mathptmx}}
\\usepackage{{setspace}}
\\renewcommand{{\\baselinestretch}}{{1.5}}

\\usepackage[utf8]{{inputenc}}
\\usepackage[T1]{{fontenc}}
\\usepackage[indonesian]{{babel}}
\\usepackage{{amsmath, amssymb}}
\\usepackage{{graphicx}}
\\usepackage{{longtable, booktabs}}
\\usepackage{{calc}}
\\usepackage{{array}}
\\usepackage{{titlesec}}
\\usepackage{{titletoc}}
\\usepackage{{tocbibind}}
\\usepackage{{caption}}
\\usepackage{{hyperref}}
\\usepackage[style=apa, backend=biber]{{biblatex}}
\\addbibresource{{references.bib}}

\\providecommand{{\\ul}}[1]{{\\underline{{#1}}}}
\\newcounter{{none}}

% Format Bab & Bagian Standar Teknik Informatika ITB
\\renewcommand{{\\thechapter}}{{\\Roman{{chapter}}}}
\\titleformat{{\\chapter}}[display]
  {{\\large\\centering\\bfseries}}
  {{\\MakeUppercase{{\\chaptertitlename}}\\ \\thechapter}}
  {{0pt}}
  {{\\large\\bfseries\\MakeUppercase}}
\\titlespacing*{{\\chapter}}{{0pt}}{{-20pt}}{{18pt}}

\\titleformat{{\\section}}
  {{\\normalfont\\normalsize\\bfseries}}
  {{\\thesection.}}
  {{1em}}
  {{}}
\\titlespacing*{{\\section}}{{0pt}}{{14pt}}{{4pt}}

\\titleformat{{\\subsection}}
  {{\\normalfont\\normalsize\\bfseries}}
  {{\\thesubsection.}}
  {{1em}}
  {{}}

\\begin{{document}}

% ==============================================================================
% 1. HALAMAN SAMPUL / COVER
% ==============================================================================
\\pagenumbering{{roman}}
\\thispagestyle{{empty}}
\\begin{{center}}
  {{\\large\\bfseries {metadata['title']}}} \\vfill
  {{\\large\\bfseries LAPORAN TUGAS AKHIR}} \\vfill
  {{\\normalsize Disusun sebagai syarat kelulusan tingkat sarjana}} \\vfill
  {{\\normalsize Oleh}} \\\\[0.4em]
  {{\\large\\bfseries {metadata['author']}}} \\\\[0.2em]
  {{\\normalsize NIM : {metadata['nim']}}} \\vfill
  \\includegraphics[height=3.5cm]{{logo-itb.jpg}} \\vfill
  {{\\large\\bfseries
  PROGRAM STUDI SARJANA TEKNIK INFORMATIKA\\\\
  SEKOLAH TEKNIK ELEKTRO DAN INFORMATIKA\\\\
  INSTITUT TEKNOLOGI BANDUNG\\\\
  {metadata['month_year']}}}
\\end{{center}}
\\clearpage

% ==============================================================================
% 2. LEMBAR PENGESAHAN
% ==============================================================================
\\thispagestyle{{empty}}
\\begin{{center}}
  {{\\large\\bfseries {metadata['title']}}} \\vfill
  {{\\large\\bfseries LAPORAN TUGAS AKHIR}} \\vfill
  {{\\normalsize Oleh}} \\\\[0.4em]
  {{\\large\\bfseries {metadata['author']}}} \\\\[0.2em]
  {{\\normalsize NIM : {metadata['nim']}}} \\\\[0.4em]
  Program Studi Sarjana Teknik Informatika\\\\
  Sekolah Teknik Elektro dan Informatika\\\\
  Institut Teknologi Bandung \\vfill
  Telah disetujui dan disahkan sebagai Laporan Tugas Akhir\\\\
  di Bandung, pada tanggal {metadata['date']} \\vspace{{1cm}}
  
  {advisor2_block}
\\end{{center}}
\\clearpage

% ==============================================================================
% 3. LEMBAR PERNYATAAN
% ==============================================================================
\\chapter*{{Lembar Pernyataan}}
\\addcontentsline{{toc}}{{chapter}}{{LEMBAR PERNYATAAN}}
Dengan ini saya menyatakan bahwa:
\\begin{{enumerate}}
  \\item Pengerjaan dan penulisan Laporan Tugas Akhir ini dilakukan tanpa menggunakan bantuan yang tidak dibenarkan.
  \\item Segala bentuk kutipan dan acuan terhadap tulisan orang lain yang digunakan di dalam penyusunan laporan tugas akhir ini telah dituliskan dengan baik dan benar.
  \\item Laporan Tugas Akhir ini belum pernah diajukan pada program pendidikan di perguruan tinggi mana pun.
\\end{{enumerate}}
Jika terbukti melanggar hal-hal di atas, saya bersedia dikenakan sanksi sesuai dengan Pelanggaran Peraturan Akademik dan Kemahasiswaan Institut Teknologi Bandung.

\\vspace{{1.5cm}}
\\begin{{flushright}}
  Bandung, {metadata['date']}\\\\[2.5cm]
  \\underline{{{metadata['author']}}}\\\\
  NIM : {metadata['nim']}
\\end{{flushright}}
\\clearpage

% ==============================================================================
% 4. ABSTRAK INDONESIA
% ==============================================================================
\\setcounter{{page}}{{3}}
\\chapter*{{Abstrak}}
\\addcontentsline{{toc}}{{chapter}}{{ABSTRAK}}
\\begin{{center}}
  {{\\large\\bfseries {metadata['title']}}} \\\\[0.5em]
  {{\\normalsize Oleh: {metadata['author']} (NIM : {metadata['nim']})}}
\\end{{center}}
\\vspace{{1em}}
{tex_abstract_id}
\\vspace{{1em}}

\\noindent\\textbf{{Kata Kunci:}} {metadata['keywords_id']}
\\clearpage

% ==============================================================================
% 5. ABSTRACT ENGLISH
% ==============================================================================
\\chapter*{{Abstract}}
\\addcontentsline{{toc}}{{chapter}}{{ABSTRACT}}
\\begin{{center}}
  {{\\large\\bfseries {metadata['title_en']}}} \\\\[0.5em]
  {{\\normalsize By: {metadata['author']} (NIM : {metadata['nim']})}}
\\end{{center}}
\\vspace{{1em}}
{tex_abstract_en}
\\vspace{{1em}}

\\noindent\\textbf{{Keywords:}} {metadata['keywords_en']}
\\clearpage

% ==============================================================================
% 6. KATA PENGANTAR
% ==============================================================================
\\chapter*{{Kata Pengantar}}
\\addcontentsline{{toc}}{{chapter}}{{KATA PENGANTAR}}
{tex_preface}
\\clearpage

% ==============================================================================
% 7. DAFTAR ISI, DAFTAR GAMBAR, DAFTAR TABEL
% ==============================================================================
\\tableofcontents
\\clearpage
\\listoffigures
\\clearpage
\\listoftables
\\clearpage

% ==============================================================================
% 8. BAGIAN UTAMA (BAB I - BAB V)
% ==============================================================================
\\pagenumbering{{arabic}}
\\setcounter{{page}}{{1}}

{main_inputs}

% ==============================================================================
% 9. DAFTAR PUSTAKA
% ==============================================================================
\\printbibliography

% ==============================================================================
% 10. LAMPIRAN
% ==============================================================================
\\appendix
\\titleformat{{\\chapter}}[display]
  {{\\large\\centering\\bfseries}}
  {{LAMPIRAN \\thechapter}}
  {{0pt}}
  {{\\large\\bfseries\\MakeUppercase}}

{appendix_inputs}

\\end{{document}}
"""

    with open(os.path.join(export_dir, "main.tex"), "w", encoding="utf-8") as f:
        f.write(main_tex_content)

    print(f"==> Selesai! Dokumen LaTeX lengkap ITB tersimpan di: {export_dir}")

if __name__ == "__main__":
    main()
