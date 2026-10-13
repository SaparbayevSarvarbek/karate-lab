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
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/app_filter_chips.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
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

enum _TestFilter { all, pending, inProgress, completed, active, inactive }

class _TestsLibraryViewState extends State<TestsLibraryView> {
  bool get _isCoach => widget.userRole == AppConstants.roleCoach;

  _TestFilter _filter = _TestFilter.all;

  List<AppChipItem<_TestFilter>> get _filters => _isCoach
      ? const [
          AppChipItem(value: _TestFilter.all, label: 'Barchasi'),
          AppChipItem(value: _TestFilter.active, label: 'Faol'),
          AppChipItem(value: _TestFilter.inactive, label: 'Nofaol'),
        ]
      : const [
          AppChipItem(value: _TestFilter.all, label: 'Barchasi'),
          AppChipItem(value: _TestFilter.pending, label: 'Boshlanmagan'),
          AppChipItem(value: _TestFilter.inProgress, label: 'Jarayonda'),
          AppChipItem(value: _TestFilter.completed, label: 'Bajarilgan'),
        ];

  void _reload() => context.read<TestBloc>().add(
        _isCoach ? const LoadCoachTests() : const LoadMyTests(),
      );

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocProvider(
      create: (_) {
        final bloc = getIt<TestBloc>();
        bloc.add(_isCoach ? const LoadCoachTests() : const LoadMyTests());
        return bloc;
      },
      child: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) => Scaffold(
          backgroundColor: palette.background,
          appBar: KarateAppBar(title: Tr.t('navTests'), showLogo: true),
          body: _buildBody(context, state),
          floatingActionButton: _isCoach
              ? AppFab(
                  label: 'Test',
                  onPressed: () async {
                    final created = await context.push('/create-test');
                    if (created == true && context.mounted) {
                      context.read<TestBloc>().add(const LoadCoachTests());
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  EdgeInsets get _listPadding => EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.screenTop.h,
        AppSpacing.screenH.w,
        _isCoach ? 96.h : AppSpacing.screenBottom.h,
      );

  Widget _buildBody(BuildContext context, TestState state) {
    if (state is TestLoading) {
      return RefreshIndicator(
        onRefresh: () async => _reload(),
        child: ListView(
          padding: _listPadding,
          children: [
            _filterBar(),
            SizedBox(height: AppSpacing.lg.h),
            ...List.generate(
              5,
              (_) => _isCoach
                  ? const ShimmerCoachTestCard()
                  : const ShimmerTestResultCard(),
            ),
          ],
        ),
      );
    }

    if (state is TestError) {
      return AppErrorView(
        message: state.message,
        retryLabel: Tr.t('retry'),
        onRetry: _reload,
      );
    }

    if (state is CoachTestsLoaded) {
      final tests = state.tests.where(_matchesCoachFilter).toList();
      return RefreshIndicator(
        onRefresh: () async => _reload(),
        child: ListView(
          padding: _listPadding,
          children: [
            _filterBar(),
            SizedBox(height: AppSpacing.lg.h),
            if (tests.isEmpty)
              _emptyState('Testlar yo\'q')
            else
              for (final test in tests) ...[
                _CoachTestCard(test: test),
                SizedBox(height: AppSpacing.md.h),
              ],
          ],
        ),
      );
    }

    if (state is MyTestsLoaded) {
      final tests = state.tests.where(_matchesAthleteFilter).toList();
      return RefreshIndicator(
        onRefresh: () async => _reload(),
        child: ListView(
          padding: _listPadding,
          children: [
            _filterBar(),
            SizedBox(height: AppSpacing.lg.h),
            if (tests.isEmpty)
              _emptyState(Tr.t('noSearchResult'))
            else
              for (final test in tests) ...[
                _AthleteTestCard(
                  test: test,
                  onTap: () async {
                    await context.push('/test-detail', extra: test);
                    if (context.mounted) _reload();
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
              ],
          ],
        ),
      );
    }

    return const AppLoadingView();
  }

  bool _matchesCoachFilter(TestEntity test) {
    switch (_filter) {
      case _TestFilter.active:
        return test.isActive;
      case _TestFilter.inactive:
        return !test.isActive;
      default:
        return true;
    }
  }

  bool _matchesAthleteFilter(TestResult test) {
    switch (_filter) {
      case _TestFilter.pending:
        return test.status == TestStatus.pending;
      case _TestFilter.inProgress:
        return test.status == TestStatus.inProgress;
      case _TestFilter.completed:
        return test.status == TestStatus.completed;
      default:
        return true;
    }
  }

  Widget _filterBar() => AppFilterChips<_TestFilter>(
        items: _filters,
        selected: _filter,
        onSelected: (v) => setState(() => _filter = v),
        padding: EdgeInsets.zero,
      );

  Widget _emptyState(String title) => AppEmptyView(
        icon: Icons.assignment_outlined,
        title: title,
        message: _filter == _TestFilter.all
            ? null
            : 'Bu bo\'limda hozircha test yo\'q.',
      );
}

/// Sportchi uchun test kartasi: holat nishoni + meta.
class _AthleteTestCard extends StatelessWidget {
  final TestResult test;
  final VoidCallback onTap;

  const _AthleteTestCard({required this.test, required this.onTap});

  (String, Color) _statusVisual(AppPalette palette) {
    switch (test.status) {
      case TestStatus.pending:
        return ('Boshlash', palette.info);
      case TestStatus.inProgress:
        return ('Davom etish', palette.warning);
      case TestStatus.completed:
        return ('Bajarildi', palette.success);
      case TestStatus.unknown:
        return ('Natija', palette.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final totalDuration = test.steps.fold<int>(0, (sum, s) => sum + s.duration);
    final (label, color) = _statusVisual(palette);

    return AppListTile(
      icon: Icons.assignment_rounded,
      iconColor: AppColors.primaryBlue,
      title: test.name,
      subtitle: test.description.isEmpty ? null : test.description,
      showChevron: true,
      onTap: onTap,
      footer: AppMetaRow(
        items: [
          AppMeta(
            icon: Icons.list_alt_rounded,
            text: '${test.steps.length} ${Tr.t('steps')}',
          ),
          if (totalDuration > 0)
            AppMeta(
              icon: Icons.timer_outlined,
              text: '$totalDuration${Tr.t('seconds')}',
            ),
          if (test.score != null)
            AppMeta(
              icon: Icons.stars_rounded,
              text: '${test.score!.toStringAsFixed(1)} ${Tr.t('points')}',
              color: color,
            ),
        ],
      ),
      trailing: AppBadge(label: label, color: color),
    );
  }
}

/// Murabbiy uchun test kartasi: faol/nofaol nishoni.
class _CoachTestCard extends StatelessWidget {
  final TestEntity test;

  const _CoachTestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppListTile(
      icon: Icons.assignment_rounded,
      iconColor: AppColors.primaryBlue,
      title: test.name,
      subtitle: test.description.isEmpty ? null : test.description,
      footer: AppMetaRow(
        items: [
          AppMeta(
            icon: Icons.list_alt_rounded,
            text: '${test.steps.length} ${Tr.t('steps')}',
          ),
          if (test.totalDuration > 0)
            AppMeta(
              icon: Icons.timer_outlined,
              text: '${test.totalDuration}${Tr.t('seconds')}',
            ),
          if (test.category.isNotEmpty)
            AppMeta(icon: Icons.category_outlined, text: test.category),
        ],
      ),
      trailing: AppBadge(
        label: test.isActive ? Tr.t('active') : Tr.t('inactive'),
        color: test.isActive ? palette.success : palette.textSecondary,
        icon: test.isActive
            ? Icons.check_circle_rounded
            : Icons.pause_circle_rounded,
      ),
    );
  }
}
