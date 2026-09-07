import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';

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
      appBar: AppBar(
        title: Text(Tr.t('notifications')),
        centerTitle: true,
      ),
      body: AbsorbPointer(
        absorbing: _loading || _saving,
        child: Opacity(
          opacity: _saving ? 0.7 : 1,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              NotificationSectionHeader(title: Tr.t('notifications')),
              const SizedBox(height: 16),
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
              const Divider(height: 32),
              NotificationSectionHeader(title: Tr.t('social')),
              const SizedBox(height: 16),
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
              if (_loading)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
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
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          NotificationTileIcon(icon: icon, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: NotificationTileText(title: title, subtitle: subtitle),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primaryBlue,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class NotificationTileText extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationTileText({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
