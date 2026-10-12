import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../../core/widgets/status_badge.dart';
import '../viewmodels/test_bloc.dart';

/// Testlar sahifasi.
///
/// - Murabbiy: Swagger `GET /tests/` — o'zi yaratgan testlari.
/// - Sportchi: Swagger `GET /my-tests/` — barcha faol testlar (avtomatik).
class TestsLibraryView extends StatefulWidget {
  final String? userRole;

  const TestsLibraryView({super.key, this.userRole});

  @override
  State<TestsLibraryView> createState() => _TestsLibraryViewState();
}

class _TestsLibraryViewState extends State<TestsLibraryView> {
  bool get _isCoach => widget.userRole == AppConstants.roleCoach;

  static const List<String> _filters = [
    'Barchasi',
    'O\'zlashtirish',
    'Tayyorgarlik',
  ];
  String _selectedFilter = _filters.first;

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
            appBar: const KarateAppBar(title: 'KarateLab AI', showLogo: true),
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
        onRefresh: () async => context.read<TestBloc>().add(
              _isCoach ? const LoadCoachTests() : const LoadMyTests(),
            ),
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 96.h),
          children: [
            _buildFilterChips(context),
            SizedBox(height: 16.h),
            ...(_isCoach
                ? List.generate(5, (index) => const ShimmerCoachTestCard())
                : List.generate(5, (index) => const ShimmerTestResultCard())),
          ],
        ),
      );
    }

    if (state is CoachTestsLoaded) {
      if (state.tests.isEmpty) return const _EmptyTests();
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<TestBloc>().add(const LoadCoachTests()),
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 96.h),
          children: [
            _buildFilterChips(context),
            SizedBox(height: 16.h),
            for (final test in state.tests) _buildCoachTestCard(context, test),
          ],
        ),
      );
    }

    if (state is MyTestsLoaded) {
      if (state.tests.isEmpty) return const _EmptyTests();
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<TestBloc>().add(const LoadMyTests()),
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            _buildFilterChips(context),
            SizedBox(height: 16.h),
            for (final test in state.tests) _buildTestCard(context, test),
          ],
        ),
      );
    }

    if (state is TestError) {
      return AppErrorView(
        message: state.message,
        onRetry: () => context.read<TestBloc>().add(
              _isCoach ? const LoadCoachTests() : const LoadMyTests(),
            ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFilterChips(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) => _FilterChip(
          label: _filters[index],
          selected: _filters[index] == _selectedFilter,
          onTap: () => setState(() => _selectedFilter = _filters[index]),
        ),
      ),
    );
  }

  Widget _buildCoachTestCard(BuildContext context, TestEntity test) {
    final palette = context.palette;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconTile(
            icon: Icons.assignment_outlined,
            color: AppColors.primaryBlue,
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
                  style: AppTextStyles.cardTitle
                      .copyWith(color: palette.textPrimary),
                ),
                if (test.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    test.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption
                        .copyWith(color: palette.textSecondary),
                  ),
                ],
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 4.h,
                  children: [
                    _Meta(
                      icon: Icons.list_alt_rounded,
                      text: '${test.steps.length} qadam',
                    ),
                    if (test.totalDuration > 0)
                      _Meta(
                        icon: Icons.timer_outlined,
                        text: '${test.totalDuration}s',
                      ),
                    if (test.category.isNotEmpty)
                      _Meta(
                        icon: Icons.category_outlined,
                        text: test.category,
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          StatusBadge(
            label: test.isActive ? 'Faol' : 'Nofaol',
            color: test.isActive ? AppColors.success : AppColors.textHint,
            icon: test.isActive
                ? Icons.check_circle_rounded
                : Icons.pause_circle_rounded,
          ),
        ],
      ),
    );
  }

  Future<void> _openDetail(TestResult test) async {
    await context.push('/test-detail', extra: test);
    if (!mounted) return;
    context.read<TestBloc>().add(const LoadMyTests());
  }

  /// Boshlangan testni to'g'ridan-to'g'ri davom ettiradi (tafsilotni ochmasdan).
  Future<void> _resumeRun(TestResult test) async {
    final finished = await context.push<TestResult>('/test-run', extra: test);
    if (!mounted) return;
    if (finished != null) {
      await context.push('/test-result', extra: finished);
      if (!mounted) return;
    }
    context.read<TestBloc>().add(const LoadMyTests());
  }

  Widget _buildTestCard(BuildContext context, TestResult test) {
    final palette = context.palette;
    final totalDuration =
        test.steps.fold<int>(0, (sum, s) => sum + s.duration);
    final hasAction = test.status != TestStatus.unknown;

    return GestureDetector(
      onTap: () async {
        await context.push('/test-detail', extra: test);
        if (context.mounted) {
          context.read<TestBloc>().add(const LoadMyTests());
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _IconTile(
              icon: Icons.assignment_outlined,
              color: AppColors.primaryBlue,
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
                    style: AppTextStyles.cardTitle
                        .copyWith(color: palette.textPrimary),
                  ),
                  if (test.description.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      test.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption
                          .copyWith(color: palette.textSecondary),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 4.h,
                    children: [
                      _Meta(
                        icon: Icons.list_alt_rounded,
                        text: '${test.steps.length} qadam',
                      ),
                      if (totalDuration > 0)
                        _Meta(
                          icon: Icons.timer_outlined,
                          text: '${totalDuration}s',
                        ),
                      if (test.score != null)
                        _Meta(
                          icon: Icons.stars_rounded,
                          text: '${test.score!.toStringAsFixed(1)} ball',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (hasAction) ...[
              SizedBox(width: 8.w),
              _ActionPill(
                label: switch (test.status) {
                  TestStatus.pending => 'Boshlash',
                  TestStatus.inProgress => 'Davom etish',
                  _ => 'Natija',
                },
                onTap: switch (test.status) {
                  TestStatus.pending => () => _openDetail(test),
                  TestStatus.inProgress => () => _resumeRun(test),
                  _ => () => context.push('/test-result', extra: test),
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Filtr chipi — tanlanganda to'ldirilgan, aks holda konturli.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : palette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Karta ichidagi 44x44 ikonka plitasi.
class _IconTile extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconTile({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.button.r),
      ),
      child: Icon(icon, size: 22.w, color: color),
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
          style: TextStyle(color: palette.textSecondary, fontSize: 11.sp),
        ),
      ],
    );
  }
}

/// Kartadagi kichik amal pilli (boshlash / davom etish / natija).
class _ActionPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyTests extends StatelessWidget {
  const _EmptyTests();

  @override
  Widget build(BuildContext context) {
    return const AppEmptyView(
      icon: Icons.assignment_outlined,
      title: 'Hozircha testlar yo\'q',
    );
  }
}
