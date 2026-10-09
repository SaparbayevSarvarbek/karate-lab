import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../../core/widgets/status_badge.dart';
import '../viewmodels/test_bloc.dart';

/// Testlar sahifasi.
///
/// - Murabbiy: Swagger `GET /tests/` â€” o'zi yaratgan testlari.
/// - Sportchi: Swagger `GET /my-tests/` â€” barcha faol testlar (avtomatik).
class TestsLibraryView extends StatefulWidget {
  final String? userRole;

  const TestsLibraryView({super.key, this.userRole});

  @override
  State<TestsLibraryView> createState() => _TestsLibraryViewState();
}

class _TestsLibraryViewState extends State<TestsLibraryView> {
  bool get _isCoach => widget.userRole == AppConstants.roleCoach;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<TestBloc>();
        bloc.add(_isCoach ? const LoadCoachTests() : const LoadMyTests());
        return bloc;
      },
      child: BlocBuilder<TestBloc, TestState>(
          builder: (context, state) {
            final palette = context.palette;
            return Scaffold(
              backgroundColor: palette.background,
              appBar: AppBar(
                title: Text(_isCoach ? Tr.t('testsMine') : Tr.t('testsAthlete')),
                centerTitle: true,
              ),
              body: _buildBody(context, state),
              floatingActionButton: _isCoach
                  ? FloatingActionButton.extended(
                      onPressed: () async {
                        final created = await context.push('/create-test');
                        if (created == true && context.mounted) {
                          context.read<TestBloc>().add(const LoadCoachTests());
                        }
                      },
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.add),
                      label: Text('Test', style: TextStyle(fontSize: 13.sp)),
                    )
                  : null,
            );
          },
      ),
    );
  }

  Widget _buildBody(BuildContext context, TestState state) {
    if (state is TestLoading) {
      return RefreshIndicator(
        onRefresh: () async => context.read<TestBloc>().add(_isCoach ? const LoadCoachTests() : const LoadMyTests()),
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
          children: _isCoach
              ? List.generate(5, (index) => ShimmerCoachTestCard())
              : List.generate(5, (index) => ShimmerTestResultCard()),
        ),
      );
    }

    if (state is CoachTestsLoaded) {
      if (state.tests.isEmpty) return const _EmptyTests();
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<TestBloc>().add(const LoadCoachTests()),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
          itemCount: state.tests.length,
          itemBuilder: (context, index) =>
              _buildCoachTestCard(context, state.tests[index]),
        ),
      );
    }

    if (state is MyTestsLoaded) {
      if (state.tests.isEmpty) return const _EmptyTests();
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<TestBloc>().add(const LoadMyTests()),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          itemCount: state.tests.length,
          itemBuilder: (context, index) =>
              _buildTestCard(context, state.tests[index]),
        ),
      );
    }

    if (state is TestError) {
      final palette = context.palette;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56.w, color: palette.textHint),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: () => context.read<TestBloc>().add(
                    _isCoach ? const LoadCoachTests() : const LoadMyTests(),
                  ),
              child: const Text('Qayta urinish'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCoachTestCard(BuildContext context, TestEntity test) {
    final palette = context.palette;
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RemoteImage(
                  url: test.coverUrl,
                  width: 56.w,
                  height: 56.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      if (test.age.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          test.age,
                          style: TextStyle(
                              color: palette.textSecondary, fontSize: 11.5.sp),
                        ),
                      ],
                    ],
                  ),
                ),
                if (test.category.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      test.category,
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.list_alt_rounded, size: 14.w, color: palette.textHint),
                SizedBox(width: 4.w),
                Text('${test.steps.length} qadam',
                    style: TextStyle(
                        color: palette.textSecondary, fontSize: 12.sp)),
                SizedBox(width: 14.w),
                Icon(Icons.timer_outlined, size: 14.w, color: palette.textHint),
                SizedBox(width: 4.w),
                Text('${test.totalDuration} soniya',
                    style: TextStyle(
                        color: palette.textSecondary, fontSize: 12.sp)),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: (test.isActive ? AppColors.success : AppColors.textHint)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        test.isActive
                            ? Icons.check_circle_rounded
                            : Icons.pause_circle_rounded,
                        size: 13.w,
                        color: test.isActive
                            ? AppColors.success
                            : AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        test.isActive ? 'Faol' : 'Nofaol',
                        style: TextStyle(
                          color: test.isActive
                              ? AppColors.success
                              : AppColors.textHint,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, TestResult test) {
    final palette = context.palette;
    final statusColor = switch (test.status) {
      TestStatus.completed => AppColors.success,
      TestStatus.inProgress => AppColors.warning,
      TestStatus.pending => AppColors.info,
      TestStatus.unknown => AppColors.textHint,
    };
    final statusIcon = switch (test.status) {
      TestStatus.completed => Icons.check_circle_rounded,
      TestStatus.inProgress => Icons.pending_rounded,
      TestStatus.pending => Icons.schedule_rounded,
      TestStatus.unknown => Icons.help_outline_rounded,
    };
    final firstImage = test.hasCover ? test.coverUrl : null;

    return GestureDetector(
      onTap: () async {
        await context.push('/test-detail', extra: test);
        if (context.mounted) {
          context.read<TestBloc>().add(const LoadMyTests());
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(
                          label: test.status.label,
                          color: statusColor,
                          icon: statusIcon,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          test.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (firstImage != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12.h, 12.w, 0),
                    child: RemoteImage(
                      url: firstImage,
                      width: 72.w,
                      height: 54.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt_rounded,
                          size: 14.w, color: palette.textHint),
                      SizedBox(width: 4.w),
                      Text('${test.steps.length} qadam',
                          style: TextStyle(
                              color: palette.textSecondary, fontSize: 12.sp)),
                      if (test.score != null) ...[
                        SizedBox(width: 14.w),
                        Icon(Icons.stars_rounded,
                            size: 14.w, color: AppColors.warning),
                        SizedBox(width: 4.w),
                        Text('${test.score!.toStringAsFixed(1)} ball',
                            style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700)),
                      ],
                    ],
                  ),
                  if (test.status == TestStatus.pending) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await context.push('/test-detail', extra: test);
                          if (context.mounted) {
                            context.read<TestBloc>().add(const LoadMyTests());
                          }
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Boshlash'),
                      ),
                    ),
                  ],
                  if (test.status == TestStatus.inProgress) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await context.push('/test-detail', extra: test);
                          if (context.mounted) {
                            context.read<TestBloc>().add(const LoadMyTests());
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.warning,
                        ),
                        icon: const Icon(Icons.timer_rounded, size: 18),
                        label: const Text('Davom etish'),
                      ),
                    ),
                  ],
                  if (test.status == TestStatus.completed) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.push('/test-result', extra: test),
                        icon: const Icon(Icons.bar_chart_rounded, size: 18),
                        label: const Text('Natijani ko\'rish'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTests extends StatelessWidget {
  const _EmptyTests();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 56.w, color: palette.textHint),
          SizedBox(height: 14.h),
          Text('Hozircha testlar yo\'q',
              style: TextStyle(color: palette.textSecondary, fontSize: 13.sp)),
        ],
      ),
    );
  }
}
