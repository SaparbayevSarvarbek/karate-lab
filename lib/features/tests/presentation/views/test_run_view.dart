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

  void _jumpToStep(int index) {
    if (index == _current) return;
    _pauseTimer();
    _times[_current] = _milliseconds.value / 1000.0;
    setState(() {
      _current = index;
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
    // Vaqt qayd etilmagan qadamlar bo'lsa ogohlantiramiz — aks holda natija
    // 0 ball chiqib, foydalanuvchi sababini tushunmay qoladi.
    final missing = _times.where((t) => t <= 0).length;
    final allMissing = missing == _times.length;

    final title = allMissing
        ? Tr.t('testRunNoTimesTitle')
        : Tr.t('testRunFinishTitle');
    final message = allMissing
        ? Tr.t('testRunNoTimesMessage')
        : missing > 0
            ? '${Tr.t('testRunFinishMessage')}\n\n'
                '${Tr.t('testRunPartialTimes', {'count': '$missing'})}'
            : Tr.t('testRunFinishMessage');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Tr.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: allMissing ? AppColors.warning : AppColors.success,
            ),
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
                        steps: _steps,
                        current: _current,
                        times: _times,
                        progress: progress,
                        milliseconds: _milliseconds,
                        running: _running,
                        onToggleTimer: _submitting ? null : _toggleTimer,
                        onTapStep: _submitting ? null : _jumpToStep,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          layoutBuilder:
                              (currentChild, previousChildren) => Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              ...previousChildren,
                              ?currentChild,
                            ],
                          ),
                          transitionBuilder: (child, animation) => FadeTransition(
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
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                            child: _StepBody(
                              step: step,
                              index: _current,
                              recordedSeconds: _times[_current],
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

/// Yuqori panel: taymer + qadamlar yo'lagi (yagona indikator) + progress.
class _TopBar extends StatelessWidget {
  final List<TestStep> steps;
  final int current;
  final List<double> times;
  final double progress;
  final ValueListenable<int> milliseconds;
  final bool running;
  final VoidCallback? onToggleTimer;
  final void Function(int)? onTapStep;

  const _TopBar({
    required this.steps,
    required this.current,
    required this.times,
    required this.progress,
    required this.milliseconds,
    required this.running,
    required this.onToggleTimer,
    required this.onTapStep,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _TimerPill(
                milliseconds: milliseconds,
                running: running,
                onTap: onToggleTimer,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StepRail(
                  steps: steps,
                  current: current,
                  times: times,
                  onTap: onTapStep,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill.r),
            child: Stack(
              children: [
                Container(height: 6.h, color: palette.border),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  widthFactor: progress.clamp(0.0, 1.0),
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 6.h,
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

/// Qadamlar yo'lagi — yagona holat indikatori (bajarilgan / joriy / kutilmoqda).
class _StepRail extends StatelessWidget {
  final List<TestStep> steps;
  final int current;
  final List<double> times;
  final void Function(int)? onTap;

  const _StepRail({
    required this.steps,
    required this.current,
    required this.times,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm.w),
        itemBuilder: (context, index) {
          final isCurrent = index == current;
          final isDone = !isCurrent && times[index] > 0;

          final Color fill;
          final Color border;
          final Color content;

          if (isCurrent) {
            fill = AppColors.primaryBlue;
            border = AppColors.primaryBlue;
            content = Colors.white;
          } else if (isDone) {
            fill = palette.success.withValues(alpha: 0.14);
            border = palette.success.withValues(alpha: 0.5);
            content = palette.success;
          } else {
            fill = palette.backgroundLight;
            border = palette.border;
            content = palette.textHint;
          }

          return Semantics(
            button: onTap != null,
            selected: isCurrent,
            label: '${Tr.t('testRunSteps')} ${index + 1}',
            excludeSemantics: true,
            child: GestureDetector(
              onTap: onTap != null ? () => onTap!(index) : null,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: fill,
                    shape: BoxShape.circle,
                    border: Border.all(color: border, width: isCurrent ? 0 : 1.2),
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check_rounded, size: 15.w, color: content)
                        : Text(
                            '${index + 1}',
                            style: AppTextStyles.badge.copyWith(
                              color: content,
                              letterSpacing: 0,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  final TestStep step;
  final int index;
  final double recordedSeconds;

  const _StepBody({
    required this.step,
    required this.index,
    required this.recordedSeconds,
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
          step.title.isEmpty ? '${Tr.t('testRunSteps')} ${index + 1}' : step.title,
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
                  label: '${step.duration}s',
                  color: palette.info,
                ),
              if (recordedSeconds > 0)
                _MetaChip(
                  icon: Icons.check_circle_rounded,
                  label: '${recordedSeconds.toStringAsFixed(1)}s',
                  color: palette.success,
                ),
            ],
          ),
        ],
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

/// Pastki panel — faqat navigatsiya (taymer yuqorida).
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
              trailingIcon:
                  isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerPill extends StatelessWidget {
  final ValueListenable<int> milliseconds;
  final bool running;
  final VoidCallback? onTap;

  const _TimerPill({
    required this.milliseconds,
    required this.running,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = running ? AppColors.primaryBlue : palette.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        decoration: BoxDecoration(
          color: running
              ? AppColors.primaryBlue.withValues(alpha: 0.1)
              : palette.backgroundLight,
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          border: Border.all(
            color: running ? AppColors.primaryBlue : palette.border,
            width: running ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              running ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 17.w,
              color: accent,
            ),
            SizedBox(width: 4.w),
            ValueListenableBuilder<int>(
              valueListenable: milliseconds,
              builder: (context, value, _) => Text(
                _TestRunViewState._formatMs(value),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: running ? AppColors.primaryBlue : palette.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
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
