import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_translations.dart';
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
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../widgets/exercise_video_player.dart';

class ExerciseDetailArgs {
  final Exercise exercise;
  final bool canEdit;

  const ExerciseDetailArgs({required this.exercise, this.canEdit = false});
}

/// Mashq tafsilotlari sahifasi (Swagger: `Exercise` — `GET /exercises/{id}/`).
///
/// Ko'rinishi UJT/MJT test detali bilan bir xil: hero media kartasi va
/// chiplar, bo'limlar hamda bosqich kartalari.
class ExerciseDetailView extends StatefulWidget {
  final Exercise? exercise;
  final bool canEdit;

  const ExerciseDetailView({super.key, this.exercise, this.canEdit = false});

  @override
  State<ExerciseDetailView> createState() => _ExerciseDetailViewState();
}

class _ExerciseDetailViewState extends State<ExerciseDetailView> {
  bool _isLoading = true;
  late Exercise? _exercise = widget.exercise;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  Future<void> _editExercise() async {
    final exercise = _exercise;
    if (exercise == null) return;
    final updated = await context.push<Exercise>(
      '/add-exercise',
      extra: exercise,
    );
    if (updated != null && mounted) {
      setState(() => _exercise = updated);
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final ex = _exercise ?? const Exercise();

    return Scaffold(
      backgroundColor: palette.background,
      appBar: KarateAppBar(
        title: ex.title.isEmpty ? Tr.t('exerciseNotFound') : ex.title,
        actions: widget.canEdit && _exercise != null
            ? [
                IconButton(
                  tooltip: Tr.t('edit'),
                  onPressed: _editExercise,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ]
            : null,
      ),
      body: ex.title.isEmpty
          ? AppEmptyView(
              icon: Icons.fitness_center_outlined,
              title: Tr.t('exerciseNotFound'),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenH.w,
                AppSpacing.screenTop.h,
                AppSpacing.screenH.w,
                AppSpacing.screenBottom.h,
              ),
              children: [
                if (_isLoading)
                  const ShimmerExerciseDetail()
                else
                  _Content(exercise: ex),
              ],
            ),
    );
  }
}

/// Mashq kategoriyasiga mos rang: MJT → warning, UJT → success, aks holda brand.
Color _accentOf(BuildContext context, String category) {
  final palette = context.palette;
  switch (category.toUpperCase()) {
    case 'MJT':
      return palette.warning;
    case 'UJT':
      return palette.success;
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
    final accent = _accentOf(context, exercise.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCard(exercise: exercise),
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
                AppBadge(
                  label: Tr.categoryName(exercise.category),
                  color: accent,
                  icon: Icons.sports_martial_arts_rounded,
                ),
              if (exercise.age.isNotEmpty)
                AppBadge(
                  label: exercise.age,
                  color: AppColors.primaryBlue,
                  icon: Icons.cake_outlined,
                ),
              if (exercise.duration > 0)
                AppBadge(
                  label: exercise.durationLabel,
                  color: AppColors.primaryBlue,
                  icon: Icons.timer_outlined,
                ),
            ],
          ),
        ],
        if (exercise.description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('description')),
          SizedBox(height: AppSpacing.md.h),
          _TextCard(text: exercise.description),
        ],
        if (exercise.goal.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('goal')),
          SizedBox(height: AppSpacing.md.h),
          _TextCard(text: exercise.goal),
        ],
        if (exercise.qualities.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('developedQualities')),
          SizedBox(height: AppSpacing.md.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              for (final q in exercise.qualities)
                AppBadge(label: q, color: AppColors.primaryBlue, filled: false),
            ],
          ),
        ],
        SizedBox(height: AppSpacing.sectionGap.h),
        AppSectionHeader(title: Tr.t('stepsTitle')),
        SizedBox(height: AppSpacing.md.h),
        if (exercise.steps.isEmpty)
          AppEmptyView(
            icon: Icons.list_alt_rounded,
            title: Tr.t('noStepsAdded'),
            compact: true,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: exercise.steps.length,
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md.h),
              child: _StepCard(
                step: exercise.steps[i],
                index: i + 1,
                accent: accent,
              ),
            ),
          ),
      ],
    );
  }
}

/// Kartaga o'ralgan izoh matni (sahifa fonida yolg'iz qolmasligi uchun).
class _TextCard extends StatelessWidget {
  final String text;

  const _TextCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: context.palette.textSecondary,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}

/// Hero media kartasi — 16:9 nisbatda video, rasm yoki gradient.
class _HeroCard extends StatelessWidget {
  final Exercise exercise;

  const _HeroCard({required this.exercise});

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
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
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

/// Bosqich kartasi — raqamli belgi, nom va tafsilotlar.
class _StepCard extends StatelessWidget {
  final ExerciseStep step;
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
                child: step.title.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        step.title,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: palette.textPrimary,
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
                height: 1.5,
              ),
            ),
          ],
          if (step.hasImage) ...[
            SizedBox(height: AppSpacing.sm.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.tile.r),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: RemoteImage(
                  url: ApiConstants.resolveMediaUrl(step.imageUrl!),
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.zero,
                ),
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
                    label: Tr.t('repetitions'),
                    value: step.repetitions,
                  ),
                if (step.rest.isNotEmpty)
                  _StepMeta(
                    icon: Icons.timer_outlined,
                    label: Tr.t('rest'),
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
      child: Text('$index', style: AppTextStyles.badge.copyWith(color: accent)),
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: 6.h),
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
