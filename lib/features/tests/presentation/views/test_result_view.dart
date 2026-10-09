import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';

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
        appBar: AppBar(title: const Text('Test natijasi')),
        body: const Center(child: Text('Natija topilmadi')),
      );
    }

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: const Text('Test natijasi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
        children: [
          _OverallCard(test: test, result: evaluation),
          if (evaluation == null || evaluation.steps.isEmpty) ...[
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Qadamlar bo\'yicha batafsil natija mavjud emas.',
                style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
              ),
            ),
          ] else ...[
            SizedBox(height: 22.h),
            Text(
              'Qadamlar bo\'yicha natija',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Har bir qadam me\'yorga nisbatan foizda',
              style: TextStyle(color: palette.textSecondary, fontSize: 12.sp),
            ),
            SizedBox(height: 16.h),
            _StepBars(steps: evaluation.steps),
          ],
        ],
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

class _OverallCard extends StatelessWidget {
  final TestResult test;
  final TestEvaluation? result;

  const _OverallCard({required this.test, required this.result});

  @override
  Widget build(BuildContext context) {
    final score = result?.score ?? test.score ?? 0;
    final rating = result?.rating ?? '';
    final color = colorFromName(result?.color ?? 'grey');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
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
          SizedBox(height: 16.h),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 120.w,
                child: CircularProgressIndicator(
                  value: (score / 100).clamp(0.0, 1.0),
                  strokeWidth: 10.w,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rating.isEmpty ? color : colorFromName(result!.color),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
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
          SizedBox(height: 14.h),
          if (rating.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                rating,
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
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: palette.border),
          ),
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
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      s.rating.isEmpty ? '${pct.toStringAsFixed(0)}%' : s.rating,
                      style: TextStyle(
                        color: color,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: pct / 100,
                  minHeight: 10.h,
                  backgroundColor: palette.backgroundLight,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  if (s.seconds > 0)
                    Text(
                      '${s.seconds.toStringAsFixed(1)}s',
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 11.5.sp,
                      ),
                    ),
                  if (s.target.isNotEmpty) ...[
                    SizedBox(width: 10.w),
                    Text(
                      '• Me\'yor: ${s.target}',
                      style: TextStyle(
                        color: palette.textHint,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}