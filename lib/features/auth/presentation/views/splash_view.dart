import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/services/shared_prefs_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPrefsService.getInstance();
    final isFirstTime = await prefs.isFirstTimeLaunch();
    final accessToken = prefs.getAccessToken();
    final role = await prefs.getSelectedRole() ?? AppConstants.roleAthlete;

    if (!mounted) return;
    if (!isFirstTime && accessToken != null && accessToken.isNotEmpty) {
      context.go('/main', extra: role);
    } else if (isFirstTime) {
      context.go('/language');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: const SplashBody(),
    );
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SplashLogo(),
          SizedBox(height: 16),
          SplashTitle(),
          SizedBox(height: 8),
          SplashSubtitle(),
        ],
      ),
    );
  }
}

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(Icons.sports_martial_arts, size: 60, color: Colors.white),
    );
  }
}

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'KarateLab AI',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlue,
      ),
    );
  }
}

class SplashSubtitle extends StatelessWidget {
  const SplashSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'AI yordamida chempionlik sari',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
