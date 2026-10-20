import 'dart:async';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Testni taymer bilan bajarish sahifasi.
///
/// Tuzilma: yuqorida taymer + qadamlar yo'lagi (yagona holat indikatori) +
/// progress, o'rtada qadam mazmuni, pastda faqat navigatsiya paneli.
class TestRunView extends StatefulWidget {
  final TestResult result;

  const TestRunView({super.key, required this.result});

  @override
  State<TestRunView> createState() => _TestRunViewState();
}

class _TestRunViewState extends State<TestRunView> {
  late final List<TestStep> _steps = widget.result.steps;
  late final List<double> _times = List<double>.filled(_steps.length, 0);
  int _current = 0;

  Timer? _timer;

  /// Taymer qiymati `ValueNotifier` da — shunda har 100 ms da butun sahifa
  /// emas, faqat taymer yozuvi qayta chiziladi (rasm/ro'yxat tegilmaydi).
  final ValueNotifier<int> _milliseconds = ValueNotifier<int>(0);
  bool _running = false;
  bool _submitting = false;

  bool get _isLast => _current == _steps.length - 1;
  bool get _isFirst => _current == 0;

  @override
  void initState() {
    super.initState();
    _restoreCurrent();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _milliseconds.dispose();
    super.dispose();
  }

  void _restoreCurrent() {
    _timer?.cancel();
    _running = false;
    _milliseconds.value = (_times[_current] * 1000).round();
  }

