import 'package:flutter/material.dart';
import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../widgets/exercise_video_player.dart';

/// Mashq tafsilotlari sahifasi (Swagger: `Exercise` — `GET /exercises/{id}/`).
class ExerciseDetailView extends StatelessWidget {
  final Exercise? exercise;

  const ExerciseDetailView({super.key, this.exercise});

  @override
  Widget build(BuildContext context) {
    final ex = exercise ?? const Exercise(title: 'Mashq topilmadi');

    return Scaffold(
      backgroundColor: context.palette.background,
      body: CustomScrollView(
        slivers: [
          ExerciseDetailAppBar(exercise: ex),
          SliverToBoxAdapter(
            child: ExerciseDetailContent(exercise: ex),
          ),
        ],
      ),
    );
  }
}

class ExerciseDetailAppBar extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailAppBar({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (exercise.hasImage)
              RemoteImage(
                url: exercise.image,
                borderRadius: BorderRadius.zero,
                fallbackIcon: Icons.sports_martial_arts,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, Color(0xFF003DA5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.sports_martial_arts_rounded,
                    size: 110,
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exercise.category.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        exercise.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  Text(
                    exercise.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      shadows: [
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

class ExerciseDetailContent extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailContent({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExerciseStatsRow(duration: exercise.duration),
          if (exercise.hasVideo) ...[
            const SizedBox(height: 24),
            const ExerciseSectionTitle(
              title: 'Video dars',
              icon: Icons.play_circle_fill_rounded,
            ),
            const SizedBox(height: 12),
            ExerciseVideoPlayer(url: exercise.videoUrl!),
          ],
          const SizedBox(height: 24),
          const ExerciseSectionTitle(
            title: 'Tavsif',
            icon: Icons.subject_rounded,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.border),
            ),
            child: Text(
              exercise.description.isEmpty
                  ? 'Tavsif kiritilmagan'
                  : exercise.description,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseStatsRow extends StatelessWidget {
  final int duration;

  const ExerciseStatsRow({
    super.key,
    required this.duration,
  });

  String get _durationLabel => duration >= 60
      ? '${duration ~/ 60} daqiqa ${(duration % 60).toString().padLeft(2, '0')} soniya'
      : '$duration soniya';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ExerciseStatCard(
            label: 'Davomiyligi',
            value: _durationLabel,
            icon: Icons.timer_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ExerciseStatCard(
            label: 'Yo\'nalish',
            value: duration >= 480 ? 'Kata / kompleks' : 'Texnika',
            icon: Icons.track_changes_rounded,
          ),
        ),
      ],
    );
  }
}

class ExerciseStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ExerciseStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: palette.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ExerciseSectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  const ExerciseSectionTitle({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }
}

class ExerciseTagsRow extends StatelessWidget {
  final List<String> tags;
  const ExerciseTagsRow({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: tags.map((t) => ExerciseTag(label: t)).toList(),
    );
  }
}

class ExerciseTag extends StatelessWidget {
  final String label;
  const ExerciseTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
