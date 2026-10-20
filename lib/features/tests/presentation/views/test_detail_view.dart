import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';

/// Test tafsilotlari: umumiy rasm, maqsad/sifatlar va qadamlar.
/// Testni boshlash orqali taymerli bajarish sahifasiga o'tiladi.
class TestDetailView extends StatefulWidget {
  final TestResult? result;
  final TestEntity? coachTest;

  const TestDetailView({super.key, this.result, this.coachTest});

  @override
  State<TestDetailView> createState() => _TestDetailViewState();
}

class _TestDetailViewState extends State<TestDetailView> {
  late TestEntity? _coachTest = widget.coachTest;
  late TestResult? _result = widget.result ?? _toResult(widget.coachTest);
  bool _busy = false;
  bool _loadingCoachTest = false;
  String? _coachTestLoadError;

  bool get _isCoach => _coachTest != null;

  @override
  void initState() {
    super.initState();
    final test = _coachTest;
    if (test != null) _loadCoachTest(test.id);
  }

  Future<void> _loadCoachTest(int id) async {
    setState(() {
      _loadingCoachTest = true;
      _coachTestLoadError = null;
    });
    final response = await getIt<TestRepository>().getCoachTestDetail(id);
    if (!mounted) return;
    response.fold(
      (error) => setState(() {
        _loadingCoachTest = false;
        _coachTestLoadError = error.message;
      }),
      (test) => setState(() {
        _loadingCoachTest = false;
        _coachTest = test;
        _result = _toResult(test);
      }),
    );
  }

  static TestResult? _toResult(TestEntity? test) {
    if (test == null) return null;
    return TestResult(
      id: test.id,
      testId: test.id,
      name: test.name,
      description: test.description,
      category: test.category,
      age: test.age,
      goal: test.goal,
      qualities: test.qualities,
      coverUrl: test.coverUrl,
      steps: test.steps,
      status: TestStatus.unknown,
    );
  }

