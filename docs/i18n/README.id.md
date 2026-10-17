<p align="center">
  <img src="../assets/icon.png" width="128" alt="Ikon aplikasi OpenWithPanel">
</p>

<h1 align="center">OpenWithPanel</h1>

<p align="center">
  <strong>Atur aplikasi mana yang membuka file apa di Mac Anda — termasuk file yang tidak bisa diatur lewat macOS.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26 atau lebih baru">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="Lisensi MIT">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <b>Bahasa Indonesia</b> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

OpenWithPanel adalah aplikasi macOS gratis dan sumber terbuka untuk mengelola **aplikasi default**: pilih aplikasi yang membuka setiap jenis file, ekstensi file, dan tautan, semuanya dalam satu jendela. OpenWithPanel juga bisa melakukan hal yang tidak bisa dilakukan Finder: menjadikan editor Anda sebagai aplikasi default untuk **file tanpa ekstensi**, seperti `.env`, `.gitignore`, `Dockerfile`, dan `.npmrc`.

<p align="center">
  <img src="../assets/screenshot.png" width="720" alt="Jendela utama OpenWithPanel">
</p>

## Daftar Isi

- [Mengapa OpenWithPanel](#mengapa-openwithpanel)
- [Fitur](#fitur)
- [Instalasi](#instalasi)
- [Penggunaan](#penggunaan)
- [Diagnosis](#diagnosis)
- [Pengaturan](#pengaturan)
- [Mode pengembang](#mode-pengembang)
- [Cara kerja](#cara-kerja)
- [FAQ](#faq)
- [Keterbatasan yang diketahui](#keterbatasan-yang-diketahui)
- [Membangun dari kode sumber](#membangun-dari-kode-sumber)

## Mengapa OpenWithPanel

macOS menggolongkan sebagian besar file tanpa ekstensi sebagai `public.data`, dan menolak menjadikan aplikasi apa pun sebagai default untuk jenis tersebut. **Dapatkan Info › Buka Dengan › Ubah Semua…** di Finder tidak berpengaruh pada file-file ini, dan alat baris perintah gagal dengan galat `-50`. **Selalu Buka Dengan** di Finder hanya berlaku untuk satu file yang Anda pilih.

Akibatnya, `.env`, `.gitignore`, `Dockerfile`, dan file serupa tetap terbuka di TextEdit — atau tidak terbuka sama sekali — apa pun yang Anda atur. OpenWithPanel mengatasi hal ini dengan aplikasi pembantu kecil bernama OpenWithPanel Helper, yang dijelaskan di [Cara kerja](#cara-kerja).

OpenWithPanel juga menutupi hal lain yang diabaikan macOS: ketika aplikasi yang baru dipasang (biasanya Xcode) mengambil alih asosiasi file Anda, macOS tidak memberi tahu, dan tidak ada tombol untuk mengembalikan semuanya seperti semula.

## Fitur

- **Aplikasi default per grup.** Jenis file dikelompokkan menurut kegunaannya — Teks, Markdown, Kode, Konfigurasi & Data, File Tanpa Ekstensi, PDF, Dokumen, Gambar, Video, Audio, Arsip — dan setiap grup memiliki satu menu aplikasi.
- **Terapkan sekaligus.** Atur seluruh format dalam satu grup sekaligus tanpa mengonfirmasi satu per satu; perubahan berlaku dalam beberapa detik.
- **Pengecualian per format.** Bentangkan grup untuk memberi satu format, seperti `.md` atau `.py`, aplikasinya sendiri. Mengubah aplikasi grup nanti tidak mengubah pengecualian tersebut.
- **File tanpa ekstensi.** Buka `.env`, `Dockerfile`, `.gitignore`, dan file tanpa ekstensi lainnya di editor pilihan Anda, meskipun editor itu tidak menyatakan mendukungnya.
- **Ekstensi kustom.** Tambahkan ekstensi apa pun yang tidak ada di daftar, termasuk yang hanya dikenal macOS sebagai jenis sementara, seperti `.go`, `.rs`, `.kt`, `.dart`, dan `.lua`.
- **Aplikasi default untuk tautan.** Pilih aplikasi untuk tautan web (`http`, `https`), email (`mailto`), langganan kalender (`webcal`), panggilan telepon, pesan teks, FaceTime, SSH, FTP, dan berbagi layar — atau pilih **Jangan buka** agar mengeklik tautan seperti itu tidak melakukan apa-apa.
- **Cari menurut ekstensi.** Ketik `py` atau `env` untuk langsung melompat ke baris yang tepat.
- **Diagnosis file apa pun.** Letakkan file untuk melihat mengapa file itu terbuka di aplikasi tertentu, lalu pilih aplikasi lain di tempat itu juga. Letakkan folder untuk menemukan file yang memiliki pengaturan **Buka Dengan** sendiri dan menghapusnya.
- **Peringatan pengambilalihan.** Jika aplikasi lain (Xcode, peramban) mengambil alih asosiasi yang Anda atur, OpenWithPanel menampilkan banner dengan perbaikan sekali klik.
- **Urungkan dan pulihkan.** Snapshot disimpan sebelum setiap perubahan. Urungkan dengan `⌘Z`, pulihkan snapshot sebelumnya mana pun, atau pulihkan semuanya ke keadaan sebelum OpenWithPanel mengubah apa pun, dengan pratinjau setiap perubahan terlebih dahulu.
- **Aturan folder.** Cadangan opsional yang membuat file tanpa ekstensi di dalam folder pilihan, seperti `~/Projects`, terbuka di editor Anda, hanya dengan API resmi macOS.
- **Mode pengembang.** Aturan yang mengarahkan file menurut pola nama (misalnya `Dockerfile*`), folder, atau isi teks versus biner; rantai keputusan lengkap di diagnosis, termasuk jenis yang dinyatakan setiap aplikasi dan rank-nya; impor dan ekspor preset.
- **Pencopotan bersih.** Pencopot bawaan mengembalikan setiap asosiasi ke aplikasi aslinya sebelum memindahkan OpenWithPanel ke Tong Sampah.
- **15 bahasa.** Inggris, Tionghoa Sederhana, Tionghoa Tradisional, Jepang, Korea, Jerman, Prancis, Spanyol, Portugis, Indonesia, Thai, Vietnam, Arab, Rusia, dan Hindi, yang dapat dialihkan di dalam aplikasi.

## Instalasi

Memerlukan macOS 26 Tahoe atau lebih baru.

1. Buka [halaman Releases](https://github.com/zhaojiannet/openwithpanel/releases) dan, di bagian **Assets** pada rilis terbaru, unduh `OpenWithPanel-<version>.dmg`.
2. Klik dua kali DMG yang diunduh untuk membukanya.
3. Seret **OpenWithPanel** ke folder **Aplikasi** yang ditampilkan di jendela yang sama.
4. Keluarkan DMG, lalu buka OpenWithPanel dari folder Aplikasi. Pada kali pertama, macOS meminta Anda mengizinkannya; lihat [Peluncuran pertama](#peluncuran-pertama).

Tidak ada penginstal dan tidak perlu kata sandi administrator.

**Memperbarui:** unduh DMG baru dan seret OpenWithPanel ke Aplikasi lagi, menggantikan salinan lama. Pengaturan, aturan, dan snapshot Anda tetap tersimpan.

**Mencopot:** lihat [Pencopotan](#pencopotan).

### Peluncuran pertama

OpenWithPanel belum dinotarisasi oleh Apple, sehingga macOS memblokirnya saat pertama kali Anda membukanya. Izinkan sekali:

1. Klik dua kali OpenWithPanel. Saat macOS mengatakan tidak dapat memverifikasi OpenWithPanel, klik **Selesai**. Jangan klik tombol biru **Pindahkan ke Tong Sampah**.

   <img src="../assets/first-launch-1.png" width="372" alt="Peringatan pertama: klik Selesai">

2. Buka **Pengaturan Sistem › Privasi & Keamanan**, gulir ke bawah ke **Keamanan**, lalu klik **Tetap Buka** di samping OpenWithPanel. Tombol ini tersedia sekitar satu jam setelah langkah 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Privasi & Keamanan: klik Tetap Buka">

3. Masukkan kata sandi login Anda atau gunakan Touch ID. Di dialog berikutnya, klik **Tetap Buka** lagi.

   <img src="../assets/first-launch-3.png" width="372" alt="Konfirmasi: klik Tetap Buka">

Setelah ini, OpenWithPanel terbuka seperti biasa. Aplikasi pembantu bawaannya ikut diizinkan, sehingga file tanpa ekstensi terbuka tanpa permintaan lebih lanjut. DMG juga memuat langkah-langkah ini di `First Launch.txt`. Tangkapan layar menampilkan antarmuka berbahasa Inggris; di macOS berbahasa Indonesia, nama tombolnya adalah yang tertulis di atas.

## Penggunaan

### Grup jenis file

Tab **Jenis File** menampilkan setiap grup sebagai kartu:

| Grup | Mencakup |
|---|---|
| Teks | `.txt` `.log` |
| Markdown | `.md` `.markdown` |
| Kode | Bahasa pemrograman populer, lihat di bawah |
| Konfigurasi & Data | `.json` `.yaml` `.toml` `.xml` `.ini` `.plist` `.csv` |
| File Tanpa Ekstensi | `.env` `Dockerfile` `.gitignore` dan sejenisnya |
| PDF | `.pdf` |
| Dokumen | `.rtf` `.docx` `.doc` `.pages` `.odt` |
| Gambar, Video, Audio, Arsip | Format umumnya masing-masing |
| Kustom | Ekstensi yang Anda tambahkan dan tidak cocok dengan grup lain; hanya ditampilkan jika ada isinya |

Grup Kode mencakup bahasa yang digunakan oleh setidaknya 5% responden Stack Overflow 2025 Developer Survey: JavaScript, TypeScript (`.tsx`), Python, Java, C, C++, C#, PHP, Ruby, Swift, Go, Rust, Kotlin, Dart, Lua, Shell (sh, bash, zsh), PowerShell, SQL, dan assembly, ditambah CSS, Makefile, dan JSX. Tambahkan bahasa lain sendiri, lihat [Tambah ekstensi](#tambah-ekstensi).

### Atur aplikasi untuk seluruh grup

Pilih aplikasi dari menu di sebelah kanan kartu. Setelah itu, setiap format dalam grup terbuka di aplikasi tersebut. Menu menampilkan aplikasi yang dianggap macOS mampu membuka grup itu; pilih **Lainnya…** untuk memilih aplikasi apa pun dari folder Aplikasi.

### Beri satu format aplikasinya sendiri

Klik baris grup, atau panah di sebelah kirinya, untuk membentangkannya. Setiap format memiliki barisnya sendiri, dengan ikon sistem untuk file tersebut dan ekstensinya sebagai judul. Pilih aplikasi lain di menu sebuah baris dan format itu akan menggunakannya sejak saat itu; baris tersebut ditandai **Diatur terpisah**, dan baris grup menunjukkan berapa banyak format yang diatur terpisah.

- Format tanpa aplikasi sendiri menampilkan **Sama dengan Grup** berwarna abu-abu di menunya.
- Agar format kembali mengikuti grup, pilih **Ikuti Grup** di menunya.
- Mengubah aplikasi grup nanti tidak mengubah format yang memiliki aplikasi sendiri.

Grup dengan lebih dari 8 format hanya menampilkan format yang Anda atur terpisah atau tambahkan sendiri; **Tampilkan Semua N Format** di bagian bawah menampilkan sisanya. Saat grup Kode menampilkan semuanya, grup itu dibagi menjadi bagian seperti Web, Sistem & Aplikasi, JVM, dan Skrip & Shell.

### Pencarian

Ketik ekstensi, seperti `py` atau `env`, di kolom pencarian di kanan atas. Grup yang cocok terbentang dengan semua formatnya dan baris yang cocok disorot. Jika ekstensi tidak ada di grup mana pun, hasil pencarian menawarkan **Tambah…**.

### Tambah ekstensi

Gunakan **Tambah Ekstensi…** di bagian bawah daftar, atau **Tambah…** di hasil pencarian.

1. Ketik ekstensinya, seperti `nim`. Lembar menampilkan bagaimana macOS mengenalinya.
2. Berdasarkan itu, OpenWithPanel menyarankan grup: kode sumber ke Kode, gambar ke Gambar, dan apa pun yang tidak dikenali ke Kustom. Anda dapat memilih grup lain.
3. Klik **Tambah**. Format muncul di grup itu, ditandai **Kustom**, dan mengikuti aplikasi grup; Anda juga dapat memberinya aplikasi sendiri.

Ekstensi yang sudah ada di suatu grup tidak ditambahkan dua kali; lembar memberi tahu Anda di grup mana ekstensi itu berada. Format yang Anda tambahkan memiliki tombol hapus di barisnya.

### Terapkan

Semua perubahan di atas ditampung terlebih dahulu. Bilah di bagian bawah jendela menunjukkan berapa banyak perubahan yang tertunda; **Terapkan** memberlakukannya dan **Buang** membatalkannya.

- Perubahan jenis file tidak meminta konfirmasi. Berapa pun format yang Anda ubah, OpenWithPanel menuliskannya ke preferensi sistem sekaligus dan meminta sistem memuat ulang satu kali saja; semuanya berlaku dalam beberapa detik.
- Perubahan tautan dan file web (`.html`) tetap meminta konfirmasi di dialog sistem, misalnya saat Anda mengganti peramban web. Mengganti peramban diam-diam adalah ulah pembajak peramban, jadi macOS sepatutnya bertanya langsung kepada Anda.
- Jika penulisan gagal (misalnya karena izin), atau suatu format tidak berlaku, OpenWithPanel mengaturnya lagi melalui API sistem, satu per satu; macOS lalu menanyakan apakah akan menggunakan aplikasi baru atau tetap memakai yang lama. Jika Anda tetap memakai yang lama, OpenWithPanel mencatat format itu sebagai diatur terpisah ke aplikasi tersebut dan tidak mengubahnya lagi.
- Setelah menerapkan, OpenWithPanel membaca kembali keadaan sistem yang sebenarnya, sehingga daftar selalu menampilkan apa yang benar-benar berlaku.

### Urungkan dan pulihkan

- **Edit › Urung** (`⌘Z`) mengurungkan penerapan terakhir. Anda dapat mengurungkan beberapa kali berturut-turut.
- Tombol panah melingkar di bilah alat adalah **Pulihkan ke Awal**: setiap jenis file dan tautan yang diubah OpenWithPanel diarahkan kembali ke aplikasi yang digunakannya saat Anda pertama kali membuka OpenWithPanel. Setiap perubahan ditampilkan sebelum apa pun dilakukan.

macOS tidak menyediakan cara untuk menghapus asosiasi file, hanya untuk mengarahkannya ke aplikasi lain, jadi memulihkan berarti mengarahkan kembali setiap jenis ke aplikasi yang tercatat di snapshot. Jenis yang dulu aplikasinya dipilih sendiri oleh macOS akan mendapat pengaturan eksplisit untuk aplikasi yang sama; jenis itu terbuka persis seperti sebelumnya.

### Tautan

Di bawah jenis file, sebuah kartu mengatur aplikasi untuk setiap jenis tautan:

| Baris | Skema URL |
|---|---|
| Peramban web | `http:` `https:` |
| Email | `mailto:` |
| Langganan kalender | `webcal:` |
| Panggilan telepon, Pesan teks, FaceTime | `tel:` `sms:` `facetime:` |
| SSH, FTP, Berbagi layar | `ssh:` `ftp:` `vnc:` |

Setiap jenis tautan yang dapat ditangani oleh suatu aplikasi di Mac Anda ditampilkan. Di bagian bawah setiap menu ada **Jangan buka**: pilih itu dan mengeklik jenis tautan tersebut di aplikasi mana pun tidak akan melakukan apa-apa — misalnya agar nomor telepon di halaman web tidak memulai panggilan. Untuk membatalkannya, pilih aplikasi di menu lagi. Memilih **Jangan buka** untuk peramban web akan meminta konfirmasi terlebih dahulu, karena tidak ada tautan web yang akan terbuka sama sekali. Anda juga dapat mencari skema (seperti `mailto`) atau nama baris.

Tautan ditampung, diterapkan, disimpan dalam snapshot, diurungkan, dan dipulihkan persis seperti jenis file. Mengganti peramban web meminta konfirmasi di dialog sistem; di macOS 27, mengubah `http` juga mengubah `https`, dan OpenWithPanel lalu tidak mengatur `https` lagi, sehingga Anda hanya mengonfirmasi sekali.

## Diagnosis

Beralihlah ke tab **Diagnosis** di bagian atas jendela.

**Mengapa sebuah file terbuka di aplikasi ini?** Letakkan file ke dalam kotak bergaris putus-putus. Hasilnya menunjukkan aplikasi mana yang membukanya dan alasannya:

- file memiliki pengaturan **Buka Dengan** sendiri, yang dibuat di **Dapatkan Info** pada Finder;
- OpenWithPanel Helper menerimanya dan sebuah aturan atau pengaturan grup mengirimkannya ke suatu aplikasi;
- Anda memilih aplikasi ini untuk jenis file ini;
- tidak ada yang diatur, sehingga macOS memilih aplikasinya.

Di bawah hasil, **Gunakan sebagai gantinya** langsung beralih ke aplikasi lain. Jika file memiliki pengaturan **Buka Dengan** sendiri, yang muncul adalah **Hapus Pengaturan Milik File Ini**.

**Temukan file dengan pengaturan "Buka Dengan" sendiri.** Letakkan folder ke dalam kotak bergaris putus-putus. OpenWithPanel menampilkan setiap file di dalamnya yang memiliki pengaturan **Buka Dengan** sendiri, beserta aplikasi yang ditujunya. Pilih file lalu klik **Hapus Pengaturan Mereka Sendiri**; file-file itu kemudian mengikuti pengaturan untuk jenisnya. Pemindaian melewati folder `.git`, `node_modules`, `.build`, `DerivedData`, `Pods`, `vendor`, `.venv`, dan `__pycache__`.

**Ekspor laporan diagnosis.** **Ekspor Laporan Diagnosis…** di bagian bawah tab menyimpan laporan teks berisi konfigurasi Anda, aplikasi yang saat ini membuka setiap jenis yang dikelola OpenWithPanel, log sesi ini, dan file yang baru saja Anda diagnosis. Kirimkan kepada pengembang saat melaporkan masalah.

## Pengaturan

Buka **OpenWithPanel › Pengaturan…** atau tekan `⌘,`.

**Umum**

- **Bahasa:** pilih **Ikuti Sistem** atau salah satu dari 15 bahasa, lalu klik **Buka Ulang Sekarang**. Jika ada perubahan yang belum diterapkan, terapkan atau buang dulu.
- **Mode pengembang:** menampilkan detail lebih banyak, lihat [Mode pengembang](#mode-pengembang). Mode ini hanya mengubah apa yang ditampilkan, tidak pernah mengubah pengaturan Anda.

**Aturan Folder**

Cadangan untuk saat metode yang digunakan untuk file tanpa ekstensi berhenti berfungsi. Tambahkan folder dan pilih aplikasi, maka OpenWithPanel memberi setiap file teks tanpa ekstensi di folder itu pengaturan **Buka Dengan** sendiri untuk aplikasi tersebut.

- File biner, dan file yang Anda atur sendiri, tidak diubah.
- File baru ditangani setiap kali Anda membuka OpenWithPanel, atau segera dengan **Terapkan Sekarang**.
- **Batalkan Semua Pengaturan Folder** mengembalikan setiap file yang diubah OpenWithPanel seperti semula.
- **Lewati folder bernama** dapat diedit; secara default berisi folder yang dilewati pemindaian folder di Diagnosis.

**Riwayat**

Menampilkan snapshot yang disimpan sebelum setiap penerapan, hingga 20, dari yang terbaru. Yang terakhir, **Awal (sebelum OpenWithPanel mengubah apa pun)**, adalah keadaan yang tercatat saat pertama kali Anda membuka OpenWithPanel. Snapshot mana pun dapat dipulihkan dengan **Pulihkan…**, dengan pratinjau perbedaannya terlebih dahulu.

**Yang Ditulis OpenWithPanel**

Menampilkan setiap tempat yang diubah atau ditulisi OpenWithPanel di Mac Anda, masing-masing dengan **Tampilkan di Finder**:

- **Asosiasi file:** berapa banyak item (jenis file dan tautan) yang dikelola OpenWithPanel;
- **Entri preferensi LaunchServices:** entri yang ditulis OpenWithPanel untuk jenis file, termasuk file tanpa ekstensi;
- **OpenWithPanel Helper:** di dalam aplikasi OpenWithPanel;
- **Aturan dan snapshot:** `~/Library/Application Support/net.zhaojian.openwithpanel/`;
- **Pengaturan “Buka Dengan” per file:** hanya ada jika Anda menggunakan aturan folder.

OpenWithPanel tidak berjalan di latar belakang, tidak memiliki item login, tidak membuat koneksi jaringan, dan tidak mengumpulkan data.

### Pencopotan

Di bagian bawah **Yang Ditulis OpenWithPanel**, klik **Copot OpenWithPanel…** dan pilih apakah aturan dan snapshot juga akan dihapus. OpenWithPanel kemudian:

1. mengarahkan kembali setiap jenis file dan tautan yang diubahnya ke aplikasi aslinya;
2. membatalkan setiap pengaturan per file yang dibuat oleh aturan folder;
3. menghapus atau mempertahankan `~/Library/Application Support/net.zhaojian.openwithpanel/` sesuai pilihan Anda;
4. memindahkan dirinya sendiri ke Tong Sampah.

Jika ada jenis file atau tautan yang tidak dapat diarahkan kembali — misalnya karena Anda menolak konfirmasi sistem — pencopotan dihentikan dan tidak ada yang dihapus.

Jika Anda mempertahankan aturan dan snapshot, memasang ulang OpenWithPanel akan menampilkan banner yang mengembalikan semua pengaturan Anda dengan sekali klik. Alat pembersih aplikasi yang menghapus sisa file aplikasi saat aplikasi dipindahkan ke Tong Sampah juga bisa menghapus aturan dan snapshot yang Anda pilih untuk dipertahankan; atur alat tersebut agar melewati OpenWithPanel.

Jika Anda sendiri yang menyeret OpenWithPanel ke Tong Sampah, OpenWithPanel Helper ikut terbuang dan macOS menghapus asosiasi yang mengarah kepadanya; jenis lain tetap menggunakan aplikasi yang diatur OpenWithPanel. File `UNINSTALL.txt` di folder Application Support menjelaskan cara memulihkannya dalam kasus itu.

## Mode pengembang

Aktifkan di **Pengaturan › Umum**. Mode ini menambahkan:

- pengenal jenis sistem (UTI) di bawah setiap format, dan lencana **Pembantu** pada format yang diarahkan melalui OpenWithPanel Helper;
- rantai keputusan lengkap di diagnosis: jenis, jenis induk, teks atau biner, keputusannya, dan bagaimana setiap aplikasi yang dapat membuka file itu menyatakannya di Info.plist miliknya (ekstensi atau jenis yang cocok, peran, dan rank);
- tab **Aturan** di jendela utama;
- penanganan **File yang bukan teks** dan **Preset** di Pengaturan.

**Aturan** menentukan ke mana OpenWithPanel Helper mengirim file yang diterimanya. Sebuah aturan memiliki:

- kondisi, setidaknya salah satunya harus diisi: pola nama file (seperti `Dockerfile*`, tidak peka huruf besar-kecil), folder yang memuatnya (seperti `~/Projects`), dan apakah isinya teks atau biner;
- jenis yang dikenai aturan, secara default `public.data` (file tanpa ekstensi); jenis lain yang Anda tambahkan juga diarahkan melalui OpenWithPanel Helper;
- tujuan pengiriman file: sebuah aplikasi, **Tampilkan di Finder**, atau **App asli**.

Aturan diperiksa dari atas ke bawah dan kecocokan pertama yang berlaku. Seret untuk mengubah urutan; sakelar di sebelah kiri menonaktifkan aturan untuk sementara. Grup yang terpengaruh aturan menampilkan **Dikendalikan aturan** dalam mode standar.

**File yang bukan teks** mengatur apa yang dilakukan OpenWithPanel Helper terhadap file biner: **Tampilkan di Finder** (default), **Buka dengan app yang sama**, atau **Buka dengan app asli**.

**Preset** mengekspor pengaturan grup, pengaturan per format, ekstensi kustom, dan aturan Anda ke file JSON yang dapat Anda impor di Mac lain; pengaturan yang diimpor berlaku setelah Anda mengeklik **Terapkan**. Aturan folder dan catatan aplikasi asli bersifat khusus untuk setiap Mac, sehingga tidak diekspor dan tidak ditimpa saat impor.

## Cara kerja

OpenWithPanel menyertakan aplikasi pembantu yang sangat kecil, **OpenWithPanel Helper**, di dalam bundel aplikasinya. Saat Anda memilih editor untuk file tanpa ekstensi, OpenWithPanel mengarahkan `public.data` ke aplikasi pembantu. Saat Anda membuka file seperti itu, aplikasi pembantu memeriksa aturan Anda dan isi file, menyerahkan file teks ke aplikasi pilihan Anda, menampilkan file biner di Finder, lalu keluar. Aplikasi pembantu tidak terus berjalan: macOS hanya menjalankannya saat ada file atau tautan yang perlu diantarkan, dan aplikasi itu keluar setelah menganggur kurang dari satu detik. Aplikasi ini tidak memiliki jendela dan tidak muncul di Dock. Tautan yang diatur ke **Jangan buka** juga dikirim ke aplikasi pembantu, yang hanya mengabaikannya.

File dianggap biner jika 8 KB pertamanya berisi byte nol atau bukan UTF-8 yang valid.

Jenis file yang sudah didukung oleh aplikasi pilihan Anda, seperti `.md` atau `.py`, ditetapkan langsung ke aplikasi itu, tanpa melalui aplikasi pembantu.

macOS tidak menyediakan API publik untuk menetapkan aplikasi default bagi `public.data`, dan sejak macOS 26.4 API publiknya meminta konfirmasi untuk setiap jenis file yang Anda ubah. Karena itu, OpenWithPanel menulis semua perubahan jenis file ke preferensi LaunchServices sekaligus dan memulai ulang layanan `lsd` satu kali agar perubahan berlaku. Mekanisme ini tidak didokumentasikan oleh Apple dan dapat berhenti berfungsi setelah pembaruan sistem. Jika suatu perubahan tidak berlaku, OpenWithPanel beralih ke API publik, yang meminta konfirmasi Anda; untuk file tanpa ekstensi, OpenWithPanel menawarkan aturan folder sebagai gantinya.

## FAQ

**Bagaimana cara mengubah aplikasi default untuk file tanpa ekstensi di Mac?**
Buka OpenWithPanel, pilih aplikasi untuk **File Tanpa Ekstensi**, lalu tekan **Terapkan**. Setelah itu, file seperti `.env` dan `Dockerfile` terbuka di aplikasi tersebut.

**Mengapa "Ubah Semua" di Finder tidak berfungsi untuk file `.env`?**
macOS memperlakukannya sebagai data generik (`public.data`) dan memblokir perubahan aplikasi default untuk jenis itu melalui API publiknya. OpenWithPanel mengatasinya dengan aplikasi pembantunya.

**Bagaimana cara menjadikan VS Code, Zed, atau Sublime Text sebagai editor default untuk file kode?**
Pilih editor untuk grup **Kode**, atau untuk format satu per satu, lalu tekan **Terapkan**. Ekstensi tanpa jenis resmi macOS, seperti `.go` dan `.rs`, juga tercakup.

**Bisakah saya mengurungkan semuanya?**
Bisa. OpenWithPanel mencatat asosiasi asli saat pertama kali dijalankan dan tidak pernah menimpa catatan itu. **Pulihkan ke Awal** mengarahkan kembali setiap jenis yang diubah ke aplikasi aslinya.

**Apakah OpenWithPanel mengumpulkan data atau berjalan di latar belakang?**
Tidak. OpenWithPanel tidak membuat koneksi jaringan, tidak mengumpulkan data, tidak memasang agen latar belakang, dan tidak terus berjalan setelah Anda keluar. **Pengaturan › Yang Ditulis OpenWithPanel** menampilkan setiap tempat yang ditulisinya.

**Mengapa OpenWithPanel tidak memakai sandbox?**
macOS tidak mengizinkan aplikasi dalam sandbox mengubah aplikasi default. Sebagai gantinya, OpenWithPanel menggunakan hardened runtime.

## Keterbatasan yang diketahui

- Di macOS, `.ts` dikenali sebagai format video (MPEG-2 transport stream), dan mengubahnya akan memengaruhi file video sungguhan, jadi grup Kode hanya mencakup `.tsx` milik TypeScript. Demikian pula, bagi macOS `.r`, `.exs`, dan `.fs` adalah resource Rez, file sampler Logic, dan shader, sehingga tidak termasuk dalam grup Kode.
- Pengaturan jenis file bergantung pada mekanisme sistem yang tidak terdokumentasi dan dapat berhenti berfungsi setelah pembaruan sistem. Jika itu terjadi, jenis file biasa otomatis beralih ke API sistem (satu konfirmasi per jenis), dan file tanpa ekstensi dapat menggunakan aturan folder sebagai gantinya.
- macOS hanya mengizinkan aplikasi membaca log prosesnya sendiri, sehingga laporan diagnosis tidak menyertakan log OpenWithPanel Helper. Cari `net.zhaojian.openwithpanel` di aplikasi Konsol jika Anda membutuhkannya.
- Terjemahan antarmuka belum ditinjau oleh penutur asli.

## Membangun dari kode sumber

Memerlukan Xcode 27.

```sh
swift test --package-path OpenWithPanelKit
xcodebuild -project OpenWithPanel.xcodeproj -scheme OpenWithPanel build
```

Untuk membuat DMG:

```sh
scripts/package.sh
```

Hasilnya masuk ke `.build/dist/`, bersama cask Homebrew yang dibuat dari `packaging/openwithpanel.rb` dengan versi dan checksum yang sudah diisi. Tanpa variabel lingkungan, aplikasi ditandatangani secara ad hoc dan tidak dinotarisasi; DMG lalu menyertakan `First Launch.txt`. Atur `DEVELOPER_ID` (nama sertifikat Developer ID Application) untuk menandatangani dengannya, dan atur juga `NOTARY_PROFILE` (profil kredensial yang disimpan dengan `xcrun notarytool store-credentials`) untuk menotarisasi dan melakukan staple.

Rilis dibangun oleh workflow GitHub Actions di `.github/workflows/release.yml`. Cara workflow itu menandatangani, dan cara menerbitkan rilis, dijelaskan di [docs/release.md](../release.md).

## Struktur proyek

- `OpenWithPanelKit/`: paket Swift lokal. `OpenWithPanelCore` memuat seluruh logika; `OpenWithPanelPlatform` membungkus API sistem.
- `Apps/OpenWithPanel/`: aplikasi utama (SwiftUI).
- `Apps/Helper/`: aplikasi pembantu yang disematkan di dalam bundel aplikasi utama.
- `scripts/`, `packaging/`: skrip pengemasan dan templat cask Homebrew.

## Lisensi

[MIT](../../LICENSE) © 2026 zhaoJian
