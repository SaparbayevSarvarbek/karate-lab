import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';

/// Test natijasi: umumiy ball va qadamlar bo'yicha diagramma (har bir qadam
/// me'yorga nisbatan necha foiz bajarilgani).
class TestResultView extends StatelessWidget {
  final TestResult? result;

  const TestResultView({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final test = result;
    final evaluation = test?.result;

    if (test == null) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: const KarateAppBar(title: 'Test natijasi'),
        body: const AppEmptyView(
          icon: Icons.bar_chart_rounded,
          title: 'Natija topilmadi',
        ),
      );
    }

    final hasSteps = evaluation != null && evaluation.steps.isNotEmpty;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: const KarateAppBar(title: 'Test natijasi'),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        children: [
          _OverallCard(test: test, result: evaluation),
          SizedBox(height: 16.h),
          _ResultStats(test: test, result: evaluation),
          SizedBox(height: 22.h),
          if (!hasSteps)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.card.r),
                border:
                    Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Qadamlar bo\'yicha batafsil natija mavjud emas.',
                style: AppTextStyles.body.copyWith(color: palette.textSecondary),
              ),
            )
          else ...[
            const AppSectionHeader(title: 'Ko\'nikmalar bo\'yicha natija'),
            SizedBox(height: 12.h),
            _StepBars(steps: evaluation.steps),
          ],
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        child: CustomButton(
          text: hasSteps ? 'Natijani ko\'rib chiqish' : 'Testni qayta topshirish',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
    );
  }
}

Color colorFromName(String name) {
  switch (name) {
    case 'green':
      return AppColors.success;
    case 'blue':
      return AppColors.info;
    case 'orange':
      return AppColors.warning;
    case 'red':
      return AppColors.error;
    default:
      return AppColors.textHint;
  }
}

/// Ball asosida baho (baho API'dan kelmasa ishlatiladi).
String gradeFromScore(double score) {
  if (score >= 85) return 'A\'lo';
  if (score >= 70) return 'Yaxshi';
  if (score >= 55) return 'Qoniqarli';
  return 'Past';
}

class _OverallCard extends StatelessWidget {
  final TestResult test;
  final TestEvaluation? result;

  const _OverallCard({required this.test, required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result?.score ?? test.score ?? 0;
    final rating = result?.rating ?? '';
    final color = colorFromName(result?.color ?? 'grey');
    final grade = rating.isNotEmpty ? rating : gradeFromScore(score);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card.r),
      ),
      child: Column(
        children: [
          Text(
            test.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 18.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 120.w,
                child: CircularProgressIndicator(
                  value: (score / 100).clamp(0.0, 1.0),
                  strokeWidth: 10.w,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '/ 100',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: Text(
              grade,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (result?.age != null) ...[
            SizedBox(height: 10.h),
            Text(
              'Yosh: ${result!.age}',
              style: TextStyle(color: Colors.white70, fontSize: 11.5.sp),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultStats extends StatelessWidget {
  final TestResult test;
  final TestEvaluation? result;

  const _ResultStats({required this.test, required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result?.score ?? test.score ?? 0;
    final steps = result?.steps ?? const <StepResult>[];
    final totalSeconds = steps.fold<double>(0, (sum, s) => sum + s.seconds);
    final timeValue =
        steps.isEmpty ? '—' : '${totalSeconds.toStringAsFixed(1)}s';

    return Row(
      children: [
        _StatCard(
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          value: '${score.toStringAsFixed(0)}%',
          label: 'To\'g\'ri javoblar',
        ),
        SizedBox(width: 10.w),
        _StatCard(
          icon: Icons.timer_outlined,
          color: AppColors.primaryBlue,
          value: timeValue,
          label: 'Sarflangan vaqt',
        ),
        SizedBox(width: 10.w),
        _StatCard(
          icon: Icons.replay_rounded,
          color: AppColors.warning,
          value: '—',
          label: 'Urinishlar',
        ),
      ],
    );
  }
}

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
              child: Icon(icon, color: color, size: 18.w),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
                fontSize: 10.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBars extends StatelessWidget {
  final List<StepResult> steps;

  const _StepBars({required this.steps});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final sorted = [...steps]..sort((a, b) => a.order.compareTo(b.order));
    return Column(
      children: sorted.map((s) {
        final color = colorFromName(s.color);
        final pct = s.percent.clamp(0.0, 100.0);
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5.sp,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
                child: LinearProgressIndicator(
                  value: pct / 100,
                  minHeight: 6.h,
                  backgroundColor: palette.backgroundLight,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              if (s.seconds > 0 || s.target.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Row(
                  children: [
                    if (s.seconds > 0)
                      Text(
                        '${s.seconds.toStringAsFixed(1)}s',
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 11.sp,
                        ),
                      ),
                    const Spacer(),
                    if (s.target.isNotEmpty)
                      Text(
                        'Me\'yor: ${s.target}',
                        style: TextStyle(
                          color: palette.textHint,
                          fontSize: 11.sp,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
