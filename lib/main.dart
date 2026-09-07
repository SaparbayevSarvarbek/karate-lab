import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/api/api_client.dart';
import 'core/l10n/app_translations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/services/shared_prefs_service.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/viewmodels/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.getInstance();
  await ThemeController.instance.load();
  await LocaleController.instance.load();
  await setupDependencies();
  ApiClient.onUnauthorized = () {
    final path = AppRouter.router.state.uri.path;
    if (path != '/login' && path != '/') {
      AppRouter.router.go('/login');
    }
  };
  runApp(const KarateLabApp());
}

class KarateLabApp extends StatelessWidget {
  const KarateLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([
          ThemeController.instance,
          LocaleController.instance,
        ]),
        builder: (context, child) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            useInheritedMediaQuery: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'KarateLab AI',
                debugShowCheckedModeBanner: false,
                locale: LocaleController.instance.locale,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeController.instance.themeMode,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
