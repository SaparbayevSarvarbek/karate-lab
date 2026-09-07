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
import '../../features/mashqlar/presentation/views/mashqlar_view.dart';
import '../../features/mashqlar/presentation/views/ujt_test_detail_view.dart';
import '../../features/profile/presentation/views/notification_settings_view.dart';
import '../../features/profile/presentation/views/profile_edit_view.dart';
import '../../features/profile/presentation/views/reports_analytics_view.dart';
import '../../features/profile/presentation/views/security_settings_view.dart';
import '../../features/tests/presentation/views/create_test_view.dart';
import '../../features/tests/presentation/views/test_detail_view.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/models/athlete_models.dart';
import '../../core/api/models/exercise_models.dart';
import '../../core/api/models/test_models.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
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
          return ExerciseDetailView(exercise: state.extra as Exercise?);
        },
      ),
      GoRoute(
        path: '/add-exercise',
        builder: (context, state) => const AddExerciseView(),
      ),
      GoRoute(
        path: '/test-detail',
        builder: (context, state) {
          return TestDetailView(assignment: state.extra as TestAssignment?);
        },
      ),
      GoRoute(
        path: '/create-test',
        builder: (context, state) => const CreateTestView(),
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
        path: '/profile-edit',
        builder: (context, state) => ProfileEditView(
          role: state.extra as String?,
        ),
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
        builder: (context, state) => const ReportsAnalyticsView(),
      ),
    ],
  );
}
