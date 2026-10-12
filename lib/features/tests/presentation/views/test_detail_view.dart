import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';
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
        backgroundColor: palette.background,
        appBar: const KarateAppBar(title: 'Test tafsilotlari'),
        body: const AppEmptyView(
          icon: Icons.search_off_rounded,
          title: 'Test topilmadi',
        ),
      );
    }

    final stepCount = test.steps.length;
    final duration = test.steps.fold<int>(0, (sum, s) => sum + s.duration);
    final scoreLabel =
        test.score == null ? '—' : test.score!.toStringAsFixed(1);
    final paragraph =
        test.description.isNotEmpty ? test.description : test.goal;
    final dateValue = test.finishedAt != null
        ? _formatDate(test.finishedAt)
        : test.startedAt != null
            ? _formatDate(test.startedAt)
            : null;
    final isFinished = test.status == TestStatus.completed ||
        test.status == TestStatus.unknown;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: const KarateAppBar(title: 'Test tafsilotlari'),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            children: [
              _TestHero(test: test),
              SizedBox(height: 18.h),
              Text(
                test.name,
                style: AppTextStyles.screenTitle
                    .copyWith(color: palette.textPrimary),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  if (test.category.isNotEmpty)
                    _InfoChip(
                      label: test.category,
                      icon: Icons.category_outlined,
                      color: AppColors.primaryBlue,
                    ),
                  if (test.age.isNotEmpty)
                    _InfoChip(
                      label: test.age,
                      icon: Icons.cake_outlined,
                      color: AppColors.primaryBlue,
                    ),
                  _InfoChip(
                    label: test.status.label,
                    icon: Icons.flag_rounded,
                    color: _statusColor(test.status),
                  ),
                  if (dateValue != null)
                    _InfoChip(
                      label: dateValue,
                      icon: Icons.calendar_today_rounded,
                      color: AppColors.primaryBlue,
                    ),
                ],
              ),
              if (paragraph.isNotEmpty) ...[
                SizedBox(height: 14.h),
                Text(
                  paragraph,
                  style: AppTextStyles.body
                      .copyWith(color: palette.textSecondary, height: 1.55),
                ),
              ],
              SizedBox(height: 22.h),
              const AppSectionHeader(title: 'Test ma\'lumotlari'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _StatCard(
                    icon: Icons.list_alt_rounded,
                    color: AppColors.primaryBlue,
                    value: '$stepCount',
                    label: 'Savollar',
                  ),
                  SizedBox(width: 10.w),
                  _StatCard(
                    icon: Icons.timer_outlined,
                    color: AppColors.info,
                    value: '${duration}s',
                    label: 'Davomiylik',
                  ),
                  SizedBox(width: 10.w),
                  _StatCard(
                    icon: Icons.stars_rounded,
                    color: AppColors.warning,
                    value: scoreLabel,
                    label: 'Ball',
                  ),
                ],
              ),
              if (test.description.isNotEmpty && test.goal.isNotEmpty) ...[
                SizedBox(height: 22.h),
                const AppSectionHeader(title: 'Maqsad'),
                SizedBox(height: 10.h),
                Text(
                  test.goal,
                  style: AppTextStyles.body
                      .copyWith(color: palette.textSecondary, height: 1.55),
                ),
              ],
              if (test.qualities.isNotEmpty) ...[
                SizedBox(height: 22.h),
                const AppSectionHeader(title: 'Rivojlanadigan sifatlar'),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: test.qualities
                      .map((q) => _InfoChip(
                            label: q,
                            color: AppColors.primaryBlue,
                          ))
                      .toList(),
                ),
              ],
              SizedBox(height: 22.h),
              AppSectionHeader(title: 'Savollar ($stepCount)'),
              SizedBox(height: 12.h),
              if (test.steps.isEmpty)
                Text(
                  'Savollar qo\'shilmagan',
                  style: AppTextStyles.body
                      .copyWith(color: palette.textSecondary),
                )
              else
                for (int i = 0; i < test.steps.length; i++)
                  _QuestionRow(step: test.steps[i], index: i + 1),
              if (test.notes.isNotEmpty) ...[
                SizedBox(height: 22.h),
                const AppSectionHeader(title: 'Murabbiy izohi'),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.card.r),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    test.notes,
                    style: AppTextStyles.body
                        .copyWith(color: palette.textPrimary, height: 1.6),
                  ),
                ),
              ],
              if (isFinished) ...[
                SizedBox(height: 22.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.card.r),
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
              SizedBox(height: 12.h),
            ],
          ),
          if (_busy)
            Container(
              color: Colors.black.withValues(alpha: 0.18),
              child: const Center(
                child: ShimmerTestDetail(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: AppBottomBar(child: _buildActionButton(test)),
    );
  }

  Widget _buildActionButton(TestResult test) {
    final String label;
    final VoidCallback? onTap;
    switch (test.status) {
      case TestStatus.pending:
        label = 'Testni boshlash';
        onTap = _busy ? null : _startTest;
      case TestStatus.inProgress:
        label = 'Davom etish';
        onTap = _busy ? null : () => _openRun(test);
      case TestStatus.completed:
      case TestStatus.unknown:
        label = 'Natijani ko\'rish';
        onTap = () => context.push('/test-result', extra: test);
    }
    return CustomButton(
      text: label,
      onPressed: onTap,
      trailingIcon: Icons.arrow_forward_rounded,
    );
  }

  Color _statusColor(TestStatus status) {
    switch (status) {
      case TestStatus.completed:
        return AppColors.success;
      case TestStatus.inProgress:
        return AppColors.warning;
      case TestStatus.pending:
        return AppColors.info;
      case TestStatus.unknown:
        return AppColors.textHint;
    }
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
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(color: context.palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: test.hasCover
            ? RemoteImage(
                url: ApiConstants.resolveMediaUrl(test.coverUrl!),
                borderRadius: BorderRadius.zero,
                fit: BoxFit.cover,
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -24.w,
                    bottom: -24.h,
                    child: Icon(
                      Icons.sports_martial_arts,
                      size: 170.w,
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'Rasm qo\'shilmagan',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Kichik ma'lumot pilli (kategoriya, yosh, holat, sifatlar).
class _InfoChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;

  const _InfoChip({required this.label, this.icon, required this.color});

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
            Icon(icon, size: 12.w, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Uchta teng statistika kartasidan biri.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.button.r),
              ),
              child: Icon(icon, size: 18.w, color: color),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Savollar ro'yxatidagi raqamlangan qator.
class _QuestionRow extends StatelessWidget {
  final TestStep step;
  final int index;

  const _QuestionRow({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final hasMeta = step.repetitions.isNotEmpty || step.duration > 0;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
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
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
                if (hasMeta) ...[
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 4.h,
                    children: [
                      if (step.repetitions.isNotEmpty)
                        _Meta(
                            icon: Icons.repeat_rounded, text: step.repetitions),
                      if (step.duration > 0)
                        _Meta(
                            icon: Icons.timer_outlined,
                            text: '${step.duration}s'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kichik meta yozuv (ikonka + matn).
class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.w, color: palette.textHint),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(color: palette.textSecondary, fontSize: 11.5.sp),
        ),
      ],
    );
  }
}
