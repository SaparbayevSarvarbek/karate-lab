import 'package:flutter/material.dart';

import '../api/models/profile_models.dart';
import '../di/injection.dart';
import '../l10n/app_translations.dart';
import '../repositories/profile_repository.dart';
import 'karate_app_bar.dart';

/// Bosh sahifalar uchun yuqori panel: foydalanuvchi rasmi + ism-familiya
/// (sarlavha) va vaqtga qarab salomlashish (kichik yozuv).
///
/// Profil **bir marta** (initState'da) so'raladi — har rebuild'da emas.
class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String fallbackName;
  final List<Widget>? actions;

  const DashboardAppBar({
    super.key,
    required this.fallbackName,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  late final Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = getIt<ProfileRepository>()
        .getProfile()
        .then((result) => result.fold((_) => null, (profile) => profile));
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return Tr.t('goodMorning');
    if (hour < 18) return Tr.t('goodDay');
    return Tr.t('goodEvening');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return KarateAppBar(
          title: profile?.fullName ?? widget.fallbackName,
          subtitle: _greeting,
          showAvatar: true,
          avatarUrl: profile?.avatar,
          actions: widget.actions,
        );
      },
    );
  }
}
