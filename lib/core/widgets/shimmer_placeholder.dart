import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Shimmer.fromColors(
      baseColor: baseColor ?? palette.backgroundLight,
      highlightColor: highlightColor ?? palette.divider,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor ?? palette.backgroundLight,
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  const ShimmerListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          if (hasLeading) ...[
            ShimmerPlaceholder(
              width: 48.w,
              height: 48.w,
              borderRadius: BorderRadius.circular(24.r),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(lines, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: ShimmerPlaceholder(
                    width: double.infinity,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                );
              }),
            ),
          ),
          if (hasTrailing) ...[
            SizedBox(width: 12.w),
            ShimmerPlaceholder(
              width: 24.w,
              height: 24.w,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ],
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? padding;

  const ShimmerCard({
    super.key,
    this.height = 120,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: context.palette.border),
      ),
      child: ShimmerPlaceholder(
        width: double.infinity,
        height: height.h,
      ),
    );
  }
}

class ShimmerGrid extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final double aspectRatio;
  final double spacing;

  const ShimmerGrid({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.aspectRatio = 1.0,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing.w,
        mainAxisSpacing: spacing.h,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => const ShimmerCard(height: 140),
    );
  }
}

class ShimmerProfileAvatar extends StatelessWidget {
  const ShimmerProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerPlaceholder(
          width: 104.w,
          height: 104.w,
          borderRadius: BorderRadius.circular(52.r),
        ),
        SizedBox(height: 16.h),
        ShimmerPlaceholder(width: 120.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 8.h),
        ShimmerPlaceholder(width: 80.w, height: 20.h, borderRadius: BorderRadius.circular(10.r)),
      ],
    );
  }
}

class ShimmerTestHero extends StatelessWidget {
  const ShimmerTestHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: Stack(
        children: [
          ShimmerPlaceholder(
            width: double.infinity,
            height: 150.h,
            borderRadius: BorderRadius.circular(20.r),
          ),
          PositionedDirectional(
            start: 18.w,
            end: 18.w,
            bottom: 14.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerPlaceholder(width: 60.w, height: 20.h, borderRadius: BorderRadius.circular(10.r)),
                    SizedBox(width: 8.w),
                    ShimmerPlaceholder(width: 70.w, height: 20.h, borderRadius: BorderRadius.circular(10.r)),
                  ],
                ),
                SizedBox(height: 8.h),
                ShimmerPlaceholder(width: 180.w, height: 24.h, borderRadius: BorderRadius.circular(12.r)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerTestDetail extends StatelessWidget {
  const ShimmerTestDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerTestHero(),
        SizedBox(height: 16.h),
        ShimmerPlaceholder(width: 120.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 12.h),
        ShimmerPlaceholder(width: double.infinity, height: 50.h, borderRadius: BorderRadius.circular(8.r)),
        SizedBox(height: 20.h),
        ShimmerPlaceholder(width: 140.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(4, (i) => ShimmerPlaceholder(width: 80.w, height: 28.h, borderRadius: BorderRadius.circular(14.r))),
        ),
        SizedBox(height: 20.h),
        ShimmerPlaceholder(width: 140.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 12.h),
        ...List.generate(4, (i) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: ShimmerPlaceholder(width: double.infinity, height: 56.h, borderRadius: BorderRadius.circular(14.r)),
        )),
        SizedBox(height: 24.h),
        ShimmerPlaceholder(width: double.infinity, height: 50.h, borderRadius: BorderRadius.circular(12.r)),
      ],
    );
  }
}

class ShimmerExerciseDetail extends StatelessWidget {
  const ShimmerExerciseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerPlaceholder(width: double.infinity, height: 230.h, borderRadius: BorderRadius.zero),
        SizedBox(height: 20.h),
        ShimmerPlaceholder(width: 100.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 12.h),
        ShimmerPlaceholder(width: double.infinity, height: 60.h, borderRadius: BorderRadius.circular(8.r)),
        SizedBox(height: 24.h),
        ShimmerPlaceholder(width: 100.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 12.h),
        ShimmerPlaceholder(width: double.infinity, height: 180.h, borderRadius: BorderRadius.circular(12.r)),
        SizedBox(height: 24.h),
        ShimmerPlaceholder(width: 140.w, height: 22.h, borderRadius: BorderRadius.circular(11.r)),
        SizedBox(height: 12.h),
        ...List.generate(3, (i) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ShimmerPlaceholder(width: double.infinity, height: 120.h, borderRadius: BorderRadius.circular(AppRadius.card.r)),
        )),
      ],
    );
  }
}

