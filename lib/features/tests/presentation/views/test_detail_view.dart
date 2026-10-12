import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

/// Test tafsilotlari: umumiy rasm, maqsad/sifatlar va
/// qadamlar. Testni boshlash orqali taymerli bajarish sahifasiga o'tiladi.
class TestDetailView extends StatefulWidget {
  final TestResult? result;

  const TestDetailView({super.key, this.result});

  @override
  State<TestDetailView> createState() => _TestDetailViewState();
}

class _TestDetailViewState extends State<TestDetailView> {
  late TestResult? _result = widget.result;
  bool _busy = false;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}'
        '.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _startTest() async {
    final current = _result;
    if (current == null || _busy) return;
    setState(() => _busy = true);
    final response = await getIt<TestRepository>().startTest(current.id);
    if (!mounted) return;
    setState(() => _busy = false);
    response.fold(
      (error) => _showError(error.message),
      (updated) async {
        setState(() => _result = updated);
        await _openRun(updated);
      },
    );
  }

  Future<void> _openRun(TestResult result) async {
    final finished = await context.push<TestResult>('/test-run', extra: result);
    if (finished != null && mounted) {
      setState(() => _result = finished);
      await context.push('/test-result', extra: finished);
    }
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
    final test = _result;

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
              if (test.goal.isNotEmpty) ...[
                SizedBox(height: 20.h),
                const _SectionTitle(title: 'Maqsad', icon: Icons.flag_rounded),
                SizedBox(height: 10.h),
                Text(
                  test.goal,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13.sp,
                    height: 1.55,
                  ),
                ),
              ],
              if (test.description.isNotEmpty) ...[
                SizedBox(height: 18.h),
                const _SectionTitle(title: 'Qo\'shimcha ma\'lumot', icon: Icons.info_outline_rounded),
                SizedBox(height: 10.h),
                Text(
                  test.description,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13.sp,
                    height: 1.55,
                  ),
                ),
              ],
              if (test.qualities.isNotEmpty) ...[
                SizedBox(height: 18.h),
                const _SectionTitle(
                    title: 'Rivojlanadigan sifatlar', icon: Icons.stars_rounded),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: test.qualities
                      .map((q) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              q,
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
              SizedBox(height: 20.h),
              _SectionTitle(
                title: 'Qadamlar (${test.steps.length})',
                icon: Icons.list_alt_rounded,
              ),
              SizedBox(height: 12.h),
              if (test.steps.isEmpty)
                Text(
                  'Qadamlar qo\'shilmagan',
                  style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
                )
              else
                for (int i = 0; i < test.steps.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _StepRow(step: test.steps[i], index: i + 1),
                  ),
              if (test.notes.isNotEmpty) ...[
                SizedBox(height: 18.h),
                const _SectionTitle(
                    title: 'Murabbiy izohi', icon: Icons.comment_rounded),
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
              child: Center(
                child: ShimmerTestDetail(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(TestResult test) {
    switch (test.status) {
      case TestStatus.pending:
        return _PrimaryAction(
          label: 'Testni boshlash',
          icon: Icons.play_arrow_rounded,
          color: AppColors.primaryBlue,
          onTap: _busy ? null : _startTest,
        );
      case TestStatus.inProgress:
        return _PrimaryAction(
          label: 'Davom etish',
          icon: Icons.timer_rounded,
          color: AppColors.warning,
          onTap: _busy ? null : () => _openRun(test),
        );
      case TestStatus.completed:
      case TestStatus.unknown:
        return Column(
          children: [
            _PrimaryAction(
              label: 'Natijani ko\'rish',
              icon: Icons.bar_chart_rounded,
              color: AppColors.success,
              onTap: () => context.push('/test-result', extra: test),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 22.w),
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
            ),
          ],
        );
    }
  }
}

/// Sahifadagi asosiy amal tugmasi (bir xil o'lcham va burchak).
class _PrimaryAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _PrimaryAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        icon: Icon(icon, size: 20.w),
        label: Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _TestHero extends StatelessWidget {
  final TestResult test;

  const _TestHero({required this.test});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: context.palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (test.hasCover)
              RemoteImage(
                url: ApiConstants.resolveMediaUrl(test.coverUrl!),
                borderRadius: BorderRadius.zero,
                fit: BoxFit.cover,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.72),
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
                      if (test.category.isNotEmpty)
                        _HeroChip(label: test.category),
                      if (test.age.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        _HeroChip(label: test.age),
                      ],
                    ],
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
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;

  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final TestResult test;
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
    final startedLabel = test.finishedAt != null
        ? 'Yakunlangan'
        : test.startedAt != null
            ? 'Boshlangan'
            : 'Boshlanmagan';
    final dateValue = test.finishedAt != null
        ? formatDate(test.finishedAt)
        : test.startedAt != null
            ? formatDate(test.startedAt)
            : '—';

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
          label: startedLabel,
          value: dateValue,
          icon: test.finishedAt != null
              ? Icons.event_available_rounded
              : Icons.calendar_today_rounded,
          color: AppColors.primaryBlue,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19.w, color: AppColors.primaryBlue),
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

class _StepRow extends StatelessWidget {
  final TestStep step;
  final int index;

  const _StepRow({required this.step, required this.index});

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
          _StepThumb(step: step, index: index),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title.isEmpty ? 'Qadam $index' : step.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5.sp,
                    color: palette.textPrimary,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    if (step.repetitions.isNotEmpty) ...[
                      Icon(Icons.repeat_rounded,
                          size: 13.w, color: palette.textHint),
                      SizedBox(width: 3.w),
                      Text(step.repetitions,
                          style: TextStyle(
                              color: palette.textSecondary, fontSize: 11.5.sp)),
                      SizedBox(width: 10.w),
                    ],
                    if (step.duration > 0) ...[
                      Icon(Icons.timer_outlined,
                          size: 13.w, color: palette.textHint),
                      SizedBox(width: 3.w),
                      Text('${step.duration}s',
                          style: TextStyle(
                              color: palette.textSecondary, fontSize: 11.5.sp)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Qadam rasmi (bo'lsa) yoki raqamli doira.
class _StepThumb extends StatelessWidget {
  final TestStep step;
  final int index;

  const _StepThumb({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    if (!step.hasImage) {
      return Container(
        width: 52.w,
        height: 52.w,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, Color(0xFF2B7AFF)],
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 52.w,
      height: 52.w,
      child: Stack(
        children: [
          Positioned.fill(
            child: RemoteImage(
              url: ApiConstants.resolveMediaUrl(step.imageUrl!),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          Positioned(
            left: 4.w,
            top: 4.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '$index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}