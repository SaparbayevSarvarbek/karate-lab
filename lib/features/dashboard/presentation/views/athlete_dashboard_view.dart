import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/api/models/dashboard_models.dart';
import '../../../../core/constants/app_colors.dart';
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

class AthleteDashboardView extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const AthleteDashboardView({Key? key, this.onSelectTab}) : super(key: key);

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

  void _gotoTests(BuildContext context) {
    if (onSelectTab != null) {
      onSelectTab!(2);
    }
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
                      onRefresh: () async => context
                          .read<DashboardBloc>()
                          .add(LoadAthleteDashboard()),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                        children: [
                          const UserGreetingRow(fallbackName: 'Sportchi'),
                          SizedBox(height: 20.h),
                          ShimmerPlaceholder(
                              width: double.infinity,
                              height: 160.h,
                              borderRadius: BorderRadius.circular(24.r)),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(child: ShimmerDashboardStat()),
                              SizedBox(width: 12.w),
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
                          ...List.generate(3, (index) => ShimmerResultCard()),
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
                      onRefresh: () async => context
                          .read<DashboardBloc>()
                          .add(LoadAthleteDashboard()),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                        children: [
                          const UserGreetingRow(fallbackName: 'Sportchi'),
                          SizedBox(height: 20.h),
                          _HeroCard(onStart: () => _gotoTests(context)),
                          SizedBox(height: 20.h),
                          _StatsRow(data: state.data),
                          SizedBox(height: 24.h),
                          AppSectionHeader(title: Tr.t('myResults')),
                          SizedBox(height: 12.h),
                          _RecentResults(
                            data: state.data,
                            onTapResult: () => _gotoTests(context),
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

class _HeroCard extends StatelessWidget {
  final VoidCallback onStart;

  const _HeroCard({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.pill.r),
                  ),
                  child: Text(
                    Tr.t('todaysGoal'),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  Tr.t('heroTests'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Mashqlarni bajaring, natijani kuzatib boring.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: onStart,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.button.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded,
                            color: AppColors.primaryNavy, size: 18.w),
                        SizedBox(width: 4.w),
                        Text(
                          Tr.t('startTests'),
                          style: TextStyle(
                            color: AppColors.primaryNavy,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.sports_martial_arts_rounded,
              size: 72.w, color: Colors.white.withValues(alpha: 0.28)),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final DashboardData data;

  const _StatsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            title: Tr.t('avgScore'),
            value: data.avgScore == null ? '—' : data.avgScore!.toStringAsFixed(1),
            icon: Icons.speed_rounded,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatBox(
            title: Tr.t('activeDays'),
            value: '${data.activeDays ?? 0}',
            icon: Icons.local_fire_department_rounded,
            color: AppColors.warning,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatBox(
            title: Tr.t('completed'),
            value: '${data.completedTests ?? 0}',
            icon: Icons.task_alt_rounded,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
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
            padding: EdgeInsets.only(bottom: 10.h),
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

  Color _scoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.warning;
    return AppColors.error;
  }

  String _dateLabel(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = _scoreColor(result.score);
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
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.verified_rounded,
                  color: AppColors.primaryBlue, size: 22.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.testName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_dateLabel(result.completedAt).isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      _dateLabel(result.completedAt),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
              ),
              child: Text(
                result.score.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
