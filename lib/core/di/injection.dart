import 'package:get_it/get_it.dart';

import '../api/api_client.dart';
import '../repositories/athlete_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/dashboard_repository.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/test_repository.dart';
import '../repositories/ujt_repository.dart';
import '../services/shared_prefs_service.dart';
import '../../features/athletes/presentation/viewmodels/athlete_bloc.dart';
import '../../features/dashboard/presentation/viewmodels/dashboard_bloc.dart';
import '../../features/exercises/presentation/viewmodels/exercise_bloc.dart';
import '../../features/mashqlar/presentation/viewmodels/mashqlar_bloc.dart';
import '../../features/profile/presentation/viewmodels/profile_bloc.dart';
import '../../features/tests/presentation/viewmodels/test_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPrefsService.getInstance();
  getIt.registerSingleton<SharedPrefsService>(prefs);

  getIt.registerSingleton<ApiClient>(ApiClient(prefs));

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiClient>(), getIt<SharedPrefsService>()),
  );

  getIt.registerLazySingleton<AthleteRepository>(
    () => AthleteRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<TestRepository>(
    () => TestRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<UjtRepository>(
    () => UjtRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(getIt<DashboardRepository>()),
  );

  getIt.registerFactory<AthleteBloc>(
    () => AthleteBloc(getIt<AthleteRepository>()),
  );

  getIt.registerFactory<ExerciseBloc>(
    () => ExerciseBloc(getIt<ExerciseRepository>()),
  );

  getIt.registerFactory<TestBloc>(
    () => TestBloc(getIt<TestRepository>()),
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<ProfileRepository>(), getIt<SettingsRepository>()),
  );

  getIt.registerFactory<MashqlarBloc>(
    () => MashqlarBloc(getIt<UjtRepository>()),
  );
}
