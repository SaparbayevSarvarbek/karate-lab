import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/api/models/dashboard_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/profile_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardHeader(onSelectTab: onSelectTab),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading || state is DashboardInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DashboardError) {
                    return _ErrorState(
                      message: state.message,
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
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 90.h),
                        children: [
                          _HeroCard(onStart: () => _gotoTests(context)),
                          SizedBox(height: 18.h),
                          _StatsRow(data: state.data),
                          SizedBox(height: 22.h),
                          _SectionTitle(title: Tr.t('myResults')),
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

class _DashboardHeader extends StatelessWidget {
  final void Function(int)? onSelectTab;

  const _DashboardHeader({this.onSelectTab});

  String _timeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Tr.t('goodMorning');
    if (hour < 18) return Tr.t('goodDay');
    return Tr.t('goodEvening');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: FutureBuilder(
        future: getIt<ProfileRepository>().getProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data?.fold((_) => null, (p) => p);
          return Row(
            children: [
              AvatarImage(
                url: profile?.avatar,
                name: profile?.fullName ?? Tr.t('athlete'),
                size: 46,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_timeGreeting()},',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: palette.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      profile?.fullName ?? Tr.t('athlete'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  if (onSelectTab != null) onSelectTab!(3);
                },
                icon: Icon(Icons.notifications_none_rounded,
                    color: palette.textPrimary, size: 24.w),
              ),
            ],
          );
        },
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
          colors: [AppColors.primaryNavy, Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    Tr.t('todaysGoal'),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  Tr.t('heroTests'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 14.h),
                GestureDetector(
                  onTap: onStart,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
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
  final MyStatistics data;

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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 16.w),
          ),
          SizedBox(height: 10.h),
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
            style: TextStyle(color: palette.textSecondary, fontSize: 10.5.sp),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      title,
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
      ),
    );
  }
}

class _RecentResults extends StatelessWidget {
  final MyStatistics data;
  final VoidCallback onTapResult;

  const _RecentResults({required this.data, required this.onTapResult});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final results = data.recentTests;
    if (results.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 28.h),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 44.w, color: palette.textHint),
            SizedBox(height: 10.h),
            Text(
              Tr.t('noResults'),
              style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
            ),
          ],
        ),
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
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: palette.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.verified_rounded,
                  color: AppColors.primaryBlue, size: 20.w),
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
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56.w, color: palette.textHint),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(Tr.t('retry')),
            ),
          ],
        ),
      ),
    );
  }
}
