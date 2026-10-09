import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/models/profile_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/theme_controller.dart';
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

            final role = profile != null && profile.role.isNotEmpty
                ? profile.role.toLowerCase()
                : (widget.userRole ?? AppConstants.roleAthlete);
            final isCoach = role == AppConstants.roleCoach;

            return Scaffold(
              backgroundColor: context.palette.background,
              appBar: AppBar(
                backgroundColor: context.palette.background,
                title: Text(Tr.t('profile'),
                    style: TextStyle(color: context.palette.textPrimary)),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      if (state is ProfileLoading && profile == null)
                        const ShimmerProfileAvatar()
                      else
                        ProfileAvatarSection(isCoach: isCoach, profile: profile),
                      if (state is ProfileLoading && profile == null)
                        const SizedBox(height: 24.0)
                      else
                        const SizedBox(height: 24.0),
                      if (state is ProfileLoading && profile == null)
                        const ShimmerListTile(hasLeading: true, lines: 1)
                      else
                        ProfileMenuList(isCoach: isCoach),
                      const SizedBox(height: 32.0),
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
    return Column(
      children: [
        ProfileAvatar(isCoach: isCoach, profile: profile),
        const SizedBox(height: 14),
        ProfileName(isCoach: isCoach, name: profile?.fullName ?? ''),
        if (profile != null && profile!.username.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            profile!.username,
            style: TextStyle(
              color: context.palette.textSecondary,
              fontSize: 13,
            ),
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
    return Stack(
      children: [
        AvatarImage(
          url: profile?.avatar,
          size: 104,
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
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
              child: const Icon(Icons.edit, color: Colors.white, size: 14),
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
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
        fontSize: 22,
        color: context.palette.textPrimary,
      ),
    );
  }
}

class ProfileMenuList extends StatelessWidget {
  final bool isCoach;

  const ProfileMenuList({super.key, required this.isCoach});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            title: Tr.t('menuPersonal'),
            icon: Icons.person_outline,
            onTap: () async {
              final result = await context.push(
                '/profile-edit',
                extra: isCoach ? AppConstants.roleCoach : AppConstants.roleAthlete,
              );
              if (!context.mounted) return;
              if (result is Profile) {
                context.read<ProfileBloc>().add(const LoadProfile());
              }
            },
          ),
          const ProfileMenuDivider(),
          ProfileMenuItem(
            title: Tr.t('menuNotifications'),
            icon: Icons.notifications_none,
            onTap: () => context.push('/notification-settings'),
          ),
          const ProfileMenuDivider(),
          ProfileMenuItem(
            title: Tr.t('menuSecurity'),
            icon: Icons.lock_outline,
            onTap: () => context.push('/security-settings'),
          ),
          const ProfileMenuDivider(),
          ProfileMenuItem(
            title: Tr.t('menuReports'),
            icon: Icons.bar_chart,
            onTap: () => context.push(
              '/reports',
              extra: isCoach ? AppConstants.roleCoach : AppConstants.roleAthlete,
            ),
          ),
          const ProfileMenuDivider(),
          const ProfileThemeToggleItem(),
          const ProfileMenuDivider(),
          ProfileMenuItem(
            title: Tr.t('menuLanguage'),
            icon: Icons.language,
            onTap: () => context.push('/language'),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: palette.backgroundLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: palette.textPrimary,
          height: 1.35,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: palette.textHint),
      onTap: onTap,
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
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: palette.backgroundLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          title: Text(
            isDark ? Tr.t('themeDark') : Tr.t('themeLight'),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: palette.textPrimary,
            ),
          ),
          trailing: Switch(
            value: isDark,
            onChanged: (v) => ThemeController.instance.setDark(v),
            activeTrackColor: AppColors.primaryBlue,
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
      indent: 56,
      endIndent: 16,
      color: context.palette.divider,
    );
  }
}

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showDialog(context: context, builder: (_) => const ProfileLogoutDialog());
      },
      icon: const Icon(Icons.logout, color: AppColors.error),
      label: Text(Tr.t('logout'), style: const TextStyle(color: AppColors.error)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.error),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
