import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/analytics_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../viewmodels/analytics_bloc.dart';

/// Hisobot va tahlillar.
///
/// - Sportchi: `GET /athlete/statistics/`
/// - Murabbiy: `GET /coach/statistics/`
class ReportsAnalyticsView extends StatelessWidget {
  final String? userRole;

  const ReportsAnalyticsView({super.key, this.userRole});

  bool get _isCoach => userRole == AppConstants.roleCoach;

  AnalyticsEvent get _loadEvent =>
      _isCoach ? const LoadCoachStatistics() : const LoadAthleteStatistics();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnalyticsBloc>()..add(_loadEvent),
      child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.background,
            appBar: KarateAppBar(
              title: Tr.t('reportsTitle'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  color: context.palette.textPrimary,
                  onPressed: () =>
                      context.read<AnalyticsBloc>().add(_loadEvent),
                ),
              ],
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AnalyticsState state) {
    if (state is AnalyticsInitial || state is AnalyticsLoading) {
      return const AppLoadingView();
    }

    if (state is AnalyticsError) {
      return AppErrorView(
        message: state.message,
        retryLabel: Tr.t('retry'),
        onRetry: () => context.read<AnalyticsBloc>().add(_loadEvent),
      );
    }

    if (state is CoachStatisticsLoaded) {
      return _CoachReport(stats: state.statistics);
    }

    if (state is AthleteStatisticsLoaded) {
      return _AthleteReport(stats: state.statistics);
    }

    return const SizedBox.shrink();
  }
}

class _AthleteReport extends StatelessWidget {
  final AthleteStatistics stats;

  const _AthleteReport({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.screenTop.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportsSummaryRow(
            items: [
              ReportsSummaryItem(
                label: Tr.t('avgScore'),
                value: _formatScore(stats.averageScore),
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
              ReportsSummaryItem(
                label: Tr.t('reportsSuccessRate'),
                value: '${stats.successRate.toStringAsFixed(0)}%',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.primaryBlue,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('reportsTrend')),
          SizedBox(height: AppSpacing.md.h),
          ReportsTrendChartCard(points: stats.scoreOverTime),
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('reportsByTest')),
          SizedBox(height: AppSpacing.md.h),
          ReportsMetricListCard(items: stats.testPerformance),
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('reportsRecent')),
          SizedBox(height: AppSpacing.md.h),
          _RecentResultsCard(results: stats.recentResults),
        ],
      ),
    );
  }
}

class _CoachReport extends StatelessWidget {
  final CoachStatistics stats;

  const _CoachReport({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.screenTop.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportsSummaryRow(
            items: [
              ReportsSummaryItem(
                label: Tr.t('totalAthletes'),
                value: '${stats.totalAthletes}',
                icon: Icons.people_alt_rounded,
                color: AppColors.primaryBlue,
              ),
              ReportsSummaryItem(
                label: Tr.t('avgScore'),
                value: _formatScore(stats.averageScore),
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('reportsTrend')),
          SizedBox(height: AppSpacing.md.h),
          ReportsTrendChartCard(points: stats.scoreOverTime),
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('reportsDistribution')),
          SizedBox(height: AppSpacing.md.h),
          ReportsMetricListCard(items: stats.performanceDistribution),
          SizedBox(height: AppSpacing.sectionGap.h),
          AppSectionHeader(title: Tr.t('reportsRanking')),
          SizedBox(height: AppSpacing.md.h),
          ReportsRankingList(items: stats.athletesPerformance),
        ],
      ),
    );
  }
}

String _formatScore(double? value) =>
    value == null ? '—' : value.toStringAsFixed(1);

/// Natija qiymatiga qarab sifat darajasi (karta izohi uchun).
String _scoreBand(double value) {
  if (value >= 7) return 'Yuqori';
  if (value >= 4) return "O'rta";
  return 'Past';
}

/// Qiymatga qarab holat rangi (matn/badge uchun WCAG-AA variantlari).
Color _scoreColor(AppPalette palette, double value) {
  if (value >= 7) return palette.success;
  if (value >= 4) return palette.warning;
  return palette.error;
}

class ReportsSummaryItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const ReportsSummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class ReportsSummaryRow extends StatelessWidget {
  final List<ReportsSummaryItem> items;

  const ReportsSummaryRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: ReportsSummaryCard(
              label: items[i].label,
              value: items[i].value,
              icon: items[i].icon,
              color: items[i].color,
            ),
          ),
        ],
      ],
    );
  }
}

class ReportsSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const ReportsSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.stat.copyWith(color: palette.textPrimary),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
          SizedBox(height: AppSpacing.md.h),
          AppIconTile(icon: icon, color: color, size: 28, radius: AppRadius.xs),
        ],
      ),
    );
  }
}

class ReportsTrendChartCard extends StatelessWidget {
  final List<DataPoint> points;

