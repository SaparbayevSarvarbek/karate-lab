import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/models/dashboard_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_hero_panel.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../../../core/widgets/dashboard_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../viewmodels/dashboard_bloc.dart';

class CoachDashboardView extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const CoachDashboardView({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()..add(LoadCoachDashboard()),
      child: _CoachDashboardContent(onSelectTab: onSelectTab),
    );
  }
}

class _CoachDashboardContent extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const _CoachDashboardContent({this.onSelectTab});

  Future<void> _reload(BuildContext context) async {
    final bloc = context.read<DashboardBloc>();
    bloc.add(LoadCoachDashboard());
    await bloc.stream.firstWhere(
      (s) => s is CoachDashboardLoaded || s is DashboardError,
    );
  }

  Future<void> _openAndReload(BuildContext context, String location) async {
    await context.push(location);
    if (!context.mounted) return;
    _reload(context);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: DashboardAppBar(
        fallbackName: 'Murabbiy',
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
                  ShimmerPlaceholder(
                    width: double.infinity,
                    height: 150.h,
                    borderRadius: BorderRadius.circular(AppRadius.panel.r),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Row(
                    children: [
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
                  ...List.generate(4, (_) => const ShimmerActionTile()),
                ],
              ),
            );
          }

          if (state is DashboardError) {
            return AppErrorView(
              message: state.message,
              retryLabel: Tr.t('retry'),
              onRetry: () =>
                  context.read<DashboardBloc>().add(LoadCoachDashboard()),
            );
          }

          if (state is CoachDashboardLoaded) {
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
                  _AthletesHero(data: state.data),
                  SizedBox(height: AppSpacing.md.h),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: AppStatCard(
                            label: Tr.t('tests'),
                            value: '${state.data.totalTests ?? 0}',
                            icon: Icons.assignment_rounded,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: AppStatCard(
                            label: Tr.t('exercises'),
                            value: '${state.data.totalExercises ?? 0}',
                            icon: Icons.fitness_center_rounded,
                            color: palette.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.sectionGap.h),
                  AppSectionHeader(title: Tr.t('quickActions')),
                  SizedBox(height: AppSpacing.md.h),
                  AppListTile(
                    icon: Icons.quiz_rounded,
                    iconColor: AppColors.primaryBlue,
                    title: Tr.t('newTest'),
                    subtitle: Tr.t('newTestSub'),
                    showChevron: true,
                    onTap: () => _openAndReload(context, '/create-test'),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppListTile(
                    icon: Icons.add_circle_outline_rounded,
                    iconColor: palette.success,
                    title: Tr.t('addExerciseAction'),
                    subtitle: Tr.t('addExerciseSub'),
                    showChevron: true,
                    onTap: () => _openAndReload(context, '/add-exercise'),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppListTile(
                    icon: Icons.auto_stories_rounded,
                    iconColor: palette.warning,
                    title: Tr.t('exerciseBase'),
                    subtitle: Tr.t('exerciseBaseSub'),
                    showChevron: true,
                    onTap: () => context.push('/mashqlar'),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppListTile(
                    icon: Icons.insights_rounded,
                    iconColor: AppColors.expert,
                    title: Tr.t('reportsMenu'),
                    subtitle: Tr.t('reportsSub'),
                    showChevron: true,
                    onTap: () => context.push(
                      '/reports',
                      extra: AppConstants.roleCoach,
                    ),
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

/// Jami sportchilar paneli.
class _AthletesHero extends StatelessWidget {
  final DashboardData data;

  const _AthletesHero({required this.data});

  @override
  Widget build(BuildContext context) {
    return AppHeroPanel(
      watermark: Icons.groups_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.t('totalAthletes'),
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            '${data.totalAthletes ?? 0}',
            style: AppTextStyles.stat.copyWith(
              fontSize: 36.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, size: 14.w, color: Colors.white),
                SizedBox(width: AppSpacing.xs.w),
                Text(
                  '${data.activeAthletes ?? 0} ${Tr.t('activeAthletesShort')}',
                  style: AppTextStyles.badge.copyWith(
                    color: Colors.white,
                    letterSpacing: 0,
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
