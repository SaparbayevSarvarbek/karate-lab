import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/api/models/mjt_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/ujt_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';

/// Bitta MJT testi: maqsad, sifatlar va 5 ta step (rasm, takrorlash, dam olish, maqsad).
class MjtTestDetailView extends StatefulWidget {
  final int testId;

  const MjtTestDetailView({super.key, required this.testId});

  @override
  State<MjtTestDetailView> createState() => _MjtTestDetailViewState();
}

class _MjtTestDetailViewState extends State<MjtTestDetailView> {
  late Future<MjtTest?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<MjtTest?> _load() async {
    final result = await getIt<UjtRepository>().getMjtTestById(widget.testId);
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
    return FutureBuilder<MjtTest?>(
      future: _future,
      builder: (context, snapshot) {
        final test = snapshot.data;
        final loading = snapshot.connectionState != ConnectionState.done;
        return Scaffold(
          backgroundColor: context.palette.background,
          appBar: KarateAppBar(
            title: (test?.title.isNotEmpty ?? false) ? test!.title : 'MJT testi',
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : test == null
                  ? const AppEmptyView(
                      icon: Icons.search_off_rounded,
                      title: 'Test topilmadi',
                    )
                  : SingleChildScrollView(child: _Content(test: test)),
        );
      },
    );
  }
}

/// Hero blok — 16:9 media (rasm yoki navy→blue gradient + watermark).
class _HeroMedia extends StatelessWidget {
  final MjtTest test;

  const _HeroMedia({required this.test});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: test.hasCover
              ? RemoteImage(
                  url: ApiConstants.resolveMediaUrl(test.coverUrl!),
                  borderRadius: BorderRadius.zero,
                  fit: BoxFit.cover,
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryNavy, AppColors.gradientDeepBlue],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: Icon(
                          Icons.sports_martial_arts_rounded,
                          size: 96.w,
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      PositionedDirectional(
                        start: 16.w,
                        end: 16.w,
                        bottom: 12.h,
                        child: Text(
                          'MJT testi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final MjtTest test;

  const _Content({required this.test});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroMedia(test: test),
          SizedBox(height: 20.h),
          Text(
            test.title,
            style: AppTextStyles.screenTitle.copyWith(color: palette.textPrimary),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              const _Pill(text: 'MJT'),
              if (test.ageGroup.isNotEmpty) _Pill(text: test.ageGroup),
              if (test.goal.isNotEmpty)
                _Pill(text: test.goal, maxWidth: 220.w),
            ],
          ),
          if (test.goal.isNotEmpty) ...[
            SizedBox(height: 24.h),
            AppSectionHeader(title: 'Maqsad'),
            SizedBox(height: 8.h),
            Text(
              test.goal,
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
          ],
          if (test.qualities.isNotEmpty) ...[
            SizedBox(height: 24.h),
            AppSectionHeader(title: 'Rivojlanadigan sifatlar'),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: test.qualities.map((q) => _Pill(text: q)).toList(),
            ),
          ],
          SizedBox(height: 24.h),
          AppSectionHeader(title: 'Mashqlar (${test.steps.length})'),
          SizedBox(height: 12.h),
          if (test.steps.isEmpty)
            const AppEmptyView(
              icon: Icons.list_alt_rounded,
              title: 'Mashqlar kiritilmagan',
              compact: true,
            )
          else
            for (int i = 0; i < test.steps.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _StepCard(step: test.steps[i], index: i + 1),
              ),
        ],
      ),
    );
  }
}

/// primaryBlue tintli pill / chip.
class _Pill extends StatelessWidget {
  final String text;
  final double? maxWidth;

  const _Pill({required this.text, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    if (maxWidth == null) return child;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: child,
    );
  }
}

class _StepCard extends StatelessWidget {
  final MjtStep step;
  final int index;

  const _StepCard({required this.step, required this.index});

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
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  step.title,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (step.description.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              step.description,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12.5.sp,
                height: 1.55,
              ),
            ),
          ],
          if (step.goal.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 14.w,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    step.goal,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 12.5.sp,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (step.images.isNotEmpty) ...[
            SizedBox(height: 12.h),
            for (final img in step.images)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: RemoteImage(
                  url: ApiConstants.resolveMediaUrl(img),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
          ],
          if (step.repetitions.isNotEmpty || step.rest.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: AppColors.primaryBlue),
          SizedBox(width: 4.w),
          Text(
            '$label: ',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
