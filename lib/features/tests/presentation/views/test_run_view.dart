import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';

/// Testni taymer bilan bajarish sahifasi (professional redesign).
///
/// Task 2: Professional test run UI with:
/// - Top header (test name, progress, step counter, timer)
/// - Step navigator chips
/// - Exit & finish confirmation dialogs
/// - AnimatedSwitcher transitions
/// - Responsive max-width layout
/// - Loading/error states
class TestRunView extends StatefulWidget {
  final TestResult result;

  const TestRunView({super.key, required this.result});

  @override
  State<TestRunView> createState() => _TestRunViewState();
}

class _TestRunViewState extends State<TestRunView> with SingleTickerProviderStateMixin {
  late final List<TestStep> _steps = widget.result.steps;
  late final List<double> _times = List<double>.filled(_steps.length, 0);
  int _current = 0;

  Timer? _timer;
  int _milliseconds = 0;
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
    super.dispose();
  }

  void _restoreCurrent() {
    _timer?.cancel();
    _running = false;
    _milliseconds = (_times[_current] * 1000).round();
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
      if (!mounted) return;
      setState(() => _milliseconds += 100);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() => _running = false);
  }

  String get _formatted {
    final totalSeconds = _milliseconds / 1000.0;
    final minutes = totalSeconds ~/ 60;
    final seconds = (totalSeconds % 60).toStringAsFixed(1).padLeft(4, '0');
    return '${minutes.toString().padLeft(2, '0')}:$seconds';
  }

  void _next() {
    _pauseTimer();
    _times[_current] = _milliseconds / 1000.0;
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
    _times[_current] = _milliseconds / 1000.0;
    setState(() {
      _current -= 1;
      _restoreCurrent();
    });
  }

  void _jumpToStep(int index) {
    if (index == _current) return;
    _pauseTimer();
    _times[_current] = _milliseconds / 1000.0;
    setState(() {
      _current = index;
      _restoreCurrent();
    });
  }

  Future<bool> _onWillPop() async {
    if (_submitting) return false;
    return await _showExitConfirmation() ?? false;
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

    final stepTimes = <FinishStepInput>[];
    for (var i = 0; i < _steps.length; i++) {
      stepTimes.add(FinishStepInput(stepId: _steps[i].id, seconds: _times[i]));
    }

    final result = await getIt<TestRepository>().finishTest(
      widget.result.id,
      FinishTestRequest(stepTimes: stepTimes),
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      (result) => Navigator.of(context).pop(result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (_steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.result.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 56.w, color: palette.textHint),
              SizedBox(height: 12.h),
              Text(
                'Qadamlar topilmadi',
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
      onPopInvoked: (didPop) async {
        if (!didPop && !_submitting) {
          final shouldPop = await _showExitConfirmation();
          if (shouldPop == true && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          title: Text(
            widget.result.name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _submitting
                ? null
                : () async {
                    final shouldExit = await _showExitConfirmation();
                    if (shouldExit == true && mounted) {
                      Navigator.of(context).pop();
                    }
                  },
          ),
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
                      _HeaderCard(
                        current: _current,
                        total: _steps.length,
                        progress: progress,
                        formatted: _formatted,
                      ),
if (_steps.length <= 12) ...[
                        SizedBox(height: 12.h),
                        _StepNavigator(
                          steps: _steps,
                          current: _current,
                          times: _times,
                          onTap: _submitting ? null : _jumpToStep,
                        ),
                      ],
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.05, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: SingleChildScrollView(
                            key: ValueKey<int>(_current),
                            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                            child: _StepContent(step: step, current: _current),
                          ),
                        ),
                      ),
                      _TimerCard(
                        formatted: _formatted,
                        running: _running,
                        submitting: _submitting,
                        onToggle: _submitting ? null : _toggleTimer,
                      ),
                      _BottomBar(
                        isFirst: _isFirst,
                        isLast: _isLast,
                        busy: _submitting,
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

class _HeaderCard extends StatelessWidget {
  final int current;
  final int total;
  final double progress;
  final String formatted;

  const _HeaderCard({
    required this.current,
    required this.total,
    required this.progress,
    required this.formatted,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final percent = (progress * 100).toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Tr.t('testRunCurrent', {
                  'current': '${current + 1}',
                  'total': '$total',
                }),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 14.w, color: AppColors.primaryBlue),
                  SizedBox(width: 4.w),
                  Text(
                    formatted,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Stack(
            children: [
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: palette.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8.h,
                width: MediaQuery.of(context).size.width * progress,
                constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width - 32.w) * progress,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              Tr.t('testRunProgress', {'percent': percent}),
              style: TextStyle(
                fontSize: 11.sp,
                color: palette.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepNavigator extends StatelessWidget {
  final List<TestStep> steps;
  final int current;
  final List<double> times;
  final void Function(int)? onTap;

  const _StepNavigator({
    required this.steps,
    required this.current,
    required this.times,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isCurrent = index == current;
          final isCompleted = times[index] > 0 && index != current;

          return GestureDetector(
            onTap: onTap != null ? () => onTap!(index) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40.w,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primaryBlue
                    : isCompleted
                        ? AppColors.success.withValues(alpha: 0.15)
                        : palette.surface,
                border: Border.all(
                  color: isCurrent
                      ? AppColors.primaryBlue
                      : isCompleted
                          ? AppColors.success
                          : palette.border,
                  width: isCurrent ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCompleted)
                    Icon(Icons.check_circle_rounded,
                        size: 16.w, color: AppColors.success)
                  else
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isCurrent ? Colors.white : palette.textPrimary,
                      ),
                    ),
                  SizedBox(height: 2.h),
                  Text(
                    isCurrent
                        ? Tr.t('testRunCurrentStep')
                        : isCompleted
                            ? Tr.t('testRunAnswered')
                            : Tr.t('testRunUnanswered'),
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: isCurrent
                          ? Colors.white.withValues(alpha: 0.9)
                          : isCompleted
                              ? AppColors.success
                              : palette.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  final TestStep step;
  final int current;

  const _StepContent({required this.step, required this.current});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step.hasImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: RemoteImage(
              url: ApiConstants.resolveMediaUrl(step.imageUrl!),
              width: double.infinity,
              height: 220.h,
              borderRadius: BorderRadius.zero,
            ),
          ),
        if (step.hasImage) SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: palette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      Tr.t('testRunSteps') + ' ${current + 1}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                step.title.isEmpty ? 'Qadam ${current + 1}' : step.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
if (step.description.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Text(
                  step.description,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 13.5.sp,
                    height: 1.55,
                  ),
                ),
              ],
if (step.repetitions.isNotEmpty) ...[
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.repeat_rounded,
                          size: 16.w, color: AppColors.primaryBlue),
                      SizedBox(width: 8.w),
                      Text(
                        step.repetitions,
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TimerCard extends StatelessWidget {
  final String formatted;
  final bool running;
  final bool submitting;
  final VoidCallback? onToggle;

  const _TimerCard({
    required this.formatted,
    required this.running,
    required this.submitting,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: running ? AppColors.primaryBlue : palette.border,
          width: running ? 2 : 1,
        ),
        boxShadow: running
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 20.w,
                color: running ? AppColors.primaryBlue : palette.textHint,
              ),
              SizedBox(width: 6.w),
              Text(
                Tr.t('testRunElapsed'),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: running ? AppColors.primaryBlue : palette.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            formatted,
            style: TextStyle(
              fontSize: 42.sp,
              fontWeight: FontWeight.w800,
              color: running ? AppColors.primaryBlue : palette.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
              height: 1.0,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onToggle,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                backgroundColor: running ? AppColors.warning : AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              icon: Icon(
                running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 22.w,
              ),
              label: Text(
                running
                    ? Tr.t('testRunTimerPause')
                    : Tr.t('testRunTimerStart'),
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool busy;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const _BottomBar({
    required this.isFirst,
    required this.isLast,
    required this.busy,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isFirst)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(Tr.t('testRunPrevious')),
              ),
            ),
          if (!isFirst) SizedBox(width: 12.w),
          Expanded(
            flex: isFirst ? 1 : 2,
            child: FilledButton.icon(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                backgroundColor: isLast ? AppColors.success : AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              icon: busy
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded),
              label: Text(
                isLast ? Tr.t('testRunFinish') : Tr.t('testRunNext'),
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
