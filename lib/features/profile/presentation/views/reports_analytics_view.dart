import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';

class ReportsAnalyticsView extends StatelessWidget {
  const ReportsAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Coming soon 🚀'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.primaryBlue),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ReportsSummaryRow(),
            SizedBox(height: 24),
            ReportsSectionTitle(title: 'Performance Trend'),
            SizedBox(height: 16),
            ReportsLineChartCard(),
            SizedBox(height: 24),
            ReportsSectionTitle(title: 'Testlar bo\'yicha'),
            SizedBox(height: 16),
            ReportsTestResultsCard(),
            SizedBox(height: 24),
            ReportsSectionTitle(title: 'Sportchilar reytingi'),
            SizedBox(height: 16),
            ReportsAthleteRankingList(),
          ],
        ),
      ),
    );
  }
}

class ReportsSummaryRow extends StatelessWidget {
  const ReportsSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: ReportsSummaryCard(label: 'Jami sportchilar', value: '128', icon: Icons.people, color: AppColors.primaryBlue)),
        SizedBox(width: 12),
        Expanded(child: ReportsSummaryCard(label: 'O\'rtacha ko\'rsatkich', value: '82.4', icon: Icons.trending_up, color: AppColors.success)),
      ],
    );
  }
}

class ReportsSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const ReportsSummaryCard({super.key, required this.label, required this.value, required this.icon, required this.color});

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
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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

class ReportsLineChartCard extends StatelessWidget {
  const ReportsLineChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
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
            child: ReportsSimpleLineChart(),
          ),
          const ReportsChartMonthsRow(),
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
      children: const [
        ReportsLegendDot(color: AppColors.primaryBlue),
        SizedBox(width: 6),
        Text('O\'rtacha ball', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        SizedBox(width: 16),
        ReportsLegendDot(color: AppColors.success),
        SizedBox(width: 6),
        Text('Maksimal ball', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
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

class ReportsSimpleLineChart extends StatelessWidget {
  const ReportsSimpleLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SimpleChartPainter(),
      size: Size.infinite,
    );
  }
}

class _SimpleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintBlue = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintGreen = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Simple demo line for blue
    final pointsBlue = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.2),
    ];

    final pathBlue = Path()..moveTo(pointsBlue[0].dx, pointsBlue[0].dy);
    for (var p in pointsBlue.skip(1)) {
      pathBlue.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(pathBlue, paintBlue);

    // Simple demo line for green
    final pointsGreen = [
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.35),
      Offset(size.width * 0.4, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.25),
      Offset(size.width, size.height * 0.1),
    ];

    final pathGreen = Path()..moveTo(pointsGreen[0].dx, pointsGreen[0].dy);
    for (var p in pointsGreen.skip(1)) {
      pathGreen.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(pathGreen, paintGreen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReportsChartMonthsRow extends StatelessWidget {
  const ReportsChartMonthsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Feb', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          Text('Mar', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          Text('Apr', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          Text('May', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          Text('Jun', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
          Text('Jul', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class ReportsTestResultsCard extends StatelessWidget {
  const ReportsTestResultsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: const [
          ReportsTestResultRow(name: 'Geri tepkisi', avgScore: '85.2', participants: 42),
          Divider(height: 24),
          ReportsTestResultRow(name: 'Zuki zarbasi', avgScore: '78.0', participants: 38),
          Divider(height: 24),
          ReportsTestResultRow(name: 'Mae geri', avgScore: '90.1', participants: 55),
        ],
      ),
    );
  }
}

class ReportsTestResultRow extends StatelessWidget {
  final String name;
  final String avgScore;
  final int participants;

  const ReportsTestResultRow({super.key, required this.name, required this.avgScore, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('$participants ishtirokchi', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        Text(avgScore, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryBlue)),
      ],
    );
  }
}

class ReportsAthleteRankingList extends StatelessWidget {
  const ReportsAthleteRankingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReportsRankingItem(rank: 1, name: 'Jasur Abdullayev', score: '92.5'),
        const SizedBox(height: 10),
        ReportsRankingItem(rank: 2, name: 'Ziyoda Yusupova', score: '88.1'),
        const SizedBox(height: 10),
        ReportsRankingItem(rank: 3, name: 'Sardor Toshmatov', score: '85.0'),
      ],
    );
  }
}

class ReportsRankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final String score;

  const ReportsRankingItem({super.key, required this.rank, required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    final medalColors = [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: rank == 1 ? const Color(0xFFFFD700).withValues(alpha: 0.08) : context.palette.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: rank == 1 ? Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: medalColors[rank - 1], shape: BoxShape.circle),
            child: Center(child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(score, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryBlue)),
        ],
      ),
    );
  }
}
