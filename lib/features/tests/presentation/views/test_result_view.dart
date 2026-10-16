import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_hero_panel.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_stat_card.dart';
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
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenH.w,
          AppSpacing.screenTop.h,
          AppSpacing.screenH.w,
          AppSpacing.screenBottom.h,
        ),
        children: [
          _OverallCard(test: test, result: evaluation),
          SizedBox(height: AppSpacing.lg.h),
          _ResultStats(test: test, result: evaluation),
          SizedBox(height: AppSpacing.sectionGap.h),
          if (!hasSteps)
            AppCard(
              tone: palette.warning.withValues(alpha: 0.07),
              borderColor: palette.warning.withValues(alpha: 0.3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18.w,
                    color: palette.warning,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Text(
                      'Qadamlar bo\'yicha batafsil natija mavjud emas.',
                      style: AppTextStyles.body.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            const AppSectionHeader(title: 'Ko\'nikmalar bo\'yicha natija'),
            SizedBox(height: AppSpacing.md.h),
            AppCard(child: _StepBars(steps: evaluation.steps)),
          ],
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        child: CustomButton(
          text: hasSteps
              ? 'Natijani ko\'rib chiqish'
              : 'Testni qayta topshirish',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
    );
  }
}

/// Baho rangini mavzuga mos holat rangiga o'giradi.
Color _toneColor(AppPalette palette, String name) {
  switch (name) {
    case 'green':
      return palette.success;
    case 'blue':
      return palette.info;
    case 'orange':
      return palette.warning;
    case 'red':
      return palette.error;
    default:
      return palette.textSecondary;
  }
}

/// Diagramma (progress bar) uchun yorqinroq grafik variant.
Color _graphicColor(String name) {
  switch (name) {
    case 'green':
      return AppColors.successBright;
    case 'blue':
      return AppColors.infoBright;
    case 'orange':
      return AppColors.warningBright;
    case 'red':
      return AppColors.errorBright;
    default:
      return AppColors.textSecondary;
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
    final palette = context.palette;
    final score = result?.score ?? test.score ?? 0;
    final rating = result?.rating ?? '';
    final ringColor = _toneColor(palette, result?.color ?? 'grey');
    final grade = rating.isNotEmpty ? rating : gradeFromScore(score);

    return AppHeroPanel(
      watermark: Icons.emoji_events_rounded,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              test.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 128.w,
                  height: 128.w,
                  child: CircularProgressIndicator(
                    value: (score / 100).clamp(0.0, 1.0),
                    strokeWidth: 9.w,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score.toStringAsFixed(1),
                      style: AppTextStyles.stat.copyWith(
                        fontSize: 32.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg.w,
                vertical: 7.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
              ),
              child: Text(
                grade,
                style: AppTextStyles.badge.copyWith(
                  color: Colors.white,
                  letterSpacing: 0,
                ),
              ),
            ),
            if (result?.age != null) ...[
              SizedBox(height: AppSpacing.md.h),
              Text(
                'Yosh: ${result!.age}',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
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
    final palette = context.palette;
    final score = result?.score ?? test.score ?? 0;
    final steps = result?.steps ?? const <StepResult>[];
    final totalSeconds = steps.fold<double>(0, (sum, s) => sum + s.seconds);
    final timeValue = steps.isEmpty
        ? '—'
        : '${totalSeconds.toStringAsFixed(1)}s';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppStatCard(
              icon: Icons.check_circle_outline_rounded,
              color: palette.success,
              value: '${score.toStringAsFixed(0)}%',
              label: 'To\'g\'ri javoblar',
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: AppStatCard(
              icon: Icons.timer_outlined,
              color: AppColors.primaryBlue,
              value: timeValue,
              label: 'Sarflangan vaqt',
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: AppStatCard(
              icon: Icons.replay_rounded,
              color: palette.warning,
              value: '—',
              label: 'Urinishlar',
            ),
          ),
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
    final sorted = [...steps]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: [
        for (var i = 0; i < sorted.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.lg.h),
          _StepBar(step: sorted[i]),
        ],
      ],
    );
  }
}

class _StepBar extends StatelessWidget {
  final StepResult step;

  const _StepBar({required this.step});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final pct = step.percent.clamp(0.0, 100.0);
    final textColor = _toneColor(palette, step.color);
    final barColor = _graphicColor(step.color);
    final hasMeta = step.seconds > 0 || step.target.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                step.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label.copyWith(color: palette.textPrimary),
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Text(
              '${pct.toStringAsFixed(0)}%',
              style: AppTextStyles.label.copyWith(color: textColor),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
          child: LinearProgressIndicator(
            value: pct / 100,
            minHeight: 6.h,
            backgroundColor: palette.backgroundLight,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        if (hasMeta) ...[
          SizedBox(height: AppSpacing.sm.h),
          Row(
            children: [
              if (step.seconds > 0)
                Text(
                  '${step.seconds.toStringAsFixed(1)}s',
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              const Spacer(),
              if (step.target.isNotEmpty)
                Text(
                  'Me\'yor: ${step.target}',
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textHint,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