  Future<void> _editTest() async {
    final test = _coachTest;
    if (test == null || _busy) return;
    final updated = await context.push<TestEntity>('/create-test', extra: test);
    if (updated != null && mounted) {
      setState(() {
        _coachTest = updated;
        _result = _toResult(updated);
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}'
        '.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return Tr.t('durationSeconds', {'count': '$seconds'});
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (remainingSeconds == 0) {
      return Tr.t('durationMinutes', {'count': '$minutes'});
    }
    return Tr.t('durationMinutesSeconds', {
      'minutes': '$minutes',
      'seconds': '$remainingSeconds',
    });
  }

  Future<void> _startTest() async {
    final current = _result;
    if (current == null || _busy) return;
    if (current.steps.isEmpty) {
      AppSnackbar.warning(context, Tr.t('noQuestionsAdded'));
      return;
    }
    setState(() => _busy = true);
    final response = await getIt<TestRepository>().startTest(current.id);
    if (!mounted) return;
    response.fold(
      (error) {
        setState(() => _busy = false);
        AppSnackbar.error(context, error.message);
      },
      (updated) async {
        setState(() => _result = updated);
        await _openRun(updated);
        if (mounted) setState(() => _busy = false);
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

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final test = _result;

    if (_loadingCoachTest) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: KarateAppBar(title: Tr.t('testDetailsTitle')),
        body: const AppLoadingView(),
      );
    }

    if (_coachTestLoadError != null) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: KarateAppBar(title: Tr.t('testDetailsTitle')),
        body: AppErrorView(
          message: _coachTestLoadError!,
          retryLabel: 'Qayta urinish',
          onRetry: () {
            final coachTest = _coachTest;
            if (coachTest != null) _loadCoachTest(coachTest.id);
          },
        ),
      );
    }

    if (test == null) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: KarateAppBar(title: Tr.t('testDetailsTitle')),
        body: AppEmptyView(
          icon: Icons.search_off_rounded,
          title: Tr.t('testNotFound'),
        ),
      );
    }

    final stepCount = test.steps.length;
    final duration = test.steps.fold<int>(0, (sum, s) => sum + s.duration);
    final durationLabel = _formatDuration(duration);
    final scoreLabel = test.score == null
        ? '—'
        : test.score!.toStringAsFixed(1);
    final paragraph = test.description.isNotEmpty
        ? test.description
        : test.goal;
    final dateValue = _isCoach
        ? null
        : test.finishedAt != null
        ? _formatDate(test.finishedAt)
        : test.startedAt != null
        ? _formatDate(test.startedAt)
        : null;
    final isFinished =
        !_isCoach &&
        (test.status == TestStatus.completed ||
            test.status == TestStatus.unknown);
    final statusColor = _statusColor(palette, test.status);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: KarateAppBar(title: Tr.t('testDetailsTitle')),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenH.w,
              AppSpacing.screenTop.h,
              AppSpacing.screenH.w,
              AppSpacing.screenBottom.h,
            ),
            children: [
              _TestHero(
                test: test,
                statusLabel: _isCoach ? null : test.status.label,
                statusColor: statusColor,
              ),
              SizedBox(height: AppSpacing.xl.h),
              Text(
                test.name,
                style: AppTextStyles.screenTitle.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              Wrap(
                spacing: AppSpacing.sm.w,
                runSpacing: AppSpacing.sm.h,
                children: [
                  if (test.category.isNotEmpty)
                    AppBadge(
                      label: Tr.categoryName(test.category),
                      color: AppColors.primaryBlue,
                      icon: Icons.category_outlined,
                    ),
                  if (test.age.isNotEmpty)
                    AppBadge(
                      label: test.age,
                      color: AppColors.primaryBlue,
                      icon: Icons.cake_outlined,
                    ),
                  if (dateValue != null)
                    AppBadge(
                      label: dateValue,
                      color: palette.textSecondary,
                      icon: Icons.calendar_today_rounded,
                    ),
                ],
              ),
              if (paragraph.isNotEmpty) ...[
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  paragraph,
                  style: AppTextStyles.body.copyWith(
                    color: palette.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.sectionGap.h),
              AppSectionHeader(title: Tr.t('testInformation')),
              SizedBox(height: AppSpacing.md.h),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: AppStatCard(
                        icon: Icons.list_alt_rounded,
                        color: AppColors.primaryBlue,
                        value: '$stepCount',
                        label: Tr.t('questions'),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: AppStatCard(
                        icon: Icons.timer_outlined,
                        color: palette.info,
                        value: durationLabel,
                        label: Tr.t('duration'),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    if (!_isCoach)
                      Expanded(
                        child: AppStatCard(
                          icon: Icons.stars_rounded,
                          color: palette.warning,
                          value: scoreLabel,
                          label: Tr.t('score'),
                        ),
                      ),
                  ],
                ),
              ),
              if (test.description.isNotEmpty && test.goal.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sectionGap.h),
                AppSectionHeader(title: Tr.t('goal')),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  test.goal,
                  style: AppTextStyles.body.copyWith(
                    color: palette.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
              if (test.qualities.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sectionGap.h),
                AppSectionHeader(title: Tr.t('developedQualities')),
                SizedBox(height: AppSpacing.md.h),
                Wrap(
                  spacing: AppSpacing.sm.w,
                  runSpacing: AppSpacing.sm.h,
                  children: [
                    for (final q in test.qualities)
                      AppBadge(
                        label: q,
                        color: AppColors.primaryBlue,
                        filled: false,
                      ),
                  ],
                ),
              ],
              SizedBox(height: AppSpacing.sectionGap.h),
              AppSectionHeader(title: Tr.t('questions')),
              SizedBox(height: AppSpacing.md.h),
              if (test.steps.isEmpty)
                AppEmptyView(
                  icon: Icons.list_alt_rounded,
                  title: Tr.t('noQuestionsAdded'),
                  compact: true,
                )
              else
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var i = 0; i < test.steps.length; i++) ...[
                        if (i > 0) const _RowDivider(),
                        _QuestionRow(step: test.steps[i], index: i + 1),
                      ],
                    ],
                  ),
                ),
              if (test.notes.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sectionGap.h),
                AppSectionHeader(title: Tr.t('coachNote')),
                SizedBox(height: AppSpacing.md.h),
                AppCard(
                  tone: palette.warning.withValues(alpha: 0.07),
                  borderColor: palette.warning.withValues(alpha: 0.3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 18.w,
                        color: palette.warning,
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: Text(
                          test.notes,
                          style: AppTextStyles.body.copyWith(
                            color: palette.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (isFinished) ...[
                SizedBox(height: AppSpacing.sectionGap.h),
                AppCard(
                  tone: palette.success.withValues(alpha: 0.07),
                  borderColor: palette.success.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: palette.success,
                        size: 22.w,
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: Text(
                          test.score == null
                              ? Tr.t('testFinished')
                              : Tr.t('testFinishedWithScore', {
                                  'score': test.score!.toStringAsFixed(1),
                                }),
                          style: AppTextStyles.label.copyWith(
                            color: palette.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.md.h),
            ],
          ),
          if (_busy)
            Positioned.fill(
              child: ColoredBox(
                color: palette.background.withValues(alpha: 0.72),
                child: const Center(child: ShimmerTestDetail()),
              ),
            ),
        ],
      ),
      bottomNavigationBar: AppBottomBar(child: _buildActionButton(test)),
    );
  }

  Widget _buildActionButton(TestResult test) {
    if (_isCoach) {
      return CustomButton(
        text: Tr.t('edit'),
        onPressed: _busy ? null : _editTest,
        trailingIcon: Icons.edit_outlined,
      );
    }

    final String label;
    final VoidCallback? onTap;
    switch (test.status) {
      case TestStatus.pending:
        label = Tr.t('startTest');
        onTap = _busy ? null : _startTest;
      case TestStatus.inProgress:
        label = Tr.t('continueTest');
        onTap = _busy ? null : () => _openRun(test);
      case TestStatus.completed:
      case TestStatus.unknown:
        label = Tr.t('viewResult');
        onTap = () => context.push('/test-result', extra: test);
    }
    return CustomButton(
      text: label,
      onPressed: onTap,
      isLoading: _busy,
      trailingIcon: Icons.arrow_forward_rounded,
    );
  }

  Color _statusColor(AppPalette palette, TestStatus status) {
    switch (status) {
      case TestStatus.completed:
        return palette.success;
      case TestStatus.inProgress:
        return palette.warning;
      case TestStatus.pending:
        return palette.info;
      case TestStatus.unknown:
        return palette.textSecondary;
    }
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 1,
    indent: AppSpacing.lg.w,
    endIndent: AppSpacing.lg.w,
    color: context.palette.divider,
  );
}

