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

  static const _coachCategories = <AppChipItem<String>>[
    AppChipItem(value: 'all', label: 'Barchasi'),
    AppChipItem(value: 'Texnik', label: 'Texnik'),
    AppChipItem(value: 'UJT', label: 'UJT'),
    AppChipItem(value: 'MJT', label: 'MJT'),
  ];

  static const _statusFilters = <AppChipItem<_TestFilter>>[
    AppChipItem(value: _TestFilter.all, label: 'Barchasi'),
    AppChipItem(value: _TestFilter.pending, label: 'Boshlanmagan'),
    AppChipItem(value: _TestFilter.inProgress, label: 'Jarayonda'),
    AppChipItem(value: _TestFilter.completed, label: 'Bajarilgan'),
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
              _emptyState('Testlar yo\'q')
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
        test.category.toLowerCase() != _category.toLowerCase()) {
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
            ? 'Bu shartlarga mos test topilmadi.'
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

/// Murabbiy uchun test kartasi; bosilganda test tafsilotlarini ochadi.
class _CoachTestCard extends StatelessWidget {
  final TestEntity test;
  final VoidCallback onTap;

  const _CoachTestCard({required this.test, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppListTile(
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
            AppMeta(icon: Icons.category_outlined, text: test.category),
        ],
      ),
    );
  }
}
