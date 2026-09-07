# AGENTS.md — KarateLab AI loyihasi

## Loyiha haqida

Flutter mobil ilova (Dart 3.11, Flutter 3.x) + Python Django backend:

- **Mobil ilova:** `C:\Users\sarva\AndroidStudioProjects\krate_lab`
- **Backend:** `C:\Users\sarva\AndroidStudioProjects\krate_backend` (Django 5.1 + DRF, PostgreSQL)
- Arxitektura: Clean-ish layered — `core/api` (Dio client, freezed models) → `core/repositories` (dartz `Either`) → `features/*/presentation/viewmodels` (flutter_bloc) → `views`
- DI: GetIt (`lib/core/di/injection.dart`)
- Routing: go_router (`lib/core/router/app_router.dart`)
- API javob formati: `{success, data}` envelope; kalitlar camelCase/snake_case ikkalasi ham qabul qilinadi (ApiClient normalizatsiya qiladi)

## Buyruqlar

### Flutter

```powershell
cd C:\Users\sarva\AndroidStudioProjects\krate_lab
flutter pub get
flutter analyze --no-pub
flutter test
dart run build_runner build   # freezed/json_serializable o'zgartirilganda
flutter build apk --release
```

APK yo'li: `build\app\outputs\flutter-apk\app-release.apk`

Eslatma: `android/gradle.properties` da JVM xotirasi `-Xmx2560m -XX:MaxMetaspaceSize=768m`
(16GB RAM li mashinada `-Xmx4096m` build paytida native OOM crash bergan).
Build'da OutOfMemoryError bo'lsa shu sozlamani tekshiring va Gradle daemon larni to'xtating
(`android\gradlew.bat --stop`).

### Backend

```powershell
cd C:\Users\sarva\AndroidStudioProjects\krate_backend
.\venv\Scripts\python.exe manage.py runserver 0.0.0.0:8000
.\venv\Scripts\python.exe manage.py test          # Django testlar (hozircha yo'q)
.\venv\Scripts\python.exe manage.py makemigrations
.\venv\Scripts\python.exe manage.py migrate
.\venv\Scripts\python.exe manage.py seed_demo     # demo data
```

- Swagger: http://127.0.0.1:8000/api/docs/
- Admin: http://127.0.0.1:8000/admin/ (`admin` / `admin1234`)
- API test suite (lokal server yoniq bo'lishi kerak):
  `python C:\Users\sarva\AppData\Local\Temp\kilo\test_api.py` — 32 ta endpoint testi

## Muhim sozlamalar

- **Mobile baseUrl** (`lib/core/api/api_constants.dart`): development'da lokal Django server.
  Android emulator → `http://10.0.2.2:8000`, boshqa → `http://127.0.0.1:8000`. Production'da `https://carate.uz` ga o'zgartiriladi.
- **Android** (`android/app/src/main/AndroidManifest.xml`): `INTERNET` ruxsati va `usesCleartextTraffic="true"` qo'shilgan (lokal HTTP uchun).
- **PostgreSQL:** server service `postgresql-x64-18`, DB `krate_lab`, foydalanuvchi `postgres`. Maxfiy qiymatlar `krate_backend/.env` da.
- **JWT:** simplejwt, access 1 soat / refresh 14 kun; refresh logout'da `RefreshTokenRecord` orqali bekor qilinadi.

## Kod yozish qoidalari

- Izoh (comment) yozmang (faqat kerak bo'lgan joyda).
- Mavjud error handling namunasiga rioya qiling: repository → `Either<ApiException, T>`, view → SnackBar.
- Yangi freezed model qo'shilsa: `dart run build_runner build`.
- Har o'zgarishdan keyin `flutter analyze --no-pub` va `flutter test` majburiy.
- Register/login maydonlari: `role` lowercase yuboriladi (`coach`/`athlete`), sana `YYYY-MM-DD` yoki `DD/MM/YYYY`.