class _TestHero extends StatelessWidget {
  final TestResult test;
  final String? statusLabel;
  final Color statusColor;

  const _TestHero({
    required this.test,
    this.statusLabel,
    this.statusColor = AppColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.panel.r),
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
            else ...[
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, AppColors.gradientDeepBlue],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
              ),
              PositionedDirectional(
                end: -24.w,
                bottom: -24.h,
                child: Icon(
                  Icons.sports_martial_arts,
                  size: 170.w,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg.w),
                  child: Text(
                    'Rasm qo\'shilmagan',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ],
            if (statusLabel != null)
              PositionedDirectional(
                start: AppSpacing.md.w,
                top: AppSpacing.md.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(AppRadius.pill.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs.w),
                      Text(
                        statusLabel!,
                        style: AppTextStyles.badge.copyWith(
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
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
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.tile.r),
            ),
            child: Text(
              '$index',
              style: AppTextStyles.badge.copyWith(color: AppColors.primaryBlue),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title.isEmpty ? 'Qadam $index' : step.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                if (hasMeta) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  Wrap(
                    spacing: AppSpacing.md.w,
                    runSpacing: AppSpacing.xs.h,
                    children: [
                      if (step.repetitions.isNotEmpty)
                        _Meta(
                          icon: Icons.repeat_rounded,
                          text: step.repetitions,
                        ),
                      if (step.duration > 0)
                        _Meta(
                          icon: Icons.timer_outlined,
                          text: '${step.duration}s',
                        ),
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
        Icon(icon, size: 13.5.w, color: palette.textHint),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
