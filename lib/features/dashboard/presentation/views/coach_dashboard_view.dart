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
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../../../../core/widgets/user_greeting_row.dart';
import '../viewmodels/dashboard_bloc.dart';

class CoachDashboardView extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const CoachDashboardView({Key? key, this.onSelectTab}) : super(key: key);

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
      appBar: KarateAppBar(
        title: Tr.t('navDashboard'),
        showLogo: true,
        actions: [
          IconButton(
            onPressed: () => onSelectTab?.call(3),
            icon: Icon(
              Icons.notifications_none_rounded,
              color: palette.textPrimary,
              size: 24.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading || state is DashboardInitial) {
                    return RefreshIndicator(
                      onRefresh: () => _reload(context),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                        children: [
                          const UserGreetingRow(fallbackName: 'Murabbiy'),
                          SizedBox(height: 20.h),
                          ShimmerPlaceholder(
                            width: double.infinity,
                            height: 180.h,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(child: ShimmerDashboardStat()),
                              SizedBox(width: 12.w),
                              Expanded(child: ShimmerDashboardStat()),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          ShimmerPlaceholder(
                              width: 120.w,
                              height: 22.h,
                              borderRadius: BorderRadius.circular(11.r)),
                          SizedBox(height: 12.h),
                          ...List.generate(4, (index) => ShimmerActionTile()),
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
                          .add(LoadCoachDashboard()),
                    );
                  }

                  if (state is CoachDashboardLoaded) {
                    return RefreshIndicator(
                      onRefresh: () => _reload(context),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                        children: [
                          const UserGreetingRow(fallbackName: 'Murabbiy'),
                          SizedBox(height: 20.h),
                          _StatsGrid(data: state.data),
                          SizedBox(height: 24.h),
                          AppSectionHeader(title: Tr.t('quickActions')),
                          SizedBox(height: 12.h),
                          _ActionTile(
                            title: Tr.t('newTest'),
                            subtitle: Tr.t('newTestSub'),
                            icon: Icons.quiz_rounded,
                            color: AppColors.primaryBlue,
                            onTap: () => _openAndReload(context, '/create-test'),
                          ),
                          SizedBox(height: 12.h),
                          _ActionTile(
                            title: Tr.t('addExerciseAction'),
                            subtitle: Tr.t('addExerciseSub'),
                            icon: Icons.add_circle_outline_rounded,
                            color: AppColors.success,
                            onTap: () => _openAndReload(context, '/add-exercise'),
                          ),
                          SizedBox(height: 12.h),
                          _ActionTile(
                            title: Tr.t('exerciseBase'),
                            subtitle: Tr.t('exerciseBaseSub'),
                            icon: Icons.auto_stories_rounded,
                            color: AppColors.warning,
                            onTap: () => context.push('/mashqlar'),
                          ),
                          SizedBox(height: 12.h),
                          _ActionTile(
                            title: Tr.t('reportsMenu'),
                            subtitle: Tr.t('reportsSub'),
                            icon: Icons.insights_rounded,
                            color: AppColors.expert,
                            onTap: () => context.push(
                              '/reports',
                              extra: AppConstants.roleCoach,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DashboardData data;

  const _StatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryNavy, AppColors.gradientDeepBlue],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Tr.t('totalAthletes'),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${data.totalAthletes ?? 0}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppRadius.pill.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt_rounded,
                              size: 13.w, color: Colors.white),
                          SizedBox(width: 4.w),
                          Text(
                            '${data.activeAthletes ?? 0} ${Tr.t('activeAthletesShort')}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.groups_rounded,
                  size: 64.w,
                  color: Colors.white.withValues(alpha: 0.28)),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                title: Tr.t('tests'),
                value: '${data.totalTests ?? 0}',
                icon: Icons.assignment_rounded,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _MiniStat(
                title: Tr.t('exercises'),
                value: '${data.totalExercises ?? 0}',
                icon: Icons.fitness_center_rounded,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 16.w),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.textSecondary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: color, size: 22.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: palette.textHint, size: 22.w),
          ],
        ),
      ),
    );
  }
}
