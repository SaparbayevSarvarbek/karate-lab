import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/api/models/test_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/athlete_repository.dart';
import '../../../../core/repositories/test_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../exercises/presentation/widgets/exercise_video_player.dart';
import '../viewmodels/test_bloc.dart';

/// Testlar sahifasi.
///
/// - Murabbiy: Swagger `GET /tests/` — o'zi yaratgan testlari.
/// - Sportchi: Swagger `GET /my-tests/` — biriktirilgan testlar va statuslar.
class TestsLibraryView extends StatefulWidget {
  final String? userRole;

  const TestsLibraryView({super.key, this.userRole});

  @override
  State<TestsLibraryView> createState() => _TestsLibraryViewState();
}

class _TestsLibraryViewState extends State<TestsLibraryView> {
  bool get _isCoach => widget.userRole == AppConstants.roleCoach;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<TestBloc>();
        bloc.add(_isCoach ? const LoadCoachTests() : const LoadMyTests());
        return bloc;
      },
      child: BlocBuilder<TestBloc, TestState>(
          builder: (context, state) {
            final palette = context.palette;
            return Scaffold(
              backgroundColor: palette.background,
              appBar: AppBar(
                title: Text(_isCoach ? Tr.t('testsMine') : Tr.t('testsAssigned')),
                centerTitle: true,
              ),
              body: _buildBody(context, state),
              floatingActionButton: _isCoach
                  ? FloatingActionButton.extended(
                      onPressed: () async {
                        final created = await context.push('/create-test');
                        if (created == true && context.mounted) {
                          context.read<TestBloc>().add(const LoadCoachTests());
                        }
                      },
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.add),
                      label: Text('Test', style: TextStyle(fontSize: 13.sp)),
                    )
                  : null,
            );
          },
      ),
    );
  }

  Widget _buildBody(BuildContext context, TestState state) {
    if (state is TestLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CoachTestsLoaded) {
      if (state.tests.isEmpty) return const _EmptyTests();
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<TestBloc>().add(const LoadCoachTests()),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
          itemCount: state.tests.length,
          itemBuilder: (context, index) =>
              _buildCoachTestCard(context, state.tests[index]),
        ),
      );
    }

    if (state is MyTestsLoaded) {
      if (state.tests.isEmpty) return const _EmptyTests();
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<TestBloc>().add(const LoadMyTests()),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          itemCount: state.tests.length,
          itemBuilder: (context, index) =>
              _buildAssignmentCard(context, state.tests[index]),
        ),
      );
    }

    if (state is TestError) {
      final palette = context.palette;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 56.w, color: palette.textHint),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: () => context.read<TestBloc>().add(
                    _isCoach ? const LoadCoachTests() : const LoadMyTests(),
                  ),
              child: const Text('Qayta urinish'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCoachTestCard(BuildContext context, TestEntity test) {
    final palette = context.palette;
    final images = test.exercises
        .where((e) => e.hasImage)
        .take(3)
        .map((e) => e.image!)
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.assignment_rounded,
                      color: AppColors.primaryBlue, size: 22.w),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    test.name,
                    style: TextStyle(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (images.isNotEmpty) ...[
              SizedBox(height: 12.h),
              SizedBox(
                height: 64.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, i) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) => RemoteImage(
                    url: images[index],
                    width: 88.w,
                    height: 64.h,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.fitness_center, size: 14.w, color: palette.textHint),
                SizedBox(width: 4.w),
                Text('${test.exercises.length} mashq',
                    style: TextStyle(
                        color: palette.textSecondary, fontSize: 12.sp)),
                SizedBox(width: 14.w),
                Icon(Icons.timer_outlined, size: 14.w, color: palette.textHint),
                SizedBox(width: 4.w),
                Text('${test.totalDuration} soniya',
                    style: TextStyle(
                        color: palette.textSecondary, fontSize: 12.sp)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showAssignSheet(context, test),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add_alt_1_rounded,
                            size: 14.w, color: Colors.white),
                        SizedBox(width: 6.w),
                        Text(
                          'Biriktirish',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, TestAssignment test) {
    final palette = context.palette;
    final statusColor = switch (test.status) {
      TestStatus.completed => AppColors.success,
      TestStatus.inProgress => AppColors.warning,
      TestStatus.pending => AppColors.info,
      TestStatus.unknown => AppColors.textHint,
    };
    final statusIcon = switch (test.status) {
      TestStatus.completed => Icons.check_circle_rounded,
      TestStatus.inProgress => Icons.pending_rounded,
      TestStatus.pending => Icons.schedule_rounded,
      TestStatus.unknown => Icons.help_outline_rounded,
    };
    final imageExercises =
        test.exercises.where((e) => e.hasImage).map((e) => e.image!).toList();
    final firstImage = imageExercises.isEmpty ? null : imageExercises.first;

    return GestureDetector(
      onTap: () async {
        await context.push('/test-detail', extra: test);
        if (context.mounted) {
          context.read<TestBloc>().add(const LoadMyTests());
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 8.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(
                          label: test.status.label,
                          color: statusColor,
                          icon: statusIcon,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          test.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (firstImage != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12.h, 12.w, 0),
                    child: RemoteImage(
                      url: firstImage,
                      width: 72.w,
                      height: 54.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fitness_center,
                          size: 14.w, color: palette.textHint),
                      SizedBox(width: 4.w),
                      Text('${test.exercises.length} mashq',
                          style: TextStyle(
                              color: palette.textSecondary, fontSize: 12.sp)),
                      if (test.score != null) ...[
                        SizedBox(width: 14.w),
                        Icon(Icons.stars_rounded,
                            size: 14.w, color: AppColors.warning),
                        SizedBox(width: 4.w),
                        Text('${test.score!.toStringAsFixed(1)} ball',
                            style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700)),
                      ],
                    ],
                  ),
                  if (test.status == TestStatus.pending) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            context.read<TestBloc>().add(StartMyTest(test.id)),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Boshlash'),
                      ),
                    ),
                  ],
                  if (test.status == TestStatus.inProgress) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          await context.push('/test-detail', extra: test);
                          if (context.mounted) {
                            context.read<TestBloc>().add(const LoadMyTests());
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.warning,
                        ),
                        icon: const Icon(Icons.flag_rounded, size: 18),
                        label: const Text('Yakunlash'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignSheet(BuildContext context, TestEntity test) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssignSheetContent(test: test),
    );
  }
}