  const ReportsTrendChartCard({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return AppEmptyView(
        icon: Icons.bar_chart_rounded,
        title: Tr.t('reportsNoData'),
        compact: true,
      );
    }

    return AppCard(
      child: SizedBox(
        height: 180.h,
        child: Column(
          children: [
            const ReportsChartLegendRow(),
            SizedBox(height: AppSpacing.md.h),
            Expanded(
              child: CustomPaint(
                painter: _TrendChartPainter(points),
                size: Size.infinite,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReportsChartLabelsRow(points: points),
          ],
        ),
      ),
    );
  }
}

class ReportsChartLegendRow extends StatelessWidget {
  const ReportsChartLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        const ReportsLegendDot(color: AppColors.primaryBlue),
        SizedBox(width: AppSpacing.sm.w),
        Text(
          Tr.t('avgScore'),
          style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}

class ReportsLegendDot extends StatelessWidget {
  final Color color;

  const ReportsLegendDot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class ReportsChartLabelsRow extends StatelessWidget {
  final List<DataPoint> points;

  const ReportsChartLabelsRow({super.key, required this.points});

  /// Backend `YYYY-MM` ko'rinishida yuboradi → `MM.YY` ga qisqartiradi.
  String _shortLabel(String label) {
    final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(label);
    if (match == null) return label;
    return '${match.group(2)}.${match.group(1)!.substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final labels = points.length > 5
        ? [
            points.first.label,
            points[points.length ~/ 2].label,
            points.last.label,
          ]
        : points.map((p) => p.label).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final label in labels)
          Text(
            _shortLabel(label),
            style: AppTextStyles.caption.copyWith(color: palette.textHint),
          ),
      ],
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<DataPoint> points;

  _TrendChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final values = points.map((p) => p.value).toList();
    var minValue = values.reduce(math.min);
    var maxValue = values.reduce(math.max);
    if (maxValue - minValue < 1) {
      minValue = math.max(0, minValue - 5);
      maxValue = math.min(100, maxValue + 5);
    }
    final range = (maxValue - minValue) == 0 ? 1.0 : (maxValue - minValue);

    const padding = 6.0;
    final usableWidth = size.width - padding * 2;
    final stepX = points.length > 1 ? usableWidth / (points.length - 1) : 0.0;
    final startX = points.length > 1 ? padding : size.width / 2;

    final offsets = <Offset>[
      for (var i = 0; i < points.length; i++)
        Offset(
          startX + stepX * i,
          padding +
              (size.height - padding * 2) *
                  (1 - (points[i].value - minValue) / range),
        ),
    ];

    final linePaint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (offsets.length > 1) {
      final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
      for (final point in offsets.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    final dotPaint = Paint()..color = AppColors.primaryBlue;
    for (final point in offsets) {
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class ReportsMetricListCard extends StatelessWidget {
  final List<DataPoint> items;

  const ReportsMetricListCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    if (items.isEmpty) {
      return AppEmptyView(
        icon: Icons.bar_chart_rounded,
        title: Tr.t('reportsNoData'),
        compact: true,
      );
    }

    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(height: AppSpacing.xxl.h, color: palette.divider),
            ReportsMetricRow(label: items[i].label, value: items[i].value),
          ],
        ],
      ),
    );
  }
}

class ReportsMetricRow extends StatelessWidget {
  final String label;
  final double value;

  const ReportsMetricRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        const AppIconTile(
          icon: Icons.insights_rounded,
          color: AppColors.primaryBlue,
          size: 40,
          radius: AppRadius.tile,
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xxs.h),
              Text(
                _scoreBand(value),
                style: AppTextStyles.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        _ScoreBadge(value: value),
      ],
    );
  }
}

/// Qiymatga qarab rang oladigan ball badge'i.
class _ScoreBadge extends StatelessWidget {
  final double value;

  const _ScoreBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: value.toStringAsFixed(1),
      color: _scoreColor(context.palette, value),
    );
  }
}

class _RecentResultsCard extends StatelessWidget {
  final List<RecentResult> results;

  const _RecentResultsCard({required this.results});

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    if (results.isEmpty) {
      return AppEmptyView(
        icon: Icons.bar_chart_rounded,
        title: Tr.t('noResults'),
        compact: true,
      );
    }

    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < results.length; i++) ...[
            if (i > 0)
              Divider(height: AppSpacing.xxl.h, color: palette.divider),
            Row(
              children: [
                const AppIconTile(
                  icon: Icons.assignment_turned_in_rounded,
                  color: AppColors.primaryBlue,
                  size: 40,
                  radius: AppRadius.tile,
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        results[i].testName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxs.h),
                      Text(
                        _formatDate(results[i].completedAt),
                        style: AppTextStyles.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                _ScoreBadge(value: results[i].score),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ReportsRankingList extends StatelessWidget {
  final List<DataPoint> items;

  const ReportsRankingList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AppEmptyView(
        icon: Icons.bar_chart_rounded,
        title: Tr.t('reportsNoData'),
        compact: true,
      );
    }

    final sorted = [...items]..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        for (var i = 0; i < sorted.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.md.h),
          ReportsRankingItem(
            rank: i + 1,
            name: sorted[i].label,
            score: sorted[i].value,
          ),
        ],
      ],
    );
  }
}

class ReportsRankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final double score;

  const ReportsRankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const medalColors = [
      AppColors.medalGold,
      AppColors.medalSilver,
      AppColors.medalBronze,
    ];
    final medalColor = rank <= 3 ? medalColors[rank - 1] : palette.textHint;
    final isTop = rank == 1;

    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      tone: isTop ? AppColors.medalGold.withValues(alpha: 0.08) : null,
      borderColor: isTop ? AppColors.medalGold.withValues(alpha: 0.4) : null,
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: medalColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$rank',
              style: AppTextStyles.badge.copyWith(
                color: Colors.white,
                letterSpacing: 0,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.cardTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          _ScoreBadge(value: score),
        ],
      ),
    );
  }
}
