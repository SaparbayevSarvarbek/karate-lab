import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../widgets/exercise_video_player.dart';

/// Mashq tafsilotlari sahifasi (Swagger: `Exercise` — `GET /exercises/{id}/`).
///
/// Ko'rinishi UJT/MJT test detali bilan bir xil: hero media kartasi va
/// chiplar, bo'limlar hamda bosqich kartalari.
class ExerciseDetailView extends StatefulWidget {
  final Exercise? exercise;

  const ExerciseDetailView({super.key, this.exercise});

  @override
  State<ExerciseDetailView> createState() => _ExerciseDetailViewState();
}

class _ExerciseDetailViewState extends State<ExerciseDetailView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading or use a FutureBuilder pattern
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final ex = widget.exercise ?? const Exercise(title: 'Mashq topilmadi');

    return Scaffold(
      backgroundColor: palette.background,
      appBar: KarateAppBar(title: ex.title),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenH.w,
          AppSpacing.sm.h,
          AppSpacing.screenH.w,
          AppSpacing.xxl.h,
        ),
        child: _isLoading
            ? const ShimmerExerciseDetail()
            : _Content(exercise: ex),
      ),
    );
  }
}

/// Mashq kategoriyasiga mos rang: MJT → warning, UJT → success, aks holda brand.
Color _accentOf(String category) {
  switch (category.toUpperCase()) {
    case 'MJT':
      return AppColors.warning;
    case 'UJT':
      return AppColors.success;
    default:
      return AppColors.primaryBlue;
  }
}

class _Content extends StatelessWidget {
  final Exercise exercise;

  const _Content({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _accentOf(exercise.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCard(exercise: exercise, accent: accent),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          exercise.title,
          style: AppTextStyles.screenTitle.copyWith(color: palette.textPrimary),
        ),
        if (exercise.category.isNotEmpty ||
            exercise.age.isNotEmpty ||
            exercise.duration > 0) ...[
          SizedBox(height: AppSpacing.md.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              if (exercise.category.isNotEmpty)
                _MetaChip(
                  label: exercise.category,
                  icon: Icons.sports_martial_arts_rounded,
                  color: accent,
                ),
              if (exercise.age.isNotEmpty)
                _MetaChip(
                  label: exercise.age,
                  icon: Icons.cake_outlined,
                ),
              if (exercise.duration > 0)
                _MetaChip(
                  label: exercise.durationLabel,
                  icon: Icons.timer_outlined,
                ),
            ],
          ),
        ],
        if (exercise.description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xl.h),
          const AppSectionHeader(title: 'Tavsif'),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            exercise.description,
            style: AppTextStyles.body.copyWith(color: palette.textSecondary),
          ),
        ],
        if (exercise.goal.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xl.h),
          const AppSectionHeader(title: 'Maqsad'),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            exercise.goal,
            style: AppTextStyles.body.copyWith(color: palette.textSecondary),
          ),
        ],
        if (exercise.qualities.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xl.h),
          const AppSectionHeader(title: 'Rivojlanadigan sifatlar'),
          SizedBox(height: AppSpacing.sm.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              for (final q in exercise.qualities) _MetaChip(label: q),
            ],
          ),
        ],
        SizedBox(height: AppSpacing.xl.h),
        AppSectionHeader(title: 'Bosqichlar (${exercise.steps.length})'),
        SizedBox(height: AppSpacing.md.h),
        if (exercise.steps.isEmpty)
          Text(
            'Bosqichlar kiritilmagan',
            style: AppTextStyles.body.copyWith(color: palette.textSecondary),
          )
        else
          for (int i = 0; i < exercise.steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md.h),
              child: _StepCard(
                step: exercise.steps[i],
                index: i + 1,
              ),
            ),
      ],
    );
  }
}

/// Hero media kartasi — 16:9 nisbatda video, rasm yoki gradient.
class _HeroCard extends StatelessWidget {
  final Exercise exercise;
  final Color accent;

  const _HeroCard({required this.exercise, required this.accent});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: exercise.hasVideo
            ? ExerciseVideoPlayer(url: exercise.videoUrl!)
            : exercise.hasImage
                ? RemoteImage(
                    url: ApiConstants.resolveMediaUrl(exercise.image!),
                    borderRadius: BorderRadius.zero,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryNavy, AppColors.primaryBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sports_martial_arts_rounded,
                        size: 90.w,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
      ),
    );
  }
}

/// Meta chip — pill shaklida, brend tusli fon.
class _MetaChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;

  const _MetaChip({
    required this.label,
    this.icon,
    this.color = AppColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.w, color: color),
            SizedBox(width: 5.w),
          ],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bosqich kartasi — 32px doira indeks, nom va tafsilotlar.
class _StepCard extends StatelessWidget {
  final ExerciseStep step;
  final int index;

  const _StepCard({
    required this.step,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: step.title.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        step.title,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
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
              ),
            ),
          ],
          if (step.hasImage) ...[
            SizedBox(height: AppSpacing.sm.h),
            RemoteImage(
              url: ApiConstants.resolveMediaUrl(step.imageUrl!),
              width: double.infinity,
              fit: BoxFit.fitWidth,
              borderRadius: BorderRadius.circular(AppRadius.sm.r),
            ),
          ],
          if (step.repetitions.isNotEmpty || step.rest.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm.h),
            Wrap(
              spacing: AppSpacing.md.w,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: AppColors.primaryBlue),
          SizedBox(width: 5.w),
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(
              color: palette.textSecondary,
            ),
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