/// Testni sportchilarga biriktirish oynasi (Swagger: `POST /tests/{id}/assign/`).
class _AssignSheetContent extends StatefulWidget {
  final TestEntity test;

  const _AssignSheetContent({required this.test});

  @override
  State<_AssignSheetContent> createState() => _AssignSheetContentState();
}

class _AssignSheetContentState extends State<_AssignSheetContent> {
  List<Athlete> _athletes = [];
  final Set<int> _selectedIds = {};
  bool _loading = true;
  String? _error;
  bool _assigning = false;

  @override
  void initState() {
    super.initState();
    _loadAthletes();
  }

  Future<void> _loadAthletes() async {
    final result = await getIt<AthleteRepository>().getAthletes(size: 100);
    if (!mounted) return;
    result.fold(
      (e) => setState(() {
        _error = e.message;
        _loading = false;
      }),
      (list) => setState(() {
        _athletes = list;
        _loading = false;
      }),
    );
  }

  Future<void> _assign() async {
    if (_selectedIds.isEmpty) return;
    setState(() => _assigning = true);

    final result = await getIt<TestRepository>().assignTest(
      widget.test.id,
      AssignTestRequest(athleteIds: _selectedIds.toList()),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _assigning = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '"${widget.test.name}" ${_selectedIds.length} sportchiga biriktirildi'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.72,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 4.h),
                child: Text(
                  'Sportchilarga biriktirish',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  '"${widget.test.name}" testini tanlangan sportchilarga yuboring',
                  style: TextStyle(color: palette.textSecondary, fontSize: 12.5.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(
                              _error!,
                              style: TextStyle(
                                  color: AppColors.error, fontSize: 13.sp),
                            ),
                          )
                        : _athletes.isEmpty
                            ? Center(
                                child: Text('Sportchilar yo\'q',
                                    style: TextStyle(
                                        color: palette.textSecondary,
                                        fontSize: 13.sp)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _athletes.length,
                                itemBuilder: (context, index) {
                                  final athlete = _athletes[index];
                                  final checked =
                                      _selectedIds.contains(athlete.id);
                                  return InkWell(
                                    onTap: () => setState(() {
                                      if (checked) {
                                        _selectedIds.remove(athlete.id);
                                      } else {
                                        _selectedIds.add(athlete.id);
                                      }
                                    }),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 8.h),
                                      child: Row(
                                        children: [
                                          AvatarImage(
                                            url: athlete.avatar,
                                            name: athlete.fullName,
                                            size: 40,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  athlete.fullName,
                                                  style: TextStyle(
                                                    fontSize: 13.5.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: palette.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  '@${athlete.username}',
                                                  style: TextStyle(
                                                    fontSize: 11.5.sp,
                                                    color: palette.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            checked
                                                ? Icons.check_circle_rounded
                                                : Icons.radio_button_unchecked,
                                            color: checked
                                                ? AppColors.primaryBlue
                                                : palette.textHint,
                                            size: 22.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        _selectedIds.isEmpty || _assigning ? null : _assign,
                    child: _assigning
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text('Biriktirish (${_selectedIds.length} ta)'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTests extends StatelessWidget {
  const _EmptyTests();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 56.w, color: palette.textHint),
          SizedBox(height: 14.h),
          Text('Hozircha testlar yo\'q',
              style: TextStyle(color: palette.textSecondary, fontSize: 13.sp)),
        ],
      ),
    );
  }
}