  void _toggleTimer() {
    if (_running) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _milliseconds.value += 100;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() => _running = false);
  }

  static String _formatMs(int ms) {
    final totalSeconds = ms / 1000.0;
    final minutes = totalSeconds ~/ 60;
    final seconds = (totalSeconds % 60).toStringAsFixed(1).padLeft(4, '0');
    return '${minutes.toString().padLeft(2, '0')}:$seconds';
  }

  void _next() {
    _pauseTimer();
    _times[_current] = _milliseconds.value / 1000.0;
    if (_isLast) {
      _showFinishConfirmation();
      return;
    }
    setState(() {
      _current += 1;
      _restoreCurrent();
    });
  }

  void _previous() {
    if (_isFirst) return;
    _pauseTimer();
    _times[_current] = _milliseconds.value / 1000.0;
    setState(() {
      _current -= 1;
      _restoreCurrent();
    });
  }

  Future<bool?> _showExitConfirmation() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Tr.t('testRunExitTitle')),
        content: Text(Tr.t('testRunExitMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Tr.t('testRunStay')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(Tr.t('testRunExit')),
          ),
        ],
      ),
    );
  }

  Future<void> _showFinishConfirmation() async {
    final missing = _times.where((t) => t <= 0).length;
    if (missing > 0) {
      AppSnackbar.warning(context, Tr.t('testRunTimerRequired'));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Tr.t('testRunFinishTitle')),
        content: Text(Tr.t('testRunFinishMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Tr.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            child: Text(Tr.t('testRunFinish')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _finish();
    }
  }

  Future<void> _finish() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    _timer?.cancel();
    _running = false;

    final stepTimes = <FinishStepInput>[
      for (var i = 0; i < _steps.length; i++)
        FinishStepInput(stepId: _steps[i].id, seconds: _times[i]),
    ];

    final result = await getIt<TestRepository>().finishTest(
      widget.result.id,
      FinishTestRequest(stepTimes: stepTimes),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (error) {
        AppSnackbar.error(context, error.message);
      },
      // Natija qaytariladi — chaqiruvchi ekran natija sahifasini ochadi.
      (finished) => Navigator.of(context).pop(finished),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (_steps.isEmpty) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: KarateAppBar(title: widget.result.name),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 56.w, color: palette.textHint),
              SizedBox(height: 12.h),
              Text(
                Tr.t('stepsNotFound'),
                style: TextStyle(color: palette.textSecondary, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      );
    }

    final step = _steps[_current];
    final progress = (_current + 1) / _steps.length;

    return PopScope(
      canPop: !_submitting,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || _submitting) return;
        final shouldExit = await _showExitConfirmation();
        if (shouldExit == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: KarateAppBar(
          title: widget.result.name,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _submitting
                ? null
                : () async {
                    final shouldExit = await _showExitConfirmation();
                    if (shouldExit == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 16.w),
              child: Center(
                child: Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isWide ? 640 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      _TopBar(
                        current: _current,
                        total: _steps.length,
                        progress: progress,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          layoutBuilder: (currentChild, previousChildren) =>
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [...previousChildren, ?currentChild],
                              ),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.04, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: SingleChildScrollView(
                            key: ValueKey<int>(_current),
                            padding: EdgeInsets.fromLTRB(
                              16.w,
                              16.h,
                              16.w,
                              20.h,
                            ),
                            child: _StepBody(
                              step: step,
                              index: _current,
                              recordedSeconds: _times[_current],
                              milliseconds: _milliseconds,
                              running: _running,
                              onToggleTimer: _submitting ? null : _toggleTimer,
                            ),
                          ),
                        ),
                      ),
                      _NavBar(
                        submitting: _submitting,
                        isFirst: _isFirst,
                        isLast: _isLast,
                        onPrevious: _submitting || _isFirst ? null : _previous,
                        onNext: _submitting ? null : _next,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int current;
  final int total;
  final double progress;

  const _TopBar({
    required this.current,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final remaining = total - current - 1;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Tr.t('testRunCurrent', {
                  'current': '${current + 1}',
                  'total': '$total',
                }),
                style: AppTextStyles.body.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                Tr.t('testRunRemaining', {'count': '$remaining'}),
                style: AppTextStyles.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill.r),
            child: Stack(
              children: [
                Container(height: 7.h, color: palette.border),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  widthFactor: progress.clamp(0.0, 1.0),
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(AppRadius.pill.r),
                    ),
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

class _StepBody extends StatelessWidget {
  final TestStep step;
  final int index;
  final double recordedSeconds;
  final ValueListenable<int> milliseconds;
  final bool running;
  final VoidCallback? onToggleTimer;

  const _StepBody({
    required this.step,
    required this.index,
    required this.recordedSeconds,
    required this.milliseconds,
    required this.running,
    required this.onToggleTimer,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHero(step: step, index: index),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          step.title.isEmpty
              ? '${Tr.t('testRunSteps')} ${index + 1}'
              : step.title,
          style: AppTextStyles.title.copyWith(color: palette.textPrimary),
        ),
        if (step.description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm.h),
          Text(
            step.description,
            style: AppTextStyles.body.copyWith(
              color: palette.textSecondary,
              height: 1.55,
            ),
          ),
        ],
        if (step.repetitions.isNotEmpty ||
            step.duration > 0 ||
            recordedSeconds > 0) ...[
          SizedBox(height: AppSpacing.lg.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              if (step.repetitions.isNotEmpty)
                _MetaChip(
                  icon: Icons.repeat_rounded,
                  label: step.repetitions,
                  color: AppColors.primaryBlue,
                ),
              if (step.duration > 0)
                _MetaChip(
                  icon: Icons.timer_outlined,
                  label: '${step.duration}${Tr.t('seconds')}',
                  color: palette.info,
                ),
              if (recordedSeconds > 0)
                _MetaChip(
                  icon: Icons.check_circle_rounded,
                  label:
                      '${recordedSeconds.toStringAsFixed(1)}${Tr.t('seconds')}',
                  color: palette.success,
                ),
            ],
          ),
        ],
        SizedBox(height: AppSpacing.lg.h),
        _StopwatchCard(
          milliseconds: milliseconds,
          running: running,
          onToggle: onToggleTimer,
        ),
      ],
    );
  }
}

/// Qadam rasmi — 16:10 nisbatda, mazmunning eng yuqorisida.
class _StepHero extends StatelessWidget {
  final TestStep step;
  final int index;

  const _StepHero({required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.panel.r),
          border: Border.all(color: palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (step.hasImage)
              RemoteImage(
                url: ApiConstants.resolveMediaUrl(step.imageUrl!),
                borderRadius: BorderRadius.zero,
                fit: BoxFit.cover,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, AppColors.gradientDeepBlue],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_martial_arts,
                      size: 42.w,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      Tr.t('testRunNoImage'),
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            PositionedDirectional(
              start: AppSpacing.md.w,
              top: AppSpacing.md.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(AppRadius.pill.r),
                ),
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.badge.copyWith(
                    color: Colors.white,
                    letterSpacing: 0,
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.w, color: color),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pastki panel — faqat test qadamlarini boshqarish.
class _NavBar extends StatelessWidget {
  final bool submitting;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const _NavBar({
    required this.submitting,
    required this.isFirst,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomBar(
      child: Row(
        children: [
          if (!isFirst) ...[
            _SquareButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: CustomButton(
              text: isLast ? Tr.t('testRunFinish') : Tr.t('testRunNext'),
              onPressed: onNext,
              isLoading: submitting,
              height: 48,
              // Yakunlash tugmasi yashil — test tugaganini bildiradi.
              color: isLast ? AppColors.success : null,
              trailingIcon: isLast
                  ? Icons.flag_rounded
                  : Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopwatchCard extends StatelessWidget {
  final ValueListenable<int> milliseconds;
  final bool running;
  final VoidCallback? onToggle;

  const _StopwatchCard({
    required this.milliseconds,
    required this.running,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.panel.r),
        border: Border.all(
          color: running ? AppColors.primaryBlue : palette.border,
          width: running ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: AppColors.primaryBlue,
                  size: 21.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  Tr.t('testRunElapsed'),
                  style: AppTextStyles.body.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: milliseconds,
                  builder: (context, value, _) => Text(
                    _TestRunViewState._formatMs(value),
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 19.w,
                ),
                label: Text(
                  Tr.t(running ? 'testRunTimerPause' : 'testRunTimerStart'),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SquareButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: palette.backgroundLight,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: palette.border),
        ),
        child: Icon(
          icon,
          size: 22.w,
          color: enabled ? palette.textPrimary : palette.textHint,
        ),
      ),
    );
  }
}
