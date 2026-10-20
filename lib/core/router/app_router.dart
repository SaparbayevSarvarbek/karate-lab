import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/athletes/presentation/views/athlete_profile_view.dart';
import '../../features/auth/presentation/views/group_selection_view.dart';
import '../../features/auth/presentation/views/language_selection_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/onboarding_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/auth/presentation/views/role_selection_view.dart';
import '../../features/auth/presentation/views/splash_view.dart';
import '../../features/dashboard/presentation/views/main_layout_view.dart';
import '../../features/exercises/presentation/views/add_exercise_view.dart';
import '../../features/exercises/presentation/views/exercise_detail_view.dart';
import '../../features/exercises/presentation/views/my_exercises_view.dart';
import '../../features/mashqlar/presentation/views/mashqlar_view.dart';
import '../../features/mashqlar/presentation/views/mjt_test_detail_view.dart';
import '../../features/mashqlar/presentation/views/ujt_test_detail_view.dart';
import '../../features/profile/presentation/views/notification_settings_view.dart';
import '../../features/profile/presentation/views/profile_edit_view.dart';
import '../../features/profile/presentation/views/reports_analytics_view.dart';
import '../../features/profile/presentation/views/security_settings_view.dart';
import '../../features/tests/presentation/views/create_test_view.dart';
import '../../features/tests/presentation/views/test_detail_view.dart';
import '../../features/tests/presentation/views/test_result_view.dart';
import '../../features/tests/presentation/views/test_run_view.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/models/athlete_models.dart';
import '../../core/api/models/exercise_models.dart';
import '../../core/api/models/test_models.dart';
import '../../core/l10n/app_translations.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ({String role, String? group})) {
            return RegisterView(role: extra.role, group: extra.group);
          }
          return const RegisterView(role: AppConstants.roleAthlete);
        },
      ),
      GoRoute(
        path: '/group-selection',
        builder: (context, state) {
          final group = state.extra as String?;
          return GroupSelectionView(initialGroup: group);
        },
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) {
          final role = state.extra as String? ?? AppConstants.roleAthlete;
          return MainLayoutView(role: role);
        },
      ),
      GoRoute(
        path: '/exercise-detail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ExerciseDetailArgs) {
            return ExerciseDetailView(
              exercise: extra.exercise,
              canEdit: extra.canEdit,
            );
          }
          return ExerciseDetailView(exercise: extra as Exercise?);
        },
      ),
      GoRoute(
        path: '/add-exercise',
        builder: (context, state) =>
            AddExerciseView(exercise: state.extra as Exercise?),
      ),
      GoRoute(
        path: '/my-exercises',
        builder: (context, state) => const MyExercisesView(),
      ),
      GoRoute(
        path: '/test-detail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is TestEntity) {
            return TestDetailView(coachTest: extra);
          }
          return TestDetailView(result: extra as TestResult?);
        },
      ),
      GoRoute(
        path: '/create-test',
        builder: (context, state) =>
            CreateTestView(test: state.extra as TestEntity?),
      ),
      GoRoute(
        path: '/test-run',
        builder: (context, state) {
          final result = state.extra as TestResult?;
          if (result == null) {
            return Scaffold(body: Center(child: Text(Tr.t('testNotFound'))));
          }
          return TestRunView(result: result);
        },
      ),
      GoRoute(
        path: '/test-result',
        builder: (context, state) {
          return TestResultView(result: state.extra as TestResult?);
        },
      ),
      GoRoute(
        path: '/athlete-profile',
        builder: (context, state) {
          return AthleteProfileView(athlete: state.extra as Athlete?);
        },
      ),
      GoRoute(
        path: '/mashqlar',
        builder: (context, state) => const MashqlarView(),
      ),
      GoRoute(
        path: '/ujt-test-detail',
        builder: (context, state) {
          final id = state.extra as int?;
          return UjtTestDetailView(testId: id ?? 0);
        },
      ),
      GoRoute(
        path: '/mjt-test-detail',
        builder: (context, state) {
          final id = state.extra as int?;
          return MjtTestDetailView(testId: id ?? 0);
        },
      ),
      GoRoute(
        path: '/profile-edit',
        builder: (context, state) =>
            ProfileEditView(role: state.extra as String?),
      ),
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsView(),
      ),
      GoRoute(
        path: '/security-settings',
        builder: (context, state) => const SecuritySettingsView(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) =>
            ReportsAnalyticsView(userRole: state.extra as String?),
      ),
    ],
  );
}
