import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/models/dashboard_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_hero_panel.dart';
import '../../../../core/widgets/app_icon_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../../core/widgets/user_greeting_row.dart';
import '../viewmodels/dashboard_bloc.dart';

class AthleteDashboardView extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const AthleteDashboardView({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()..add(LoadAthleteDashboard()),
      child: _AthleteDashboardContent(onSelectTab: onSelectTab),
    );
  }
}

class _AthleteDashboardContent extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const _AthleteDashboardContent({this.onSelectTab});

  static const _testsTabIndex = 2;

  void _gotoTests() => onSelectTab?.call(_testsTabIndex);

  Future<void> _reload(BuildContext context) async {
    final bloc = context.read<DashboardBloc>();
    bloc.add(LoadAthleteDashboard());
    await bloc.stream.firstWhere(
      (s) => s is AthleteDashboardLoaded || s is DashboardError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: KarateAppBar(
        title: Tr.t('navHome'),
        showLogo: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/notification-settings'),
            tooltip: Tr.t('menuNotifications'),
            icon: Icon(
              Icons.notifications_none_rounded,
              color: palette.textPrimary,
              size: 22.w,
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return RefreshIndicator(
              onRefresh: () => _reload(context),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.screenTop.h,
                  AppSpacing.screenH.w,
                  AppSpacing.screenBottom.h,
                ),
                children: [
                  const UserGreetingRow(fallbackName: 'Sportchi'),
                  SizedBox(height: AppSpacing.xl.h),
                  ShimmerPlaceholder(
                    width: double.infinity,
                    height: 168.h,
                    borderRadius: BorderRadius.circular(AppRadius.panel.r),
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  Row(
                    children: [
                      Expanded(child: ShimmerDashboardStat()),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(child: ShimmerDashboardStat()),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(child: ShimmerDashboardStat()),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sectionGap.h),
                  ShimmerPlaceholder(
                    width: 130.w,
                    height: 20.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  ...List.generate(3, (_) => const ShimmerResultCard()),
                ],
              ),
            );
          }

          if (state is DashboardError) {
            return AppErrorView(
              message: state.message,
              retryLabel: Tr.t('retry'),
              onRetry: () => context
                  .read<DashboardBloc>()
                  .add(LoadAthleteDashboard()),
            );
          }

          if (state is AthleteDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () => _reload(context),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.screenTop.h,
                  AppSpacing.screenH.w,
                  AppSpacing.screenBottom.h,
                ),
                children: [
                  const UserGreetingRow(fallbackName: 'Sportchi'),
                  SizedBox(height: AppSpacing.xl.h),
                  _HeroCard(onStart: _gotoTests),
                  SizedBox(height: AppSpacing.xl.h),
                  _StatsRow(data: state.data),
                  SizedBox(height: AppSpacing.sectionGap.h),
                  AppSectionHeader(
                    title: Tr.t('myResults'),
                    actionLabel: Tr.t('all'),
                    actionIcon: Icons.arrow_forward_rounded,
                    onAction: _gotoTests,
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  _RecentResults(
                    data: state.data,
                    onTapResult: _gotoTests,
                  ),
                ],
              ),
            );
          }

          return const AppLoadingView();
        },
      ),
    );
  }
}

/// Bugungi maqsad kartasi — gradientli, brend belgisi bilan.
class _HeroCard extends StatelessWidget {
  final VoidCallback onStart;

  const _HeroCard({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return AppHeroPanel(
      watermark: Icons.sports_martial_arts_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: Text(
              Tr.t('todaysGoal'),
              style: AppTextStyles.badge.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            Tr.t('heroTests'),
            style: AppTextStyles.title.copyWith(color: Colors.white),
          ),
          SizedBox(height: 6.h),
          Text(
            'Mashqlarni bajaring, natijani kuzatib boring.',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          _HeroAction(label: Tr.t('startTests'), onTap: onStart),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HeroAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.button.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primaryNavy,
                size: 19.w,
              ),
              SizedBox(width: AppSpacing.xs.w),
              Text(
                label,
                style: AppTextStyles.button
                    .copyWith(color: AppColors.primaryNavy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final DashboardData data;

  const _StatsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppStatCard(
            label: Tr.t('avgScore'),
            value:
                data.avgScore == null ? '—' : data.avgScore!.toStringAsFixed(1),
            icon: Icons.speed_rounded,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: AppStatCard(
            label: Tr.t('activeDays'),
            value: '${data.activeDays ?? 0}',
            icon: Icons.local_fire_department_rounded,
            color: palette.warning,
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: AppStatCard(
            label: Tr.t('completed'),
            value: '${data.completedTests ?? 0}',
            icon: Icons.task_alt_rounded,
            color: palette.success,
          ),
        ),
      ],
    );
  }
}

class _RecentResults extends StatelessWidget {
  final DashboardData data;
  final VoidCallback onTapResult;

  const _RecentResults({required this.data, required this.onTapResult});

  @override
  Widget build(BuildContext context) {
    final results = data.recentTests ?? [];
    if (results.isEmpty) {
      return AppEmptyView(
        icon: Icons.assignment_outlined,
        title: Tr.t('noResults'),
        message: 'Birinchi testingizni boshlang va natijani shu yerda ko\'ring.',
        actionLabel: Tr.t('startTests'),
        onAction: onTapResult,
      );
    }
    return Column(
      children: [
        for (final result in results)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
            child: _ResultCard(result: result, onTap: onTapResult),
          ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final RecentTestResult result;
  final VoidCallback onTap;

  const _ResultCard({required this.result, required this.onTap});

  Color _scoreColor(AppPalette palette, double score) {
    if (score >= 85) return palette.success;
    if (score >= 70) return palette.warning;
    return palette.error;
  }

  String _dateLabel(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}.'
        '${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = _scoreColor(palette, result.score);
    final date = _dateLabel(result.completedAt);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          const AppIconTile(
            icon: Icons.verified_rounded,
            color: AppColors.primaryBlue,
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.testName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle
                      .copyWith(color: palette.textPrimary),
                ),
                if (date.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    date,
                    style: AppTextStyles.caption
                        .copyWith(color: palette.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          AppBadge(
            label: result.score.toStringAsFixed(1),
            color: color,
          ),
        ],
      ),
    );
  }
}
