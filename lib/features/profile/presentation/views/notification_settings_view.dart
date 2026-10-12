import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: KarateAppBar(title: Tr.t('notifications')),
      body: AbsorbPointer(
        absorbing: _loading || _saving,
        child: Opacity(
          opacity: _saving ? 0.7 : 1,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenH.w,
              AppSpacing.sm.h,
              AppSpacing.screenH.w,
              AppSpacing.xxl.h,
            ),
            children: [
              NotificationSectionHeader(title: Tr.t('notifications')),
              SizedBox(height: AppSpacing.md.h),
              NotificationGroupCard(
                children: [
                  NotificationTile(
                    icon: Icons.assignment_outlined,
                    iconColor: AppColors.primaryBlue,
                    title: Tr.t('notifNewTests'),
                    subtitle: Tr.t('notifNewTestsSub'),
                    value: _prefs['newTests'] ?? true,
                    onChanged: (v) => _toggle('newTests', v),
                  ),
                  NotificationTile(
                    icon: Icons.alarm,
                    iconColor: AppColors.warning,
                    title: Tr.t('notifTraining'),
                    subtitle: Tr.t('notifTrainingSub'),
                    value: _prefs['trainingReminders'] ?? true,
                    onChanged: (v) => _toggle('trainingReminders', v),
                  ),
                  NotificationTile(
                    icon: Icons.bar_chart,
                    iconColor: AppColors.success,
                    title: Tr.t('notifResults'),
                    subtitle: Tr.t('notifResultsSub'),
                    value: _prefs['testResults'] ?? true,
                    onChanged: (v) => _toggle('testResults', v),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxl.h),
              NotificationSectionHeader(title: Tr.t('social')),
              SizedBox(height: AppSpacing.md.h),
              NotificationGroupCard(
                children: [
                  NotificationTile(
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF9333EA),
                    title: Tr.t('notifCommunity'),
                    subtitle: Tr.t('notifCommunitySub'),
                    value: _prefs['communityUpdates'] ?? false,
                    onChanged: (v) => _toggle('communityUpdates', v),
                  ),
                  NotificationTile(
                    icon: Icons.campaign_outlined,
                    iconColor: AppColors.textHint,
                    title: Tr.t('notifMarketing'),
                    subtitle: Tr.t('notifMarketingSub'),
                    value: _prefs['marketing'] ?? false,
                    onChanged: (v) => _toggle('marketing', v),
                  ),
                ],
              ),
              if (_loading)
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xxl.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bitta guruh — yumaloqlangan, chegarali `surface` karta. Qatorlar 1px
/// `divider` bilan ajratiladi.
class NotificationGroupCard extends StatelessWidget {
  final List<Widget> children;

  const NotificationGroupCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(Divider(
          height: 1,
          thickness: 1,
          indent: 14.w,
          endIndent: 14.w,
          color: palette.divider,
        ));
      }
      rows.add(children[i]);
    }
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(children: rows),
    );
  }
}

class NotificationSectionHeader extends StatelessWidget {
  final String title;
  const NotificationSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(
        fontWeight: FontWeight.w700,
        color: context.palette.textSecondary,
        letterSpacing: 1.1,
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          NotificationTileIcon(icon: icon, color: iconColor),
          SizedBox(width: 12.w),
          Expanded(
            child: NotificationTileText(title: title, subtitle: subtitle),
          ),
          SizedBox(width: 8.w),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}

class NotificationTileIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const NotificationTileIcon({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: color, size: 20.w),
    );
  }
}

class NotificationTileText extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationTileText({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.5.sp,
            color: palette.textPrimary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
