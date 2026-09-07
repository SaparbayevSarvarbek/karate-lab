import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/ujt_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/ujt_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';

/// Bitta UJT testi: maqsad, sifatlar va 6 ta step (rasm, takrorlash, dam olish).
class UjtTestDetailView extends StatefulWidget {
  final int testId;

  const UjtTestDetailView({super.key, required this.testId});

  @override
  State<UjtTestDetailView> createState() => _UjtTestDetailViewState();
}

class _UjtTestDetailViewState extends State<UjtTestDetailView> {
  late Future<UjtTest?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<UjtTest?> _load() async {
    final result = await getIt<UjtRepository>().getUjtTestById(widget.testId);
    return result.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
        return null;
      },
      (test) => test,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: FutureBuilder<UjtTest?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final test = snapshot.data;
          if (test == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('UJT testi')),
              body: const Center(child: Text('Test topilmadi')),
            );
          }
          return CustomScrollView(
            slivers: [
              _AppBar(test: test),
              SliverToBoxAdapter(child: _Content(test: test)),
            ],
          );
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final UjtTest test;

  const _AppBar({required this.test});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 230.h,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryNavy,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (test.hasCover)
              RemoteImage(
                url: ApiConstants.resolveMediaUrl(test.coverUrl!),
                borderRadius: BorderRadius.zero,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.sports_martial_arts_rounded,
                    size: 90.w,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.68),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 18.w,
              right: 18.w,
              bottom: 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _HeroChip(label: 'UJT', color: AppColors.success),
                      SizedBox(width: 8.w),
                      if (test.ageGroup.isNotEmpty)
                        _HeroChip(
                          label: test.ageGroup,
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    test.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;
  final Color color;

  const _HeroChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final UjtTest test;

  const _Content({required this.test});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (test.goal.isNotEmpty) ...[
            _SectionTitle(title: 'Maqsad', icon: Icons.flag_rounded),
            SizedBox(height: 10.h),
            Text(
              test.goal,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13.sp,
                height: 1.55,
              ),
            ),
          ],
          if (test.qualities.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _SectionTitle(title: 'Rivojlanadigan sifatlar', icon: Icons.stars_rounded),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: test.qualities
                  .map((q) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          q,
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          SizedBox(height: 22.h),
          _SectionTitle(
            title: 'Mashqlar (${test.steps.length})',
            icon: Icons.list_alt_rounded,
          ),
          SizedBox(height: 12.h),
          if (test.steps.isEmpty)
            Text(
              'Mashqlar kiritilmagan',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13.sp,
              ),
            )
          else
            for (final s in test.steps)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _StepCard(step: s),
              ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19.w, color: AppColors.primaryBlue),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: context.palette.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final UjtStep step;

  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.success, Color(0xFF16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 13.w,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (step.description.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              step.description,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12.5.sp,
                height: 1.55,
              ),
            ),
          ],
          if (step.images.isNotEmpty) ...[
            SizedBox(height: 10.h),
            for (final img in step.images)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: RemoteImage(
                  url: ApiConstants.resolveMediaUrl(img),
                  height: 170.h,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
          ],
          if (step.repetitions.isNotEmpty ||
              step.rest.isNotEmpty ||
              step.distance.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 14.w,
              runSpacing: 6.h,
              children: [
                if (step.repetitions.isNotEmpty)
                  _StepMeta(
                    icon: Icons.repeat_rounded,
                    label: 'Takrorlash',
                    value: step.repetitions,
                  ),
                if (step.rest.isNotEmpty)
                  _StepMeta(
                    icon: Icons.timer_outlined,
                    label: 'Dam olish',
                    value: step.rest,
                  ),
                if (step.distance.isNotEmpty)
                  _StepMeta(
                    icon: Icons.straighten_rounded,
                    label: 'Masofa',
                    value: step.distance,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StepMeta extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StepMeta({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: AppColors.primaryBlue),
          SizedBox(width: 5.w),
          Text(
            '$label: ',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 11.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
