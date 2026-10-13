import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/mjt_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/ujt_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Bitta MJT testi: maqsad, sifatlar va 5 ta step (rasm, takrorlash, dam olish, maqsad).
class MjtTestDetailView extends StatefulWidget {
  final int testId;

  const MjtTestDetailView({super.key, required this.testId});

  @override
  State<MjtTestDetailView> createState() => _MjtTestDetailViewState();
}

class _MjtTestDetailViewState extends State<MjtTestDetailView> {
  late Future<MjtTest?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<MjtTest?> _load() async {
    final result = await getIt<UjtRepository>().getMjtTestById(widget.testId);
    return result.fold(
      (error) {
        if (mounted) {
          AppSnackbar.error(context, error.message);
        }
        return null;
      },
      (test) => test,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MjtTest?>(
      future: _future,
      builder: (context, snapshot) {
        final test = snapshot.data;
        final loading = snapshot.connectionState != ConnectionState.done;
        return Scaffold(
          backgroundColor: context.palette.background,
          appBar: KarateAppBar(
            title: (test?.title.isNotEmpty ?? false) ? test!.title : 'MJT testi',
          ),
          body: loading
              ? const AppLoadingView()
              : test == null
                  ? const AppEmptyView(
                      icon: Icons.search_off_rounded,
                      title: 'Test topilmadi',
                    )
                  : _Content(test: test),
        );
      },
    );
  }
}

/// Hero blok — 16:9 media (rasm yoki navy→blue gradient + watermark).
class _HeroMedia extends StatelessWidget {
  final MjtTest test;

  const _HeroMedia({required this.test});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel.r),
        border: Border.all(color: palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: test.hasCover
            ? RemoteImage(
                url: ApiConstants.resolveMediaUrl(test.coverUrl!),
                borderRadius: BorderRadius.zero,
                fit: BoxFit.cover,
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, AppColors.gradientDeepBlue],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Icon(
                        Icons.sports_martial_arts_rounded,
                        size: 96.w,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    PositionedDirectional(
                      start: 16.w,
                      end: 16.w,
                      bottom: 12.h,
                      child: Text(
                        'MJT testi',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
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

class _Content extends StatelessWidget {
  final MjtTest test;

  const _Content({required this.test});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = palette.warning;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.screenTop.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      ),
      children: [
        _HeroMedia(test: test),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          test.title,
          style: AppTextStyles.screenTitle.copyWith(color: palette.textPrimary),
        ),
        SizedBox(height: AppSpacing.md.h),
        Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: [
            AppBadge(
              label: 'MJT',
              color: accent,
              icon: Icons.fitness_center_rounded,
            ),
            if (test.ageGroup.isNotEmpty)
              AppBadge(
                label: test.ageGroup,
                color: AppColors.primaryBlue,
                icon: Icons.cake_outlined,
              ),
          ],
        ),
        if (test.goal.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionGap.h),
          const AppSectionHeader(title: 'Maqsad'),
          SizedBox(height: AppSpacing.md.h),
          _TextCard(text: test.goal),
        ],
        if (test.qualities.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionGap.h),
          const AppSectionHeader(title: 'Rivojlanadigan sifatlar'),
          SizedBox(height: AppSpacing.md.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              for (final q in test.qualities)
                AppBadge(label: q, color: AppColors.primaryBlue, filled: false),
            ],
          ),
        ],
        SizedBox(height: AppSpacing.sectionGap.h),
        AppSectionHeader(title: 'Mashqlar (${test.steps.length})'),
        SizedBox(height: AppSpacing.md.h),
        if (test.steps.isEmpty)
          const AppEmptyView(
            icon: Icons.list_alt_rounded,
            title: 'Mashqlar kiritilmagan',
            compact: true,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: test.steps.length,
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md.h),
              child: _StepCard(
                step: test.steps[i],
                index: i + 1,
                accent: accent,
              ),
            ),
          ),
      ],
    );
  }
}

/// Kartaga o'ralgan izoh matni.
class _TextCard extends StatelessWidget {
  final String text;

  const _TextCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          color: context.palette.textSecondary,
          height: 1.55,
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final MjtStep step;
  final int index;
  final Color accent;

  const _StepCard({
    required this.step,
    required this.index,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StepBadge(index: index, accent: accent),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Text(
                  step.title,
                  style: AppTextStyles.cardTitle
                      .copyWith(color: palette.textPrimary),
                ),
              ),
            ],
          ),
          if (step.description.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Text(
              step.description,
              style: AppTextStyles.caption.copyWith(
                color: palette.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          if (step.goal.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 14.w,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: Text(
                    step.goal,
                    style: AppTextStyles.caption.copyWith(
                      color: palette.textPrimary,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (step.images.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            for (final img in step.images)
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
                child: RemoteImage(
                  url: ApiConstants.resolveMediaUrl(img),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  borderRadius: BorderRadius.circular(AppRadius.tile.r),
                ),
              ),
          ],
          if (step.repetitions.isNotEmpty || step.rest.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Wrap(
              spacing: AppSpacing.sm.w,
              runSpacing: AppSpacing.sm.h,
              children: [
                if (step.repetitions.isNotEmpty)
                  _StepMeta(
                    icon: Icons.repeat_rounded,
                    label: 'Takrorlash',
                    value: step.repetitions,
                  ),
                if (step.rest.isNotEmpty)
                  _StepMeta(
                    icon: Icons.timer_outlined,
                    label: 'Dam olish',
                    value: step.rest,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Bosqich tartib raqami plitasi.
class _StepBadge extends StatelessWidget {
  final int index;
  final Color accent;

  const _StepBadge({required this.index, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.tile.r),
      ),
      child: Text(
        '$index',
        style: AppTextStyles.badge.copyWith(color: accent),
      ),
    );
  }
}

class _StepMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StepMeta({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: palette.backgroundLight,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: AppColors.primaryBlue),
          SizedBox(width: 4.w),
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
