import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/models/profile_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_step_badge.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../auth/presentation/viewmodels/bloc/auth_bloc.dart';
import '../viewmodels/profile_bloc.dart';

/// Profil sahifasi (Swagger: `GET /profile/`).
class ProfileView extends StatefulWidget {
  final String? userRole;

  const ProfileView({super.key, this.userRole});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..add(const LoadProfile()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final profile = state is ProfileLoaded
                ? state.profile
                : state is ProfileUpdated
                    ? state.profile
                    : null;
            final loading = state is ProfileLoading && profile == null;

            final role = profile != null && profile.role.isNotEmpty
                ? profile.role.toLowerCase()
                : (widget.userRole ?? AppConstants.roleAthlete);
            final isCoach = role == AppConstants.roleCoach;

            return Scaffold(
              backgroundColor: context.palette.background,
              appBar: KarateAppBar(title: Tr.t('profile')),
              body: RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH.w,
                    AppSpacing.sm.h,
                    AppSpacing.screenH.w,
                    AppSpacing.xxl.h,
                  ),
                  child: Column(
                    children: [
                      if (loading)
                        const ShimmerProfileAvatar()
                      else
                        ProfileAvatarSection(isCoach: isCoach, profile: profile),
                      SizedBox(height: AppSpacing.xl.h),
                      if (loading)
                        const ProfileStatsShimmer()
                      else
                        ProfileStatsRow(profile: profile),
                      SizedBox(height: AppSpacing.xl.h),
                      if (loading)
                        const ShimmerListTile(hasLeading: true, lines: 1)
                      else
                        ProfileMenuList(isCoach: isCoach),
                      SizedBox(height: AppSpacing.xxl.h),
                      const ProfileLogoutButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    bloc.add(const LoadProfile());
    await bloc.stream.firstWhere(
      (s) => s is ProfileLoaded || s is ProfileError,
    );
  }
}

class ProfileAvatarSection extends StatelessWidget {
  final bool isCoach;
  final Profile? profile;

  const ProfileAvatarSection({
    super.key,
    required this.isCoach,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final username = profile?.username ?? '';
    return Column(
      children: [
        ProfileAvatar(isCoach: isCoach, profile: profile),
        SizedBox(height: 14.h),
        ProfileName(isCoach: isCoach, name: profile?.fullName ?? ''),
        SizedBox(height: 8.h),
        AppStepBadge(
          label: isCoach ? Tr.t('badgeCoach') : Tr.t('badgeAthlete'),
        ),
        if (username.isNotEmpty) ...[
          SizedBox(height: 6.h),
          Text(
            username,
            style: AppTextStyles.caption
                .copyWith(color: context.palette.textSecondary),
          ),
        ],
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final bool isCoach;
  final Profile? profile;

  const ProfileAvatar({super.key, required this.isCoach, this.profile});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AvatarImage(
          url: profile?.avatar,
          size: 72,
          name: profile?.fullName ?? '',
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              final result = await context.push(
                '/profile-edit',
                extra:
                    isCoach ? AppConstants.roleCoach : AppConstants.roleAthlete,
              );
              if (!context.mounted) return;
              if (result is Profile) {
                context.read<ProfileBloc>().add(const LoadProfile());
              }
            },
            child: Container(
              width: 26.w,
              height: 26.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
                border: Border.all(color: palette.background, width: 2.w),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 13.w),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileName extends StatelessWidget {
  final bool isCoach;
  final String name;

  const ProfileName({super.key, required this.isCoach, this.name = ''});

  @override
  Widget build(BuildContext context) {
    final display = name.isNotEmpty ? name : Tr.t('userFallback');
    return Text(
      display,
      textAlign: TextAlign.center,
      style: AppTextStyles.screenTitle.copyWith(
        fontSize: 19.sp,
        color: context.palette.textPrimary,
      ),
    );
  }
}

class ProfileStatsRow extends StatelessWidget {
  final Profile? profile;

  const ProfileStatsRow({super.key, this.profile});

  int? _age() {
    final raw = profile?.birthDate;
    if (raw == null || raw.isEmpty) return null;
    final date = DateTime.tryParse(raw);
    if (date == null) return null;
    final now = DateTime.now();
    var age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age >= 0 ? age : null;
  }

  @override
  Widget build(BuildContext context) {
    final height = profile?.heightCm;
    final weight = profile?.weightKg;
    final age = _age();
    return Row(
      children: [
        Expanded(
          child: ProfileStatCard(
            value: height == null ? '—' : '$height',
            label: 'Bo\'y',
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: ProfileStatCard(
            value: weight == null ? '—' : '$weight',
            label: 'Vazn',
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: ProfileStatCard(
            value: age == null ? '—' : '$age',
            label: 'Yosh',
          ),
        ),
      ],
    );
  }
}

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: palette.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStatsShimmer extends StatelessWidget {
  const ProfileStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _tile()),
        SizedBox(width: AppSpacing.md.w),
        Expanded(child: _tile()),
        SizedBox(width: AppSpacing.md.w),
        Expanded(child: _tile()),
      ],
    );
  }

  Widget _tile() => ShimmerPlaceholder(
        width: double.infinity,
        height: 74.h,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
      );
}

class ProfileMenuList extends StatelessWidget {
  final bool isCoach;

  const ProfileMenuList({super.key, required this.isCoach});

  @override
  Widget build(BuildContext context) {
    final role =
        isCoach ? AppConstants.roleCoach : AppConstants.roleAthlete;
    return Column(
      children: [
        ProfileMenuGroup(
          children: [
            ProfileMenuItem(
              title: Tr.t('menuPersonal'),
              icon: Icons.person_outline,
              onTap: () async {
                final result = await context.push(
                  '/profile-edit',
                  extra: role,
                );
                if (!context.mounted) return;
                if (result is Profile) {
                  context.read<ProfileBloc>().add(const LoadProfile());
                }
              },
            ),
            ProfileMenuItem(
              title: Tr.t('menuNotifications'),
              icon: Icons.notifications_none,
              onTap: () => context.push('/notification-settings'),
            ),
            ProfileMenuItem(
              title: Tr.t('menuSecurity'),
              icon: Icons.lock_outline,
              onTap: () => context.push('/security-settings'),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        ProfileMenuGroup(
          children: [
            ProfileMenuItem(
              title: Tr.t('menuReports'),
              icon: Icons.bar_chart,
              onTap: () => context.push('/reports', extra: role),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        ProfileMenuGroup(
          children: [
            const ProfileThemeToggleItem(),
            ProfileMenuItem(
              title: Tr.t('menuLanguage'),
              icon: Icons.language,
              onTap: () => context.push('/language'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bitta guruh — yumaloqlangan, chegarali `surface` karta. Ichidagi
/// qatorlar 1px `divider` bilan ajratiladi.
class ProfileMenuGroup extends StatelessWidget {
  final List<Widget> children;

  const ProfileMenuGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) rows.add(const ProfileMenuDivider());
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

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tint = danger ? AppColors.error : AppColors.primaryBlue;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: tint, size: 20.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: danger ? AppColors.error : palette.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20.w, color: palette.textHint),
          ],
        ),
      ),
    );
  }
}

class ProfileThemeToggleItem extends StatelessWidget {
  const ProfileThemeToggleItem({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    // `ThemeController` singleton bo'lgani uchun unga to'g'ridan-to'g'ri
    // bog'lanish shart: aks holda switch va yozuv darhol yangilanmaydi.
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final isDark = ThemeController.instance.isDark;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primaryBlue,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  isDark ? Tr.t('themeDark') : Tr.t('themeLight'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Switch(
                value: isDark,
                onChanged: (v) => ThemeController.instance.setDark(v),
                activeThumbColor: AppColors.primaryBlue,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileMenuDivider extends StatelessWidget {
  const ProfileMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 14.w,
      endIndent: 14.w,
      color: context.palette.divider,
    );
  }
}

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => const ProfileLogoutDialog(),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.logout, color: AppColors.error, size: 20.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  Tr.t('logout'),
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileLogoutDialog extends StatelessWidget {
  const ProfileLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Tr.t('logoutConfirmTitle')),
      content: Text(Tr.t('logoutConfirmText')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(Tr.t('cancel'))),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AuthBloc>().add(LogoutRequested());
          },
          child: Text(Tr.t('exit'), style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
