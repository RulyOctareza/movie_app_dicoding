[![Flutter CI](https://github.com/RulyOctareza/movie_app_dicoding/actions/workflows/flutter.yml/badge.svg)](https://github.com/RulyOctareza/movie_app_dicoding/actions)

# movie_app_dicoding

A new Flutter project.

## Setup SSL Pinning

Untuk melakukan setup file sertifikat SSL pinning, ikuti langkah-langkah berikut:

1. Tambahkan konfigurasi berikut pada file `pubspec.yaml`:

   ```yaml
   flutter:
     assets:
       - assets/certificates/themoviedb.org.pem
   ```

2. Simpan file sertifikat `.cer` dari TMDB di folder `assets/certificates/`

## Screenshots

Berikut adalah beberapa screenshot hasil integrasi Analytics & Crashlytics:

### Firebase Analytics

![Analytics Dashboard](screenshots/analytics.png)
![Analytics Event](screenshots/analytics2.png)

### Firebase Crashlytics

![Crashlytics Dashboard](screenshots/crashlytics.png)

## Build Status

![Build Actions](screenshots/build-actions.png)
![Passing](screenshots/passing.png)
