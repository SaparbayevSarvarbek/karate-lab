import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../widgets/exercise_video_player.dart';

/// Mashq tafsilotlari sahifasi (Swagger: `Exercise` — `GET /exercises/{id}/`).
///
/// Ko'rinishi UJT/MJT test detali bilan bir xil: hero rasm va chiplar,
/// bo'limlar hamda bosqich kartalari.
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
    final ex = widget.exercise ?? const Exercise(title: 'Mashq topilmadi');

    return Scaffold(
      backgroundColor: context.palette.background,
      body: _isLoading
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 230.h,
                  pinned: true,
                  backgroundColor: AppColors.primaryNavy,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ShimmerPlaceholder(
                      width: double.infinity,
                      height: 230.h,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 32.h),
                    child: ShimmerExerciseDetail(),
                  ),
                ),
              ],
            )
          : CustomScrollView(
              slivers: [
                _AppBar(exercise: ex),
                SliverToBoxAdapter(child: _Content(exercise: ex)),
              ],
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

class _AppBar extends StatelessWidget {
  final Exercise exercise;

  const _AppBar({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final accent = _accentOf(exercise.category);
    return SliverAppBar(
      expandedHeight: 230.h,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryNavy,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (exercise.hasImage)
              RemoteImage(
                url: ApiConstants.resolveMediaUrl(exercise.image!),
                borderRadius: BorderRadius.zero,
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, accent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.68),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 18.w,
              right: 18.w,
              bottom: 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (exercise.category.isNotEmpty) ...[
                        _HeroChip(label: exercise.category, color: accent),
                        SizedBox(width: 8.w),
                      ],
                      if (exercise.duration > 0)
                        _HeroChip(
                          label: exercise.durationLabel,
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    exercise.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;
  final Color color;

  const _HeroChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Exercise exercise;

  const _Content({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = _accentOf(exercise.category);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exercise.description.isNotEmpty) ...[
            _SectionTitle(
              title: 'Tavsif',
              icon: Icons.subject_rounded,
              color: accent,
            ),
            SizedBox(height: 10.h),
            Text(
              exercise.description,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13.sp,
                height: 1.55,
              ),
            ),
          ],
          if (exercise.hasVideo) ...[
            SizedBox(height: 22.h),
            _SectionTitle(
              title: 'Video dars',
              icon: Icons.play_circle_fill_rounded,
              color: accent,
            ),
            SizedBox(height: 12.h),
            ExerciseVideoPlayer(url: exercise.videoUrl!),
          ],
          SizedBox(height: 22.h),
          _SectionTitle(
            title: 'Bosqichlar (${exercise.steps.length})',
            icon: Icons.list_alt_rounded,
            color: accent,
          ),
          SizedBox(height: 12.h),
          if (exercise.steps.isEmpty)
            Text(
              'Bosqichlar kiritilmagan',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13.sp,
              ),
            )
          else
            for (int i = 0; i < exercise.steps.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _StepCard(
                  step: exercise.steps[i],
                  index: i + 1,
                  color: accent,
                ),
              ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19.w, color: color),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: context.palette.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Bosqich kartasi — UJT/MJT detalidagi `_StepCard` bilan bir xil ko'rinish.
class _StepCard extends StatelessWidget {
  final ExerciseStep step;
  final int index;
  final Color color;

  const _StepCard({
    required this.step,
    required this.index,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
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
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.72)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: step.title.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        step.title,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),
          if (step.description.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              step.description,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12.5.sp,
                height: 1.55,
              ),
            ),
          ],
          if (step.hasImage) ...[
            SizedBox(height: 10.h),
            RemoteImage(
              url: ApiConstants.resolveMediaUrl(step.imageUrl!),
              width: double.infinity,
              fit: BoxFit.fitWidth,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
          if (step.repetitions.isNotEmpty || step.rest.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 14.w,
              runSpacing: 6.h,
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
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: AppColors.primaryBlue),
          SizedBox(width: 5.w),
          Text(
            '$label: ',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 11.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
