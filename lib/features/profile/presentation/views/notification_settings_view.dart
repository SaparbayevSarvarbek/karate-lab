import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';

/// Bildirishnoma sozlamalari (Swagger: `GET /settings/`,
/// `PUT /settings/notifications/`).
class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  static const Map<String, bool> _defaults = {
    'newTests': true,
    'trainingReminders': true,
    'testResults': true,
    'communityUpdates': false,
    'marketing': false,
  };

  bool _loading = true;
  bool _saving = false;
  final Map<String, bool> _prefs = Map.of(_defaults);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await getIt<SettingsRepository>().getSettings();
    if (!mounted) return;
    result.fold(
      (_) {},
      (settings) {
        final saved = settings.notificationPreferences;
        if (saved != null) {
          for (final key in _defaults.keys) {
            final value = saved[key];
            if (value is bool) _prefs[key] = value;
          }
        }
      },
    );
    setState(() => _loading = false);
  }

  Future<void> _toggle(String key, bool value) async {
    if (_saving) return;
    setState(() {
      _prefs[key] = value;
      _saving = true;
    });
    final result = await getIt<SettingsRepository>()
        .updateNotificationPreferences({'preferences': Map.of(_prefs)});
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (error) {
        setState(() => _prefs[key] = !_prefs[key]!);
        AppSnackbar.error(context, error.message);
      },
      (_) {},
    );
  }

  /// Bitta qator — profil menyusidagi `AppMenuRow` bilan bir xil ko'rinishda,
  /// faqat o'ng tomonda `Switch` turadi.
  Widget _toggleRow({
    required String key,
    required IconData icon,
    required Color tint,
    required String title,
    required String subtitle,
  }) {
    return AppMenuRow(
      icon: icon,
      tint: tint,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: _prefs[key] ?? false,
        activeThumbColor: AppColors.primaryBlue,
        onChanged: _saving ? null : (v) => _toggle(key, v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: KarateAppBar(title: Tr.t('notifications')),
      body: _loading
          ? const AppLoadingView()
          : AbsorbPointer(
              absorbing: _saving,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.screenTop.h,
                  AppSpacing.screenH.w,
                  AppSpacing.screenBottom.h,
                ),
                children: [
                  AppGroupLabel(title: Tr.t('notifications')),
                  SizedBox(height: AppSpacing.sm.h),
                  AppGroup(
                    children: [
                      _toggleRow(
                        key: 'newTests',
                        icon: Icons.assignment_outlined,
                        tint: AppColors.primaryBlue,
                        title: Tr.t('notifNewTests'),
                        subtitle: Tr.t('notifNewTestsSub'),
                      ),
                      _toggleRow(
                        key: 'trainingReminders',
                        icon: Icons.alarm_rounded,
                        tint: AppColors.warning,
                        title: Tr.t('notifTraining'),
                        subtitle: Tr.t('notifTrainingSub'),
                      ),
                      _toggleRow(
                        key: 'testResults',
                        icon: Icons.bar_chart_rounded,
                        tint: AppColors.success,
                        title: Tr.t('notifResults'),
                        subtitle: Tr.t('notifResultsSub'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sectionGap.h),
                  AppGroupLabel(title: Tr.t('social')),
                  SizedBox(height: AppSpacing.sm.h),
                  AppGroup(
                    children: [
                      _toggleRow(
                        key: 'communityUpdates',
                        icon: Icons.people_outline_rounded,
                        tint: AppColors.purple,
                        title: Tr.t('notifCommunity'),
                        subtitle: Tr.t('notifCommunitySub'),
                      ),
                      _toggleRow(
                        key: 'marketing',
                        icon: Icons.campaign_outlined,
                        tint: context.palette.textSecondary,
                        title: Tr.t('notifMarketing'),
                        subtitle: Tr.t('notifMarketingSub'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
