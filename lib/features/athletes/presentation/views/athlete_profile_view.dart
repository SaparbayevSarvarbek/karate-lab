import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/app_section_header.dart';
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
        final isLoading = state is AthleteLoading && (initial == null || initial!.id == 0);
        final athlete =
            state is AthleteLoaded ? state.athlete : (initial ?? const Athlete());

        return Scaffold(
          backgroundColor: context.palette.background,
          appBar: KarateAppBar(
            title: athlete.fullName.isEmpty ? 'Sportchi' : athlete.fullName,
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading) ...[
                        ShimmerPlaceholder(width: 180.w, height: 28.h, borderRadius: BorderRadius.circular(14.r)),
                        SizedBox(height: 8.h),
                        ShimmerPlaceholder(width: 100.w, height: 16.h, borderRadius: BorderRadius.circular(8.r)),
                        SizedBox(height: 24.h),
                        ...List.generate(6, (index) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ShimmerListTile(hasLeading: false, lines: 1),
                        )),
                      ] else ...[
                        _ProfileHeader(athlete: athlete),
                        SizedBox(height: 24.h),
                        _InfoCard(
                          title: 'Shaxsiy ma\'lumotlar',
                          rows: [
                            InfoRow(label: 'Ism', value: athlete.firstName),
                            InfoRow(label: 'Familiya', value: athlete.lastName),
                            InfoRow(
                              label: 'Tug\'ilgan sana',
                              value: athlete.birthDate ?? '—',
                            ),
                            InfoRow(
                              label: 'Telefon',
                              value: (athlete.phone == null || athlete.phone!.isEmpty)
                                  ? '—'
                                  : athlete.phone!,
                            ),
                            InfoRow(
                              label: 'Yosh',
                              value:
                                  athlete.age > 0 ? '${athlete.age} yosh' : '—',
                            ),
                            InfoRow(label: 'Username', value: athlete.username),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Athlete athlete;

  const _ProfileHeader({required this.athlete});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        AvatarImage(
          url: athlete.avatar,
          name: athlete.fullName,
          size: 64,
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                athlete.fullName.isEmpty ? 'Sportchi' : athlete.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.screenTitle.copyWith(color: palette.textPrimary),
              ),
              SizedBox(height: 4.h),
              Text(
                '@${athlete.username}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<InfoRow> rows;

  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: title),
          SizedBox(height: 16.h),
          ...rows,
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.body.copyWith(color: palette.textSecondary)),
          SizedBox(width: 12.w),
          Flexible(
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
