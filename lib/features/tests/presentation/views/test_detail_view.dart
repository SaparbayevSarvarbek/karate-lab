import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';

/// Atletga biriktirilgan test tafsilotlari
/// (Swagger: `POST /my-tests/{id}/start/`, `POST /my-tests/{id}/finish/`).
class TestDetailView extends StatefulWidget {
  final TestAssignment? assignment;

  const TestDetailView({super.key, this.assignment});

  @override
  State<TestDetailView> createState() => _TestDetailViewState();
}

class _TestDetailViewState extends State<TestDetailView> {
  late TestAssignment? _assignment = widget.assignment;
  bool _busy = false;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}'
        '.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _startTest() async {
    final assignment = _assignment;
    if (assignment == null || _busy) return;
    setState(() => _busy = true);
    final result = await getIt<TestRepository>().startTest(assignment.id);
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (error) => _showError(error.message),
      (updated) => setState(() => _assignment = updated),
    );
  }

  Future<void> _finishTest(double score, String notes) async {
    final assignment = _assignment;
    if (assignment == null || _busy) return;
    setState(() => _busy = true);
    final result = await getIt<TestRepository>().finishTest(
      assignment.id,
      FinishTestRequest(score: score, notes: notes),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (error) => _showError(error.message),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test yakunlandi! Ball: ${score.toStringAsFixed(1)}'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final test = _assignment;

    if (test == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test tafsilotlari')),
        body: const Center(child: Text('Test topilmadi')),
      );
    }

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: const Text('Test tafsilotlari'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            children: [
              _TestHero(test: test),
              SizedBox(height: 16.h),
              _StatusRow(test: test, formatDate: _formatDate),
              SizedBox(height: 20.h),
              _SectionTitle(title: 'Mashqlar (${test.exercises.length})'),
              SizedBox(height: 12.h),
              if (test.exercises.isEmpty)
                Text(
                  'Mashqlar biriktirilmagan',
                  style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
                )
              else
                for (final e in test.exercises)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _ExerciseRow(exercise: e),
                  ),
              if (test.notes.isNotEmpty) ...[
                SizedBox(height: 18.h),
                _SectionTitle(title: 'Murabbiy izohi'),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    test.notes,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 13.sp,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              _buildActionButton(test),
            ],
          ),
          if (_busy)
            Container(
              color: Colors.black.withValues(alpha: 0.18),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(TestAssignment test) {
    switch (test.status) {
      case TestStatus.pending:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _busy ? null : _startTest,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.h),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text('Testni boshlash', style: TextStyle(fontSize: 14.sp)),
          ),
        );
      case TestStatus.inProgress:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _busy ? null : () => _showFinishDialog(context),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              backgroundColor: AppColors.success,
            ),
            icon: const Icon(Icons.flag_rounded),
            label: Text('Testni yakunlash', style: TextStyle(fontSize: 14.sp)),
          ),
        );
      case TestStatus.completed:
      case TestStatus.unknown:
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  test.score == null
                      ? 'Test yakunlangan'
                      : 'Test yakunlangan. Ball: ${test.score!.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  void _showFinishDialog(BuildContext context) {
    final scoreController = TextEditingController();
    final notesController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text('Testni yakunlash', style: TextStyle(fontSize: 17.sp)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: scoreController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 14.sp),
                decoration: const InputDecoration(
                  labelText: 'Ball (0 - 100)',
                  prefixIcon: Icon(Icons.stars_rounded),
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: notesController,
                maxLines: 3,
                style: TextStyle(fontSize: 14.sp),
                decoration: const InputDecoration(
                  labelText: 'Izohlar (ixtiyoriy)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Bekor qilish'),
            ),
            FilledButton(
              onPressed: () {
                final score = double.tryParse(scoreController.text.trim());
                if (score == null || score < 0 || score > 100) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: const Text('Ballni 0 dan 100 gacha kiriting'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop();
                _finishTest(score, notesController.text.trim());
              },
              child: const Text('Yakunlash'),
            ),
          ],
        );
      },
    );
  }
}

class _TestHero extends StatelessWidget {
  final TestAssignment test;

  const _TestHero({required this.test});

  @override
  Widget build(BuildContext context) {
    final imageExercise = test.exercises.where((e) => e.hasImage);
    final cover = imageExercise.isEmpty ? null : imageExercise.first.image;
    return Container(
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (cover != null)
            RemoteImage(url: cover, borderRadius: BorderRadius.zero)
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryNavy, Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.7),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${test.exercises.length} mashq • ${_totalDuration(test)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  test.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _totalDuration(TestAssignment test) {
    final total = test.exercises.fold<int>(0, (sum, e) => sum + e.duration);
    if (total >= 60) return '${total ~/ 60} daqiqa';
    return '$total soniya';
  }
}

class _StatusRow extends StatelessWidget {
  final TestAssignment test;
  final String Function(DateTime?) formatDate;

  const _StatusRow({required this.test, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (test.status) {
      TestStatus.completed => AppColors.success,
      TestStatus.inProgress => AppColors.warning,
      TestStatus.pending => AppColors.info,
      TestStatus.unknown => AppColors.textHint,
    };
    return Row(
      children: [
        _InfoCard(
          label: 'Holat',
          value: test.status.label,
          icon: Icons.flag_rounded,
          color: statusColor,
        ),
        SizedBox(width: 10.w),
        _InfoCard(
          label: 'Ball',
          value: test.score == null ? '—' : test.score!.toStringAsFixed(1),
          icon: Icons.stars_rounded,
          color: AppColors.warning,
        ),
        SizedBox(width: 10.w),
        _InfoCard(
          label: 'Boshlangan',
          value: formatDate(test.startedAt),
          icon: Icons.calendar_today_rounded,
          color: AppColors.primaryBlue,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16.w),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(color: palette.textSecondary, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseRow({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/exercise-detail', extra: exercise),
            child: RemoteImage(
              url: exercise.image,
              width: 56.w,
              height: 56.w,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/exercise-detail', extra: exercise),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5.sp,
                      color: palette.textPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 13.w, color: palette.textHint),
                      SizedBox(width: 4.w),
                      Text(
                        exercise.durationLabel,
                        style: TextStyle(
                            color: palette.textSecondary, fontSize: 11.5.sp),
                      ),
                      if (exercise.hasVideo) ...[
                        SizedBox(width: 10.w),
                        Icon(Icons.play_circle_fill_rounded,
                            size: 13.w, color: AppColors.primaryBlue),
                        SizedBox(width: 3.w),
                        Text(
                          'video',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20.w, color: palette.textHint),
        ],
      ),
    );
  }
}
