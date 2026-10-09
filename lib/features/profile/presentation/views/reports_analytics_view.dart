import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/models/analytics_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../viewmodels/analytics_bloc.dart';

/// Hisobot va tahlillar.
///
/// - Sportchi: `GET /athlete/statistics/`
/// - Murabbiy: `GET /coach/statistics/`
class ReportsAnalyticsView extends StatelessWidget {
  final String? userRole;

  const ReportsAnalyticsView({super.key, this.userRole});

  bool get _isCoach => userRole == AppConstants.roleCoach;

  AnalyticsEvent get _loadEvent => _isCoach
      ? const LoadCoachStatistics()
      : const LoadAthleteStatistics();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnalyticsBloc>()..add(_loadEvent),
      child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(Tr.t('reportsTitle')),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () => context.read<AnalyticsBloc>().add(_loadEvent),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AnalyticsError) {
      return _ErrorState(
        message: state.message,
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56, color: palette.textHint),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: onRetry, child: Text(Tr.t('retry'))),
          ],
        ),
      ),
    );
  }
}

class _AthleteReport extends StatelessWidget {
  final AthleteStatistics stats;

  const _AthleteReport({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportsSummaryRow(
            items: [
              ReportsSummaryItem(
                label: Tr.t('avgScore'),
                value: _formatScore(stats.averageScore),
                icon: Icons.trending_up,
                color: AppColors.success,
              ),
              ReportsSummaryItem(
                label: Tr.t('reportsSuccessRate'),
                value: '${stats.successRate.toStringAsFixed(0)}%',
                icon: Icons.check_circle_outline,
                color: AppColors.primaryBlue,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ReportsSectionTitle(title: Tr.t('reportsTrend')),
          const SizedBox(height: 16),
          ReportsTrendChartCard(points: stats.scoreOverTime),
          const SizedBox(height: 24),
          ReportsSectionTitle(title: Tr.t('reportsByTest')),
          const SizedBox(height: 16),
          ReportsMetricListCard(items: stats.testPerformance),
          const SizedBox(height: 24),
          ReportsSectionTitle(title: Tr.t('reportsRecent')),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportsSummaryRow(
            items: [
              ReportsSummaryItem(
                label: Tr.t('totalAthletes'),
                value: '${stats.totalAthletes}',
                icon: Icons.people,
                color: AppColors.primaryBlue,
              ),
              ReportsSummaryItem(
                label: Tr.t('avgScore'),
                value: _formatScore(stats.averageScore),
                icon: Icons.trending_up,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ReportsSectionTitle(title: Tr.t('reportsTrend')),
          const SizedBox(height: 16),
          ReportsTrendChartCard(points: stats.scoreOverTime),
          const SizedBox(height: 24),
          ReportsSectionTitle(title: Tr.t('reportsDistribution')),
          const SizedBox(height: 16),
          ReportsMetricListCard(items: stats.performanceDistribution),
          const SizedBox(height: 24),
          ReportsSectionTitle(title: Tr.t('reportsRanking')),
          const SizedBox(height: 16),
          ReportsRankingList(items: stats.athletesPerformance),
        ],
      ),
    );
  }
}

String _formatScore(double? value) =>
    value == null ? '—' : value.toStringAsFixed(1);

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
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ReportsSectionTitle extends StatelessWidget {
  final String title;

  const ReportsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          Icon(Icons.insights_outlined, size: 36, color: context.palette.textHint),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
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
      return _EmptyCard(Tr.t('reportsNoData'));
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          const ReportsChartLegendRow(),
          const SizedBox(height: 12),
          Expanded(
            child: CustomPaint(
              painter: _TrendChartPainter(points),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          ReportsChartLabelsRow(points: points),
        ],
      ),
    );
  }
}

class ReportsChartLegendRow extends StatelessWidget {
  const ReportsChartLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ReportsLegendDot(color: AppColors.primaryBlue),
        const SizedBox(width: 6),
        Text(
          Tr.t('avgScore'),
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
      width: 8,
      height: 8,
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
            style: const TextStyle(fontSize: 11, color: AppColors.textHint),
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
    if (items.isEmpty) {
      return _EmptyCard(Tr.t('reportsNoData'));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 24),
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
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value.toStringAsFixed(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
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
    if (results.isEmpty) {
      return _EmptyCard(Tr.t('noResults'));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < results.length; i++) ...[
            if (i > 0) const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        results[i].testName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _formatDate(results[i].completedAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  results[i].score.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primaryBlue,
                  ),
                ),
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
      return _EmptyCard(Tr.t('reportsNoData'));
    }

    final sorted = [...items]..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        for (var i = 0; i < sorted.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          ReportsRankingItem(
            rank: i + 1,
            name: sorted[i].label,
            score: sorted[i].value.toStringAsFixed(1),
          ),
        ],
      ],
    );
  }
}

class ReportsRankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final String score;

  const ReportsRankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    const medalColors = [
      Color(0xFFFFD700),
      Color(0xFFC0C0C0),
      Color(0xFFCD7F32),
    ];
    final medalColor = rank <= 3 ? medalColors[rank - 1] : AppColors.textHint;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: rank == 1
            ? const Color(0xFFFFD700).withValues(alpha: 0.08)
            : context.palette.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: rank == 1
            ? Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: medalColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
