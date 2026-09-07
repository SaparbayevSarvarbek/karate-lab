# Backend API Integration Summary

## ✅ Muvaffaqiyatli ulangan API'lar

### 1. **Dashboard API** (`/dashboard/` va `/my-statistics/`)
**Qaysi page:** Coach Dashboard va Athlete Dashboard

**Ulangan ma'lumotlar:**
- **Coach Dashboard:**
  - `totalAthletes` - Jami sportchilar soni
  - `activeAthletes` - Faol sportchilar soni
  - `totalTests` - Jami testlar soni
  - `totalExercises` - Jami mashqlar soni
  
- **Athlete Dashboard:**
  - `avgScore` - O'rtacha ball
  - `activeDays` - Faol kunlar soni
  - `completedTests` - Bajarilgan testlar soni
  - `recentTests` - So'nggi test natijalari

**Files:**
- `lib/features/dashboard/presentation/views/coach_dashboard_view.dart`
- `lib/features/dashboard/presentation/views/athlete_dashboard_view.dart`
- `lib/features/dashboard/presentation/viewmodels/dashboard_bloc.dart`

---

## 📦 Yaratilgan Arxitektura Qatlamlari

### 1. **API Client Layer** (`lib/core/api/`)
- `api_client.dart` - Dio bilan HTTP client, JWT interceptor
- `api_constants.dart` - Base URL va endpoint lar

### 2. **API Models** (`lib/core/api/models/`)
Barcha API request/response modellari JSON serialization bilan:
- `auth_models.dart` - Login, Logout, Refresh token
- `athlete_models.dart` - Athletes CRUD
- `exercise_models.dart` - Exercises CRUD
- `test_models.dart` - Tests va assignments
- `dashboard_models.dart` - Dashboard statistikasi
- `profile_models.dart` - User profile

### 3. **Repository Layer** (`lib/core/repositories/`)
Clean Architecture pattern asosida:
- `auth_repository.dart` - Authentication
- `athlete_repository.dart` - Athletes management
- `exercise_repository.dart` - Exercises management
- `test_repository.dart` - Tests va assignments
- `dashboard_repository.dart` - Dashboard data

### 4. **Dependency Injection** (`lib/core/di/injection.dart`)
GetIt bilan barcha service va repository lar

---

## 🔌 Mavjud API Endpoints (Hozircha mock data)

### Authentication APIs
- `POST /auth/login/` - ✅ Repository tayyor
- `POST /auth/logout/` - ✅ Repository tayyor
- `POST /auth/refresh/` - ✅ Repository tayyor

### Athletes APIs
- `GET /athletes/` - ✅ Repository tayyor (pagination)
- `POST /athletes/` - ✅ Repository tayyor
- `GET /athletes/{id}/` - ✅ Repository tayyor
- `PUT /athletes/{id}/` - ✅ Repository tayyor
- `DELETE /athletes/{id}/` - ✅ Repository tayyor

### Exercises APIs
- `GET /exercises/` - ✅ Repository tayyor
- `POST /exercises/` - ✅ Repository tayyor
- `GET /exercises/{id}/` - ✅ Repository tayyor
- `PUT /exercises/{id}/` - ✅ Repository tayyor
- `DELETE /exercises/{id}/` - ✅ Repository tayyor

### Tests APIs (Athlete side)
- `GET /my-tests/` - ✅ Repository tayyor
- `POST /my-tests/{id}/start/` - ✅ Repository tayyor
- `POST /my-tests/{id}/finish/` - ✅ Repository tayyor

### Profile API
- `GET /profile/` - ✅ Repository tayyor
- `PUT /profile/` - ✅ Repository tayyor

---

## 🎯 Keyingi Qadamlar

Barcha asosiy sahifalar real API ga ulandi:

