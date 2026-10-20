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
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
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

enum _TestFilter { all, pending, inProgress, completed }

class _TestsLibraryViewState extends State<TestsLibraryView> {
  bool get _isCoach => widget.userRole == AppConstants.roleCoach;

  final _searchController = TextEditingController();
  String _query = '';

  _TestFilter _filter = _TestFilter.all;
  String _category = 'all';

  List<AppChipItem<String>> get _coachCategories => [
    AppChipItem(value: 'all', label: Tr.t('all')),
    AppChipItem(value: 'Texnik', label: Tr.categoryName('Texnik')),
    AppChipItem(value: 'UJT', label: Tr.categoryName('UJT')),
    AppChipItem(value: 'MJT', label: Tr.categoryName('MJT')),
  ];

  List<AppChipItem<_TestFilter>> get _statusFilters => [
    AppChipItem(value: _TestFilter.all, label: Tr.t('all')),
    AppChipItem(value: _TestFilter.pending, label: Tr.t('testStatusPending')),
    AppChipItem(
      value: _TestFilter.inProgress,
      label: Tr.t('testStatusInProgress'),
    ),
    AppChipItem(
      value: _TestFilter.completed,
      label: Tr.t('testStatusCompleted'),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload(BuildContext context) => context.read<TestBloc>().add(
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.screenTop.h,
                  AppSpacing.screenH.w,
                  AppSpacing.md.h,
                ),
                child: AppSearchField(
                  hint: Tr.t('searchTestHint'),
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
              if (_isCoach)
                AppFilterChips<String>(
                  items: _coachCategories,
                  selected: _category,
                  onSelected: (v) => setState(() => _category = v),
                )
              else
                AppFilterChips<_TestFilter>(
                  items: _statusFilters,
                  selected: _filter,
                  onSelected: (v) => setState(() => _filter = v),
                ),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
          floatingActionButton: _isCoach
              ? AppFab(
                  label: Tr.t('test'),
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
    AppSpacing.md.h,
    AppSpacing.screenH.w,
    _isCoach ? 96.h : AppSpacing.screenBottom.h,
  );

  Widget _buildBody(BuildContext context, TestState state) {
    if (state is TestLoading) {
      return RefreshIndicator(
        onRefresh: () async => _reload(context),
        child: ListView(
          padding: _listPadding,
          children: List.generate(
            5,
            (_) => _isCoach
                ? const ShimmerCoachTestCard()
                : const ShimmerTestResultCard(),
          ),
        ),
      );
    }

    if (state is TestError) {
      return AppErrorView(
        message: state.message,
        retryLabel: Tr.t('retry'),
        onRetry: () => _reload(context),
      );
    }

    if (state is CoachTestsLoaded) {
      final tests = state.tests.where(_matchesCoach).toList();
      return RefreshIndicator(
        onRefresh: () async => _reload(context),
        child: ListView(
          padding: _listPadding,
          children: [
            if (tests.isEmpty)
              _emptyState(Tr.t('noTests'))
            else
              for (final test in tests) ...[
                _CoachTestCard(
                  test: test,
                  onTap: () async {
                    await context.push('/test-detail', extra: test);
                    if (context.mounted) _reload(context);
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
              ],
          ],
        ),
      );
    }

    if (state is MyTestsLoaded) {
      final tests = state.tests.where(_matchesAthlete).toList();
      return RefreshIndicator(
        onRefresh: () async => _reload(context),
        child: ListView(
          padding: _listPadding,
          children: [
            if (tests.isEmpty)
              _emptyState(Tr.t('noSearchResult'))
            else
              for (final test in tests) ...[
                _AthleteTestCard(
                  test: test,
                  onTap: () async {
                    await context.push('/test-detail', extra: test);
                    if (context.mounted) _reload(context);
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

  bool _matchesCoach(TestEntity test) {
    if (_category != 'all' &&
        Tr.categoryKey(test.category) != Tr.categoryKey(_category)) {
      return false;
    }
    return _matchesQuery(test.name);
  }

  bool _matchesAthlete(TestResult test) {
    final statusOk = switch (_filter) {
      _TestFilter.all => true,
      _TestFilter.pending => test.status == TestStatus.pending,
      _TestFilter.inProgress => test.status == TestStatus.inProgress,
      _TestFilter.completed => test.status == TestStatus.completed,
    };
    return statusOk && _matchesQuery(test.name);
  }

  bool _matchesQuery(String name) =>
      _query.isEmpty || name.toLowerCase().contains(_query.toLowerCase());

  Widget _emptyState(String title) => AppEmptyView(
    icon: Icons.assignment_outlined,
    title: title,
    message: _query.isNotEmpty || _category != 'all'
        ? Tr.t('noTestsMatch')
        : null,
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
        return (Tr.t('testStatusStart'), palette.info);
      case TestStatus.inProgress:
        return (Tr.t('testStatusContinue'), palette.warning);
      case TestStatus.completed:
        return (Tr.t('testStatusCompleted'), palette.success);
      case TestStatus.unknown:
        return (Tr.t('testStatusResult'), palette.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final totalDuration = test.steps.fold<int>(0, (sum, s) => sum + s.duration);
    final (label, color) = _statusVisual(palette);

    return AppListTile(
      leading: test.hasCover
          ? RemoteImage(
              url: test.coverUrl,
              width: 44.w,
              height: 44.h,
              borderRadius: BorderRadius.circular(12.r),
              fallbackIcon: Icons.assignment_rounded,
            )
          : null,
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

/// Murabbiy uchun test kartasi; bosilganda test tafsilotlarini ochadi.
class _CoachTestCard extends StatelessWidget {
  final TestEntity test;
  final VoidCallback onTap;

  const _CoachTestCard({required this.test, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: test.hasCover
          ? RemoteImage(
              url: test.coverUrl,
              width: 44.w,
              height: 44.h,
              borderRadius: BorderRadius.circular(12.r),
              fallbackIcon: Icons.assignment_rounded,
            )
          : null,
      icon: Icons.assignment_rounded,
      iconColor: AppColors.primaryBlue,
      title: test.name,
      subtitle: test.description.isEmpty ? null : test.description,
      onTap: onTap,
      showChevron: true,
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
            AppMeta(
              icon: Icons.category_outlined,
              text: Tr.categoryName(test.category),
            ),
        ],
      ),
    );
  }
}
