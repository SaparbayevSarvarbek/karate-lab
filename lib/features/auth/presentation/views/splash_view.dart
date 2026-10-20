import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_logo.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with WidgetsBindingObserver {
  bool _updateAvailable = false;
  bool _checkingAfterResume = false;
  String? _storeUrl;
  String? _latestVersion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navigate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted && _updateAvailable) {
      _recheckAfterStoreReturn();
    }
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final update = await _checkForUpdate();
    if (!mounted) return;
    if (update != null) {
      setState(() {
        _updateAvailable = true;
        _storeUrl = update.$1;
        _latestVersion = update.$2;
      });
      return;
    }

    await _continueNavigation();
  }

  Future<void> _continueNavigation() async {
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

  Future<void> _recheckAfterStoreReturn() async {
    if (_checkingAfterResume) return;
    _checkingAfterResume = true;
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 750));
    final update = await _checkForUpdate();
    if (!mounted) return;

    if (update == null) {
      setState(() {
        _updateAvailable = false;
        _storeUrl = null;
        _latestVersion = null;
      });
      await _continueNavigation();
      return;
    }

    setState(() {
      _updateAvailable = true;
      _storeUrl = update.$1;
      _latestVersion = update.$2;
      _checkingAfterResume = false;
    });
  }

  Future<(String, String)?> _checkForUpdate() async {
    try {
      final latest = await getIt<ApiClient>().getObject(
        ApiConstants.appVersion,
        options: Options(
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
        ),
      );
      if (latest == null) {
        debugPrint('[KarateLab] App version check returned an empty response');
        return null;
      }

      final latestBuild = int.tryParse('${latest['latestBuildNumber']}');
      final storeUrl = latest['storeUrl']?.toString();
      final latestVersion = latest['latestVersion']?.toString();
      if (latestBuild == null ||
          storeUrl == null ||
          storeUrl.isEmpty ||
          latestVersion == null ||
          latestVersion.isEmpty) {
        debugPrint(
          '[KarateLab] App version response is missing required fields',
        );
        return null;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final installedBuild = int.tryParse(packageInfo.buildNumber);
      if (installedBuild == null) {
        debugPrint(
          '[KarateLab] Installed app build number is invalid: '
          '${packageInfo.buildNumber}',
        );
        return null;
      }

      final uri = Uri.tryParse(storeUrl);
      if (installedBuild < latestBuild &&
          uri != null &&
          (uri.scheme == 'https' || uri.scheme == 'http')) {
        return (storeUrl, latestVersion);
      }
    } on ApiException catch (error) {
      debugPrint('[KarateLab] App version check failed: ${error.message}');
    } on StateError catch (error) {
      debugPrint('[KarateLab] App version service unavailable: $error');
    } on PlatformException catch (error) {
      debugPrint('[KarateLab] App version check unavailable: ${error.message}');
    } on MissingPluginException catch (error) {
      debugPrint('[KarateLab] App version plugin unavailable: $error');
    }
    return null;
  }

  Future<void> _openStore() async {
    final storeUrl = _storeUrl;
    if (storeUrl == null) return;
    try {
      final opened = await launchUrl(
        Uri.parse(storeUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && mounted) {
        AppSnackbar.error(context, Tr.t('updateStoreError'));
      }
    } on PlatformException catch (error) {
      debugPrint('[KarateLab] Could not open the Play Store: ${error.message}');
      if (mounted) AppSnackbar.error(context, Tr.t('updateStoreError'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: SplashBody(
        updateAvailable: _updateAvailable,
        latestVersion: _latestVersion,
        checkingAfterResume: _checkingAfterResume,
        onUpdate: _openStore,
      ),
    );
  }
}

class SplashBody extends StatelessWidget {
  final bool updateAvailable;
  final bool checkingAfterResume;
  final String? latestVersion;
  final VoidCallback? onUpdate;

  const SplashBody({
    super.key,
    this.updateAvailable = false,
    this.checkingAfterResume = false,
    this.latestVersion,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    if (updateAvailable) {
      return SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -110.h,
              right: -95.w,
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              top: 170.h,
              left: -140.w,
              child: Container(
                width: 230.w,
                height: 230.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlueLight.withValues(alpha: 0.06),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH.w,
                    AppSpacing.md.h,
                    AppSpacing.screenH.w,
                    0,
                  ),
                  child: Row(
                    children: [
                      const KarateLabLogo(size: 38),
                      SizedBox(width: AppSpacing.sm.w),
                      Text(
                        'KarateLab AI',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md.w,
                          vertical: AppSpacing.xs.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          'UPDATE',
                          style: AppTextStyles.badge.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenH.w,
                        vertical: AppSpacing.lg.h,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - AppSpacing.xl.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 184.w,
                              height: 184.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 184.w,
                                    height: 184.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryBlue.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 142.w,
                                    height: 142.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.primaryBlueLight,
                                          AppColors.primaryBlueDark,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryBlue
                                              .withValues(alpha: 0.28),
                                          blurRadius: 28,
                                          offset: const Offset(0, 14),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.system_update_rounded,
                                      size: 68.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8.h,
                                    right: 10.w,
                                    child: Container(
                                      width: 42.w,
                                      height: 42.w,
                                      decoration: BoxDecoration(
                                        color: palette.surface,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: palette.textPrimary
                                                .withValues(alpha: 0.1),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.auto_awesome_rounded,
                                        color: AppColors.primaryBlue,
                                        size: 21.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSpacing.xl.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md.w,
                                vertical: AppSpacing.xs.h,
                              ),
                              decoration: BoxDecoration(
                                color: palette.surface,
                                borderRadius: BorderRadius.circular(999.r),
                                border: Border.all(color: palette.border),
                              ),
                              child: Text(
                                'v${latestVersion ?? 'latest'}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            Text(
                              Tr.t('updateTitle'),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.screenTitle.copyWith(
                                color: palette.textPrimary,
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm.h),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 340.w),
                              child: Text(
                                Tr.t('updateRequired', {
                                  'version': latestVersion ?? '',
                                }),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body.copyWith(
                                  color: palette.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH.w,
                    AppSpacing.sm.h,
                    AppSpacing.screenH.w,
                    AppSpacing.xl.h,
                  ),
                  child: Column(
                    children: [
                      CustomButton(
                        text: Tr.t('updateButton'),
                        leadingIcon: Icons.download_rounded,
                        onPressed: onUpdate,
                      ),
                      if (checkingAfterResume) ...[
                        SizedBox(height: AppSpacing.md.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 14.w,
                              height: 14.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm.w),
                            Text(
                              Tr.t('checkingUpdate'),
                              style: AppTextStyles.caption.copyWith(
                                color: palette.textHint,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  KarateLabLogo(size: 88),
                  SizedBox(height: AppSpacing.xxl),
                  _SplashBrandName(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xxxl.h),
            child: Center(
              child: SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBrandName extends StatelessWidget {
  const _SplashBrandName();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'KarateLab AI',
          textAlign: TextAlign.center,
          style: AppTextStyles.brandTitle.copyWith(color: palette.textPrimary),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          'AI yordamida chempionlik sari',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