- ✅ Login View — `POST /auth/login/`
- ✅ Register View — `POST /auth/register/` (ism, familiya, telefon, username/parol)
- ✅ Athletes List — `GET/POST/DELETE /athletes/`
- ✅ Athlete Profile — `GET /athletes/{id}/`
- ✅ Exercises Library — `GET /exercises/`
- ✅ Add Exercise — `POST /exercises/`
- ✅ Exercise Detail — API `Exercise` modeli orqali
- ✅ Tests Library — `GET /tests/`, `GET /my-tests/`, `POST /tests/{id}/assign/`
- ✅ Test Detail — `POST /my-tests/{id}/start/`, `POST /my-tests/{id}/finish/`
- ✅ Create Test — `POST /tests/` (mashqlar tanlab biriktiriladi)
- ✅ Profile View — `GET /profile/`
- ✅ Profile Edit — `GET/PUT /profile/` (bo'y/vazn API da yo'qligi sababli SharedPrefs'da lokal saqlanadi)
- ✅ Security Settings — `PUT /settings/password/`
- ✅ Logout — `POST /auth/logout/` + tokenni tozalash

Hali API ga ulanmagan (lokal/statik data):
- Mashqlar bazasi (UJT/MJT) — `assets/mashqlar.json` (bu loyiha ichki bazasi, backend'da endpoint yo'q)
- Reports & Analytics — statik demo qiymatlar
- Bildirishnomalar sozlamalari — UI da lokal switch'lar

---

## 🔧 Qo'shimcha Sozlashlar

### SharedPreferences ga qo'shilgan:
- `accessToken` - JWT access token saqlash
- `refreshToken` - JWT refresh token saqlash

### Dependencies:
```yaml
dio: ^5.4.0
pretty_dio_logger: ^1.3.1
json_annotation: ^4.8.1
json_serializable: ^6.7.1
build_runner: ^2.4.7
```

---

## 📝 Mock Data dan Real API ga o'tish

**Hozirgi holat:**
- Barcha auth, dashboard, athletes, exercises, tests va profile sahifalari **real API** ga ulandi ✅
- `MockDataService` va `UserModel` o'chirilgan — mock auth qolmagan
- Mashqlar bazasi (UJT/MJT) assets'dagi `mashqlar.json` dan yuklanadi (loyiha ichki baza)
- Reports sahifasi hali statik demo data ishlatadi

---

## 🖥️ Python Backend (krate_backend)

Backend Django + DRF da yozilgan: `C:\Users\sarva\AndroidStudioProjects\krate_backend`.
To'liq API spetsifikatsiya uchun o'sha papkadagi `README.md` ni qarang.

**Ishga tushirish:**
```powershell
cd C:\Users\sarva\AndroidStudioProjects\krate_backend
.\venv\Scripts\python.exe manage.py runserver 0.0.0.0:8000
```

**Demo akkauntlar:**
- `coach` / `coach1234` (murabbiy)
- `athlete` / `athlete123` (sportchi)

**Swagger:** http://127.0.0.1:8000/api/docs/

**Admin panel:** http://127.0.0.1:8000/admin/ (parol: `admin` / `admin1234`)

---

## ⚠️ Muhim Eslatmalar

1. **JWT Token Refresh** - Avtomatik ishlaydi, 401 xatolikda token yangilanadi
2. **Error Handling** - Har bir repository `Either<ApiException, T>` qaytaradi (dartz package)
3. **Logging** - `PrettyDioLogger` yoqilgan, barcha network call lar consoleda ko'rinadi
4. **Base URL** - Development'da lokal Django server (`api_constants.dart`):
   Android emulator uchun `http://10.0.2.2:8000`, boshqa platformalar uchun
   `http://127.0.0.1:8000`. Production'da real backend domeniga almashtiriladi.
5. **Android cleartext** - `AndroidManifest.xml` da `usesCleartextTraffic="true"`
   va `INTERNET` ruxsati qo'shilgan (lokal HTTP server uchun)

---

## 🚀 Ishlatish

```dart
// Dependency Injection orqali
final dashboardBloc = getIt<DashboardBloc>();

// Bloc event trigger
dashboardBloc.add(LoadCoachDashboard());

// Repository to'g'ridan-to'g'ri
final athleteRepo = getIt<AthleteRepository>();
final result = await athleteRepo.getAthletes(page: 1, size: 20);
result.fold(
  (error) => print('Xatolik: $error'),
  (athletes) => print('Sportchilar: ${athletes.results.length}'),
);
```
