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
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_list_tile.dart';
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
              appBar: KarateAppBar(title: Tr.t('navProfile'), showLogo: true),
              body: RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenH.w,
                    AppSpacing.screenTop.h,
                    AppSpacing.screenH.w,
                    AppSpacing.screenBottom.h,
                  ),
                  child: Column(
                    children: [
                      if (loading)
                        const ShimmerProfileAvatar()
                      else
                        _ProfileHeader(profile: profile, isCoach: isCoach),
                      SizedBox(height: AppSpacing.xxl.h),
                      ProfileMenuList(isCoach: isCoach),
                      SizedBox(height: AppSpacing.xl.h),
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

/// Avatar + ism + rol nishoni.
class _ProfileHeader extends StatelessWidget {
  final Profile? profile;
  final bool isCoach;

  const _ProfileHeader({required this.profile, required this.isCoach});

  Future<void> _openEdit(BuildContext context) async {
    final result = await context.push(
      '/profile-edit',
      extra: isCoach ? AppConstants.roleCoach : AppConstants.roleAthlete,
    );
    if (!context.mounted) return;
    if (result is Profile) {
      context.read<ProfileBloc>().add(const LoadProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final name = profile?.fullName ?? '';
    final display = name.isNotEmpty ? name : Tr.t('userFallback');
    final roleLabel = isCoach ? Tr.t('roleCoach') : Tr.t('roleAthlete');

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AvatarImage(url: profile?.avatar, size: 88, name: name),
            PositionedDirectional(
              bottom: 0,
              end: 0,
              child: Material(
                color: AppColors.primaryBlue,
                shape: CircleBorder(
                  side: BorderSide(color: palette.background, width: 2.5.w),
                ),
                child: InkWell(
                  onTap: () => _openEdit(context),
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 14.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          display,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title.copyWith(color: palette.textPrimary),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBadge(
              label: roleLabel,
              color: AppColors.primaryBlue,
            ),
            if (!isCoach && (profile?.phone ?? '').isNotEmpty) ...[
              SizedBox(width: AppSpacing.sm.w),
              AppBadge(
                label: profile!.phone,
                color: palette.textSecondary,
                icon: Icons.phone_rounded,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ProfileMenuList extends StatelessWidget {
  final bool isCoach;

  const ProfileMenuList({super.key, required this.isCoach});

  @override
  Widget build(BuildContext context) {
    final role = isCoach ? AppConstants.roleCoach : AppConstants.roleAthlete;

    Future<void> openEdit(BuildContext context) async {
      final result = await context.push('/profile-edit', extra: role);
      if (!context.mounted) return;
      if (result is Profile) {
        context.read<ProfileBloc>().add(const LoadProfile());
      }
    }

    return Column(
      children: [
        AppGroup(
          children: [
            AppMenuRow(
              title: Tr.t('menuPersonal'),
              icon: Icons.person_outline_rounded,
              onTap: () => openEdit(context),
            ),
            AppMenuRow(
              title: Tr.t('menuNotifications'),
              icon: Icons.notifications_none_rounded,
              onTap: () => context.push('/notification-settings'),
            ),
            AppMenuRow(
              title: Tr.t('menuSecurity'),
              icon: Icons.lock_outline_rounded,
              onTap: () => context.push('/security-settings'),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        AppGroup(
          children: [
            AppMenuRow(
              title: Tr.t('menuReports'),
              icon: Icons.insights_rounded,
              onTap: () => context.push('/reports', extra: role),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        AppGroup(
          children: [
            const ProfileThemeToggleItem(),
            AppMenuRow(
              title: Tr.t('menuLanguage'),
              icon: Icons.language_rounded,
              onTap: () => context.push('/language'),
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileThemeToggleItem extends StatelessWidget {
  const ProfileThemeToggleItem({super.key});

  @override
  Widget build(BuildContext context) {
    // `ThemeController` singleton bo'lgani uchun unga to'g'ridan-to'g'ri
    // bog'lanish shart: aks holda switch va yozuv darhol yangilanmaydi.
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final isDark = ThemeController.instance.isDark;
        return AppMenuRow(
          icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          title: isDark ? Tr.t('themeDark') : Tr.t('themeLight'),
          trailing: Switch(
            value: isDark,
            onChanged: (v) => ThemeController.instance.setDark(v),
            activeThumbColor: AppColors.primaryBlue,
          ),
        );
      },
    );
  }
}

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGroup(
      children: [
        AppMenuRow(
          icon: Icons.logout_rounded,
          title: Tr.t('logout'),
          danger: true,
          onTap: () => showDialog(
            context: context,
            builder: (_) => const ProfileLogoutDialog(),
          ),
        ),
      ],
    );
  }
}

class ProfileLogoutDialog extends StatelessWidget {
  const ProfileLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AlertDialog(
      title: Text(Tr.t('logoutConfirmTitle')),
      content: Text(Tr.t('logoutConfirmText')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Tr.t('cancel')),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AuthBloc>().add(LogoutRequested());
          },
          child: Text(
            Tr.t('exit'),
            style: TextStyle(color: palette.error, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
