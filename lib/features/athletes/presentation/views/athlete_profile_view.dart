import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../viewmodels/athlete_bloc.dart';

/// Sportchi profili (Swagger: `GET /athletes/{id}/`).
class AthleteProfileView extends StatelessWidget {
  final Athlete? athlete;

  const AthleteProfileView({super.key, this.athlete});

  @override
  Widget build(BuildContext context) {
    final initial = athlete;

    return BlocProvider(
      create: (_) {
        final bloc = getIt<AthleteBloc>();
        if (initial != null && initial.id > 0) {
          bloc.add(LoadAthleteById(initial.id));
        }
        return bloc;
      },
      child: _AthleteProfileContent(initial: initial),
    );
  }
}

class _AthleteProfileContent extends StatelessWidget {
  final Athlete? initial;

  const _AthleteProfileContent({this.initial});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AthleteBloc, AthleteState>(
      builder: (context, state) {
        final isLoading =
            state is AthleteLoading && (initial == null || initial!.id == 0);
        final athlete =
            state is AthleteLoaded ? state.athlete : (initial ?? const Athlete());

        return Scaffold(
          backgroundColor: context.palette.background,
          appBar: KarateAppBar(
            title: athlete.fullName.isEmpty ? 'Sportchi' : athlete.fullName,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenH.w,
              AppSpacing.screenTop.h,
              AppSpacing.screenH.w,
              AppSpacing.screenBottom.h,
            ),
            child: isLoading
                ? const _ProfileSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(athlete: athlete),
                      SizedBox(height: AppSpacing.sectionGap.h),
                      const AppSectionHeader(title: 'Shaxsiy ma\'lumotlar'),
                      SizedBox(height: AppSpacing.md.h),
                      _InfoCard(
                        rows: [
                          InfoRow(label: 'Ism', value: athlete.firstName),
                          InfoRow(label: 'Familiya', value: athlete.lastName),
                          InfoRow(
                            label: 'Tug\'ilgan sana',
                            value: athlete.birthDate ?? '—',
                          ),
                          InfoRow(
                            label: 'Telefon',
                            value:
                                (athlete.phone == null || athlete.phone!.isEmpty)
                                    ? '—'
                                    : athlete.phone!,
                          ),
                          InfoRow(
                            label: 'Yosh',
                            value: athlete.age > 0 ? '${athlete.age} yosh' : '—',
                          ),
                          InfoRow(label: 'Username', value: athlete.username),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerProfileAvatar(),
        SizedBox(height: AppSpacing.sectionGap.h),
        const ShimmerCard(height: 220),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Athlete athlete;

  const _ProfileHeader({required this.athlete});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final display = athlete.fullName.isEmpty ? 'Sportchi' : athlete.fullName;

    return Column(
      children: [
        AvatarImage(url: athlete.avatar, name: athlete.fullName, size: 88),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          display,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title.copyWith(color: palette.textPrimary),
        ),
        if (athlete.username.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm.h),
          AppBadge(
            label: '@${athlete.username}',
            color: AppColors.primaryBlue,
            icon: Icons.alternate_email_rounded,
          ),
        ],
      ],
    );
  }
}

/// Guruhli ma'lumot kartasi — qatorlar ingichka ajratgich bilan.
class _InfoCard extends StatelessWidget {
  final List<InfoRow> rows;

  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const AppTileDivider(),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: palette.textSecondary),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
