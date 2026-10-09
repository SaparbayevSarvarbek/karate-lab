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
            onPressed: _busy ? null : () => _openRun(test),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              backgroundColor: AppColors.warning,
            ),
            icon: const Icon(Icons.timer_rounded),
            label: Text('Davom etish', style: TextStyle(fontSize: 14.sp)),
          ),
        );
      case TestStatus.completed:
      case TestStatus.unknown:
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/test-result', extra: test),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  backgroundColor: AppColors.success,
                ),
                icon: const Icon(Icons.bar_chart_rounded),
                label: Text('Natijani ko\'rish', style: TextStyle(fontSize: 14.sp)),
              ),
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

class _TestHero extends StatelessWidget {
  final TestResult test;

  const _TestHero({required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
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
          Container(
            width: 32.w,
            height: 32.w,
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
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
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
                SizedBox(height: 4.h),
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