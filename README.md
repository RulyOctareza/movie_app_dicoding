[![Flutter CI](https://github.com/RulyOctareza/movie_app_dicoding/actions/workflows/flutter.yml/badge.svg)](https://github.com/RulyOctareza/movie_app_dicoding/actions)

# movie_app_dicoding

A new Flutter project.

## Setup SSL Pinning

Untuk melakukan setup file sertifikat SSL pinning, ikuti langkah-langkah berikut:

1. Tambahkan konfigurasi berikut pada file `pubspec.yaml`:

   ```yaml
   flutter:
     assets:
       - assets/certificates/tmdb.cer
   ```

2. Simpan file sertifikat `.cer` dari TMDB di folder `assets/certificates/`
