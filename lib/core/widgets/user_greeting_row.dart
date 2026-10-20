import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../api/models/profile_models.dart';
import '../di/injection.dart';
import '../l10n/app_translations.dart';
import '../repositories/profile_repository.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'remote_image.dart';

/// Bosh sahifadagi salomlashish qatori: avatar + vaqtga qarab salomlashish + ism.
///
/// Profil **bir marta** (initState'da) so'raladi. Avval har bir rebuild'da
/// `FutureBuilder` yangi so'rov yuborardi — bu ortiqcha tarmoq yuklamasi edi.
class UserGreetingRow extends StatefulWidget {
  final String fallbackName;

  const UserGreetingRow({super.key, required this.fallbackName});

  @override
  State<UserGreetingRow> createState() => _UserGreetingRowState();
}

class _UserGreetingRowState extends State<UserGreetingRow> {
  late final Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = getIt<ProfileRepository>().getProfile().then(
      (result) => result.fold((_) => null, (profile) => profile),
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return Tr.t('goodMorning');
    if (hour < 18) return Tr.t('goodDay');
    return Tr.t('goodEvening');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return FutureBuilder<Profile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return Row(
          children: [
            AvatarImage(
              url: profile?.avatar,
              name: profile?.fullName ?? widget.fallbackName,
              size: 44,
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _greeting,
                    style: AppTextStyles.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    profile?.fullName ?? widget.fallbackName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