class ShimmerExerciseCard extends StatelessWidget {
  const ShimmerExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerPlaceholder(
            width: double.infinity,
            height: 120.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(height: 12.h),
          ShimmerPlaceholder(width: 140.w, height: 18.h, borderRadius: BorderRadius.circular(9.r)),
          SizedBox(height: 8.h),
          ShimmerPlaceholder(width: 100.w, height: 14.h, borderRadius: BorderRadius.circular(7.r)),
          SizedBox(height: 12.h),
          Row(
            children: [
              ShimmerPlaceholder(width: 60.w, height: 28.h, borderRadius: BorderRadius.circular(14.r)),
              SizedBox(width: 8.w),
              ShimmerPlaceholder(width: 60.w, height: 28.h, borderRadius: BorderRadius.circular(14.r)),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerAthleteCard extends StatelessWidget {
  const ShimmerAthleteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          ShimmerPlaceholder(
            width: 56.w,
            height: 56.w,
            borderRadius: BorderRadius.circular(28.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerPlaceholder(width: 140.w, height: 20.h, borderRadius: BorderRadius.circular(10.r)),
                SizedBox(height: 8.h),
                ShimmerPlaceholder(width: 100.w, height: 16.h, borderRadius: BorderRadius.circular(8.r)),
                SizedBox(height: 8.h),
                ShimmerPlaceholder(width: 80.w, height: 14.h, borderRadius: BorderRadius.circular(7.r)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerDashboardStat extends StatelessWidget {
  const ShimmerDashboardStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerPlaceholder(width: 40.w, height: 40.w, borderRadius: BorderRadius.circular(12.r)),
          SizedBox(height: 12.h),
          ShimmerPlaceholder(width: 80.w, height: 28.h, borderRadius: BorderRadius.circular(14.r)),
          SizedBox(height: 8.h),
          ShimmerPlaceholder(width: 100.w, height: 14.h, borderRadius: BorderRadius.circular(7.r)),
        ],
      ),
    );
  }
}

class ShimmerActionTile extends StatelessWidget {
  const ShimmerActionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(color: context.palette.border),
        ),
        child: Row(
          children: [
            ShimmerPlaceholder(width: 42.w, height: 42.w, borderRadius: BorderRadius.circular(12.r)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder(width: 120.w, height: 16.h, borderRadius: BorderRadius.circular(8.r)),
                  SizedBox(height: 4.h),
                  ShimmerPlaceholder(width: 100.w, height: 14.h, borderRadius: BorderRadius.circular(7.r)),
                ],
              ),
            ),
            ShimmerPlaceholder(width: 22.w, height: 22.w, borderRadius: BorderRadius.circular(11.r)),
          ],
        ),
      ),
    );
  }
}

class ShimmerResultCard extends StatelessWidget {
  const ShimmerResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(color: context.palette.border),
        ),
        child: Row(
          children: [
            ShimmerPlaceholder(width: 40.w, height: 40.w, borderRadius: BorderRadius.circular(12.r)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholder(width: 140.w, height: 16.h, borderRadius: BorderRadius.circular(8.r)),
                  SizedBox(height: 4.h),
                  ShimmerPlaceholder(width: 80.w, height: 14.h, borderRadius: BorderRadius.circular(7.r)),
                ],
              ),
            ),
            ShimmerPlaceholder(width: 50.w, height: 24.h, borderRadius: BorderRadius.circular(10.r)),
          ],
        ),
      ),
    );
  }
}

class ShimmerCoachTestCard extends StatelessWidget {
  const ShimmerCoachTestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerPlaceholder(width: 56.w, height: 56.w, borderRadius: BorderRadius.circular(12.r)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerPlaceholder(width: 180.w, height: 18.h, borderRadius: BorderRadius.circular(9.r)),
                    SizedBox(height: 8.h),
                    ShimmerPlaceholder(width: 100.w, height: 14.h, borderRadius: BorderRadius.circular(7.r)),
                  ],
                ),
              ),
              ShimmerPlaceholder(width: 70.w, height: 24.h, borderRadius: BorderRadius.circular(12.r)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ShimmerPlaceholder(
                  width: double.infinity,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ShimmerPlaceholder(
                  width: double.infinity,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 16.w),
              ShimmerPlaceholder(
                width: 100.w,
                height: 36.h,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerTestResultCard extends StatelessWidget {
  const ShimmerTestResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder(width: 80.w, height: 20.h, borderRadius: BorderRadius.circular(10.r)),
                      SizedBox(height: 12.h),
                      ShimmerPlaceholder(width: 180.w, height: 18.h, borderRadius: BorderRadius.circular(9.r)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 12.h, 12.w, 0),
                child: ShimmerPlaceholder(width: 72.w, height: 54.h, borderRadius: BorderRadius.circular(12.r)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerPlaceholder(width: 100.w, height: 16.h, borderRadius: BorderRadius.circular(8.r)),
                    ShimmerPlaceholder(width: 80.w, height: 16.h, borderRadius: BorderRadius.circular(8.r)),
                  ],
                ),
                SizedBox(height: 12.h),
                ShimmerPlaceholder(width: double.infinity, height: 48.h, borderRadius: BorderRadius.circular(12.r)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}