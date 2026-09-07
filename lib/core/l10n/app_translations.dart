import 'package:flutter/material.dart';

import '../services/shared_prefs_service.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._();

  static final LocaleController instance = LocaleController._();

  String _language = 'uz';

  String get language => _language;

  Locale get locale => Locale(_language);

  Future<void> load() async {
    try {
      final prefs = await SharedPrefsService.getInstance();
      _language = prefs.getLanguage() ?? 'uz';
      notifyListeners();
    } catch (_) {
      _language = 'uz';
    }
  }

  Future<void> setLanguage(String code) async {
    if (_language == code) return;
    _language = code;
    notifyListeners();
    try {
      final prefs = await SharedPrefsService.getInstance();
      await prefs.saveLanguage(code);
    } catch (_) {}
  }
}

class Tr {
  Tr._();

  static const Map<String, Map<String, String>> _map = {
    'uz': {
      'appTitle': 'KarateLab AI',
      'navHome': 'Bosh sahifa',
      'navDashboard': 'Dashboard',
      'navExercises': 'Mashqlar',
      'navAthletes': 'Sportchilar',
      'navTests': 'Testlar',
      'navProfile': 'Profil',
      'profile': 'Profil',
      'badgeCoach': 'Professional Murabbiy',
      'badgeAthlete': 'Pro Sportchi',
      'menuPersonal': 'Shaxsiy ma\'lumotlar',
      'menuAddTest': 'Test qo\'shish',
      'menuAddExercise': 'Mashq qo\'shish',
      'menuNotifications': 'Bildirishnomalar',
      'menuSecurity': 'Xavfsizlik va Parol',
      'menuReports': 'Reports & Analytics',
      'menuLanguage': 'Tilni o\'zgartirish',
      'logout': 'Tizimdan chiqish',
      'logoutConfirmTitle': 'Tizimdan chiqish',
      'logoutConfirmText': 'Haqiqatan ham tizimdan chiqmoqchimisiz?',
      'cancel': 'Bekor qilish',
      'exit': 'Chiqish',
      'goodMorning': 'Xayrli tong',
      'goodDay': 'Xayrli kun',
      'goodEvening': 'Xayrli kech',
      'coach': 'Murabbiy',
      'athlete': 'Sportchi',
      'userFallback': 'Foydalanuvchi',
      'totalAthletes': 'Jami sportchilar',
      'activeAthletesShort': 'faol (30 kun)',
      'tests': 'Testlar',
      'exercises': 'Mashqlar',
      'quickActions': 'Tezkor amallar',
      'languageSaved': 'Til saqlandi',
      'continueText': 'Davom etish',
      'chooseLanguage': 'Tilni tanlang',
      'chooseLanguageHint':
          'O\'zingizga qulay bo\'lgan tilni tanlang. Uni istalgan vaqtda sozlashingiz mumkin.',
      'retry': 'Qayta urinish',
      'themeLight': 'Kunduzgi rejim',
      'themeDark': 'Tungi rejim',
      'newTest': 'Yangi test tuzish',
      'newTestSub': 'Mashqlardan test yarating va tayinlang',
      'addExerciseAction': 'Yangi mashq qo\'shish',
      'addExerciseSub': 'Kutubxonaga texnika qo\'shing',
      'exerciseBase': 'Mashqlar bazasi',
      'exerciseBaseSub': 'UJT va MJT dasturlari',
      'reportsMenu': 'Hisobot va tahlillar',
      'reportsSub': 'Umumiy statistika',
      'todaysGoal': 'Bugungi maqsad',
      'heroTests': 'Tayinlangan testlarni bajarish',
      'startTests': 'Testlarni boshlash',
      'avgScore': 'O\'rtacha ball',
      'activeDays': 'Faol kunlar',
      'completed': 'Yakunlangan',
      'myResults': 'Mening natijalarim',
      'noResults': 'Hali test natijalari yo\'q',
      'searchAthlete': 'Sportchi qidirish...',
      'addNewAthlete': 'Yangi sportchi qo\'shish',
      'firstName': 'Ism',
      'lastName': 'Familiya',
      'birthDate': 'Tug\'ilgan sana',
      'nameRequired': 'Ism va familiyani kiriting',
      'selectBirthDate': 'Tug\'ilgan sanani tanlang',
      'add': 'Qo\'shish',
      'athletesEmpty': 'Sportchilar ro\'yxati bo\'sh',
      'noOneFound': 'Hech kim topilmadi',
      'deleteAthleteTitle': 'Sportchini o\'chirish',
      'deleteAthleteConfirm': '{name} ro\'yxatdan o\'chirilsinmi?',
      'yearsOld': '{age} yosh',
      'delete': 'O\'chirish',
      'testsMine': 'Testlarim',
      'testsAssigned': 'Mening testlarim',
      'exercisesLibrary': 'Mashqlar kutubxonasi',
      'searchExercise': 'Mashq yoki texnika qidirish...',
      'notifications': 'Bildirishnomalar',
      'notifNewTests': 'Yangi testlar',
      'notifNewTestsSub': 'Yangi test tayinlanganda xabar olish',
      'notifTraining': 'Mashg\'ulot eslatmalari',
      'notifTrainingSub': 'Mashg\'ulot vaqti kelganda eslatma olish',
      'notifResults': 'Test natijalari',
      'notifResultsSub': 'Natijalar tayyor bo\'lganda xabar olish',
      'social': 'Ijtimoiy',
      'notifCommunity': 'Jamiyat yangiliklari',
      'notifCommunitySub': 'Klub yangiliklari va tadbirlar haqida xabar',
      'notifMarketing': 'Marketing',
      'notifMarketingSub': 'Takliflar va yangiliklar haqida xabar',
      'secUpdateHint':
          'Parolingizni xavfsiz saqlash uchun muntazam yangilab turing.',
      'currentPassword': 'Joriy parol',
      'newPassword': 'Yangi parol',
      'confirmPassword': 'Yangi parolni tasdiqlang',
      'enterCurrentPassword': 'Joriy parolni kiriting',
      'enterNewPassword': 'Yangi parolni kiriting',
      'passwordMin': 'Kamida 6 ta belgi',
      'passwordMismatch': 'Parollar mos kelmadi',
      'updating': 'Yangilanmoqda...',
      'updatePasswordBtn': 'Parolni yangilash',
      'passwordUpdated': 'Parol muvaffaqiyatli yangilandi',
      'endSessionTitle': 'Sessiyani yakunlash',
      'endSessionText': '"{device}" qurilmasi chiqarilsinmi?',
      'signOutDevice': 'Chiqarish',
      'logOutOthersTitle': 'Boshqa qurilmalardan chiqish',
      'logOutOthersText':
          'Joriy qurilmadan tashqari barcha faol sessiyalar yakunlanadi. Davom etasizmi?',
      'signingOut': 'Chiqarilmoqda...',
      'logOutOthersBtn': 'Boshqalardan chiqish',
      'sessionsEndedAll': 'Boshqa qurilmalardagi sessiyalar yakunlandi',
      'sessionEnded': 'Sessiya yakunlandi',
      'activeSessions': 'Faol sessiyalar',
      'swipeHint': 'O\'chirish uchun chapga suring',
      'noSessions': 'Faol sessiyalar topilmadi',
      'activeBadge': 'Faol',
      'deleteAccountTitle': 'Akkauntni o\'chirish',
      'deleteAccountText':
          'Bu amal qaytarib bo\'lmaydi. Barcha ma\'lumotlaringiz butunlay o\'chib ketadi.',
    },
    'en': {
      'appTitle': 'KarateLab AI',
      'navHome': 'Home',
      'navDashboard': 'Dashboard',
      'navExercises': 'Exercises',
      'navAthletes': 'Athletes',
      'navTests': 'Tests',
      'navProfile': 'Profile',
      'profile': 'Profile',
      'badgeCoach': 'Professional Coach',
      'badgeAthlete': 'Pro Athlete',
      'menuPersonal': 'Personal info',
      'menuAddTest': 'Add test',
      'menuAddExercise': 'Add exercise',
      'menuNotifications': 'Notifications',
      'menuSecurity': 'Security & Password',
      'menuReports': 'Reports & Analytics',
      'menuLanguage': 'Change language',
      'logout': 'Log out',
      'logoutConfirmTitle': 'Log out',
      'logoutConfirmText': 'Are you sure you want to log out?',
      'cancel': 'Cancel',
      'exit': 'Log out',
      'goodMorning': 'Good morning',
      'goodDay': 'Good afternoon',
      'goodEvening': 'Good evening',
      'coach': 'Coach',
      'athlete': 'Athlete',
      'userFallback': 'User',
      'totalAthletes': 'Total athletes',
      'activeAthletesShort': 'active (30 days)',
      'tests': 'Tests',
      'exercises': 'Exercises',
      'quickActions': 'Quick actions',
      'languageSaved': 'Language saved',
      'continueText': 'Continue',
      'chooseLanguage': 'Choose language',
      'chooseLanguageHint':
          'Select your preferred language. You can change it anytime.',
      'retry': 'Retry',
      'themeLight': 'Light mode',
      'themeDark': 'Dark mode',
      'newTest': 'Create new test',
      'newTestSub': 'Build a test from exercises and assign it',
      'addExerciseAction': 'Add new exercise',
      'addExerciseSub': 'Add a technique to the library',
      'exerciseBase': 'Exercise base',
      'exerciseBaseSub': 'UJT and MJT programs',
      'reportsMenu': 'Reports & analytics',
      'reportsSub': 'Overall statistics',
      'todaysGoal': 'Today\'s goal',
      'heroTests': 'Complete your assigned tests',
      'startTests': 'Start tests',
      'avgScore': 'Average score',
      'activeDays': 'Active days',
      'completed': 'Completed',
      'myResults': 'My results',
      'noResults': 'No test results yet',
      'searchAthlete': 'Search athlete...',
      'addNewAthlete': 'Add new athlete',
      'firstName': 'First name',
      'lastName': 'Last name',
      'birthDate': 'Date of birth',
      'nameRequired': 'Enter first and last name',
      'selectBirthDate': 'Select date of birth',
      'add': 'Add',
      'athletesEmpty': 'Athletes list is empty',
      'noOneFound': 'No one found',
      'deleteAthleteTitle': 'Remove athlete',
      'deleteAthleteConfirm': 'Remove {name} from the list?',
      'yearsOld': '{age} y.o.',
      'delete': 'Delete',
      'testsMine': 'My tests',
      'testsAssigned': 'My tests',
      'exercisesLibrary': 'Exercise library',
      'searchExercise': 'Search exercise or technique...',
      'notifications': 'Notifications',
      'notifNewTests': 'New tests',
      'notifNewTestsSub': 'Get notified when a new test is assigned',
      'notifTraining': 'Training reminders',
      'notifTrainingSub': 'Get a reminder when it\'s training time',
      'notifResults': 'Test results',
      'notifResultsSub': 'Get notified when results are ready',
      'social': 'Social',
      'notifCommunity': 'Community updates',
      'notifCommunitySub': 'Club news and events',
      'notifMarketing': 'Marketing',
      'notifMarketingSub': 'Offers and news',
      'secUpdateHint': 'Update your password regularly to keep it secure.',
      'currentPassword': 'Current password',
      'newPassword': 'New password',
      'confirmPassword': 'Confirm new password',
      'enterCurrentPassword': 'Enter current password',
      'enterNewPassword': 'Enter new password',
      'passwordMin': 'At least 6 characters',
      'passwordMismatch': 'Passwords do not match',
      'updating': 'Updating...',
      'updatePasswordBtn': 'Update password',
      'passwordUpdated': 'Password updated successfully',
      'endSessionTitle': 'End session',
      'endSessionText': 'Sign out device "{device}"?',
      'signOutDevice': 'Sign out',
      'logOutOthersTitle': 'Log out other devices',
      'logOutOthersText':
          'All active sessions except this device will be ended. Continue?',
      'signingOut': 'Signing out...',
      'logOutOthersBtn': 'Log out others',
      'sessionsEndedAll': 'Sessions on other devices ended',
      'sessionEnded': 'Session ended',
      'activeSessions': 'Active sessions',
      'swipeHint': 'Swipe left to sign out',
      'noSessions': 'No active sessions found',
      'activeBadge': 'Active',
      'deleteAccountTitle': 'Delete account',
      'deleteAccountText':
          'This action cannot be undone. All your data will be permanently deleted.',
    },
  };

  static String t(String key, [Map<String, String>? args]) {
    final lang = LocaleController.instance.language;
    var text = _map[lang]?[key] ?? _map['uz']![key] ?? key;
    if (args != null) {
      args.forEach((k, v) => text = text.replaceAll('{$k}', v));
    }
    return text;
  }
}
