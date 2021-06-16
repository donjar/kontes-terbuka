# kontes-terbuka: Website Kontes Terbuka Olimpiade Matematika
![Logo Kontes Terbuka Olimpiade Matematika](https://github.com/donjar/kontes-terbuka/raw/production/app/assets/images/logo-hires.png)
[Click here for English version.](ENGLISH.md)
[![Build Status](https://travis-ci.org/donjar/kontes-terbuka.svg?branch=production)](https://travis-ci.org/donjar/kontes-terbuka)
[![Coverage Status](https://coveralls.io/repos/github/donjar/kontes-terbuka/badge.svg?branch=production)](https://coveralls.io/github/donjar/kontes-terbuka?branch=production)

Repo ini berisi kode untuk website Kontes Terbuka Olimpiade Matematika yang
bisa diakses di https://ktom.tomi.or.id. Website ini dibuat oleh dua anggota
KTO Matematika:
- Herbert Ilhan Tanujaya (@donjar)
- Jonathan Mulyawan Woenardi (@woenardi)

Website ini awalnya dibuat dengan tujuan pembelajaran. Namun, website ini terus
berkembang hingga menjadi cukup besar. 



## Panduan setup awal
Catatan: panduan di bawah ini dibuat untuk Ubuntu 20.04 LTS. Untuk sistem operasi
lainnya, pengaturan awal akan sedikit berbeda. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
bisa digunakan untuk menajalankan Ubuntu di dalam sistem operasi lain.

### Paket-paket prasyarat
Mohon unduh dan *install* paket-paket di bawah ini sebelum memulai:
1. `software-properties-common`, paket ini dipakai oleh beberapa paket di bawah
2. `postgresql` untuk database
3. `texlive` untuk menjalankan berbagai fungsi LaTeX yang diperlukan. 
   Kami menyarankan untuk memasang `texlive-full` yang mencakup keseluruhan texlive;
   kalau ruang disk Anda terbatas, `texlive-base` cukup memadai untuk sebagian besar
   pengolahan LaTeX yang diperlukan

Anda bisa menggunakan `apt` untuk memasang paket-paket di atas dengan perintah 
```bash
sudo apt install <nama paket>
```

### Cara setup
1. Pastikan bahwa paket-paket di atas telah di-*install*
2. Unduh semua *file* dalam repositori ini, menggunakan `git clone` atau dengan cara lainnya
3. *Website* ini menggunakan `ruby`, dan untuk memudahkan manajemen versi `ruby` yang digunakan,
Anda boleh memakai `rvm` atau `rbenv`. Kami akan menunjukkan cara *setup* `rvm` dalam panduan ini,
diadaptasi dari [panduan instalasi untuk Ubuntu](https://github.com/rvm/ubuntu_rvm):
   1. Tambah PPA ke dalam komputer, dan *install* `rvm`:
        ```bash
       sudo apt-add-repository -y ppa:rael-gc/rvm
       sudo apt-get update
       sudo apt-get install rvm
       ```
   2. Masukkan *user* Anda ke dalam grup rvm (ganti `<username>` dengan nama *user* Anda):
        ```bash
        sudo usermod -a -G rvm <username>
        ```
   3. Ubah *terminal* untuk menjalankan perintah sebagai *login shell*. Untuk
        mengubah aturan ini secara manual, jalankan perintah `/bin/bash --login`;
        jika Anda menggunakan terminal GNOME, Anda bisa mengubah peraturan ini dari
        *setting* terminal:
        1. Klik menu *hamburger* (3 garis horizontal) dalam terminal.
        2. Klik **Preferences**
        3. Cari profil Anda di *sidebar*, di bawah **Profile**
        4. Pilih *tab* **Command**
        5. Centang **Run command as login shell**
   4. *Reboot* komputer Anda.
   5. Nyalakan *gemset* lokal dengan perintah
        ```bash
        rvm user gemsets
        ```
   6. Sekarang Anda bisa meng-*install* `ruby`. Website KTOM sekarang menggunakan
        ruby versi 2.5.0 (cek *file* **Gemfile** jika kurang yakin - versi ruby 
        yang digunakan akan tertulis dalam file tersebut), dan untuk meng-*install* 
        versi 2.5.0, gunakan perintah
      ```bash
      rvm install 2.5.0
      ```
      Jika `ruby` sudah tersedia dalam komputer Anda sebelum instalasi ini, Anda dapat
      mengubah versi *default* dengan perintah
      ```bash
      rvm --default use 2.5.0
      ```
      diikuti dengan menutup dan membuka kembali terminal.
4. Cek bahwa versi `ruby` yang telah di-*install* benar (versi 2.5.0) dengan
    ```bash
    ruby --version
    ```
5. Pasang `bundler` dan `rails`. Website KTOM sekarang berjalan dengan
   bundler bersi 1.17.3 dan rails versi 4.2.11.1, dan versi mutakhir dapat dilihat di
   *file* **Gemfile** dan **Gemfile.lock**.
   ```bash
    gem install rails -v 4.2.11.1
    gem install bundler -v 1.17.3
    ```
6. Dari dalam direktori repositori yang telah diunduh, jalankan
    ```bash
    bundle install
    ```
   untuk meng-*install* gem-gem yang dibutuhkan.
7. Setelah gem-gem yang diperlukan tersedia, Anda harus membuat dan memodifikasi
    database untuk website ini:
    1. Buat *file* bernama `database.yml` dalam *folder* `config`. Anda bisa melihat *file*
    `database.yml.default` sebagai contoh.
    2. Buat *user* di postgres dengan *username* dan kata sandi yang tertera di `database.yml`.
    Untuk petunjuk di bawah, username yang digunakan adalah `ubuntu`, dan kata sandi yang digunakan adalah `password`
        1. Jalankan perintah `sudo -u postgres psql` untuk masuk kedalam *shell* postgres.
        2. Buat *user* baru: `create user ubuntu with encrypted password 'password';`
        3. Jadikan user tersebut sebagai *superuser*: `alter user "ubuntu" with superuser;`
    3. Buat databse dengan perintah `bundle exec rake db:setup`
    4. Jalankan semua migrasi dengan `bundle exec rake db:migrate`
8. Buat `.env` file di root directory dan pindahkan isi dari `.env.default` kedalam `.env`. Setiap variabel di dalam `.env` diisi sesuai dengan yang dibutuhkan.
9. *Setup* awal untuk menjalankan server selesai. Untuk menjalankan server lokal, gunakan
    ```bash
    bundle exeec rails s
    ```
10. Sekarang, Anda bisa membuat *admin* di dalam website yang telah dibuat:
    1. Dalam *browser*, buka alamat website versi lokal (*default*: `0.0.0.0:3000`)
    2. Buat akun seperti biasa
    3. Anda tidak akan mendapat email, dan harus mengaktivasi akun secara manual.
        Buka konsol rails (perintah: `bundle exec rails c`) dan jalankan `User.first.enable`
    4. Untuk membuat akun tersebut sebagai *admin*, jalankan dua perintah di bawah ini:
    ```bash
    User.first.add_role :panitia
    User.first.add_role :admin 
    ```

Selamat, Anda telah selesai melakukan *setup* awal.

## Kontribusi
Ayok fork :D
