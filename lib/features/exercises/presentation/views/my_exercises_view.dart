import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../viewmodels/exercise_bloc.dart';

/// Murabbiy uchun mashqlarni boshqarish sahifasi (Swagger: `GET /exercises/`).
///
/// Kartalar `MashqlarView` dagi (`_MashqCard`) bilan bir xil ko'rinishda —
/// har bir mashqni bosib ochish yoki o'chirish mumkin.
class MyExercisesView extends StatefulWidget {
  const MyExercisesView({super.key});

  @override
  State<MyExercisesView> createState() => _MyExercisesViewState();
}

class _MyExercisesViewState extends State<MyExercisesView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> _filtered(List<Exercise> items) {
    if (_query.isEmpty) return items;
    final q = _query.toLowerCase();
    return items.where((e) => e.title.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExerciseBloc>()..add(const LoadExercises()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.palette.background,
          appBar: AppBar(
            title: Text(Tr.t('myExercisesTitle')),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: Tr.t('searchExercise'),
                    hintStyle:
                        TextStyle(color: AppColors.textHint, fontSize: 13.sp),
                    prefixIcon: Icon(Icons.search, size: 20.w),
                    filled: true,
                    isDense: true,
                    fillColor: context.palette.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildBody(context)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final added = await context.push('/add-exercise');
              if (added == true && mounted) {
                context.read<ExerciseBloc>().add(const LoadExercises());
              }
            },
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: Text('Mashq', style: TextStyle(fontSize: 13.sp)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final palette = context.palette;
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading ||
            state is ExerciseActionLoading ||
            state is ExerciseInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExerciseError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off_rounded,
                      size: 56.w, color: AppColors.error),
                  SizedBox(height: 14.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: palette.textSecondary, fontSize: 13.sp),
                  ),
                  SizedBox(height: 18.h),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ExerciseBloc>()
                        .add(const LoadExercises()),
                    child: Text(Tr.t('retry')),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ExercisesLoaded) {
          final items = _filtered(state.exercises);
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _query.isEmpty
                        ? Icons.fitness_center_rounded
                        : Icons.search_off_rounded,
                    size: 56.w,
                    color: palette.textHint,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    _query.isEmpty
                        ? Tr.t('myExercisesEmpty')
                        : Tr.t('exerciseNotFound'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ExerciseBloc>().add(const LoadExercises()),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final exercise = items[index];
                return Dismissible(
                  key: ValueKey(exercise.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async =>
                      await _confirmDelete(context, exercise),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 24.w),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delete_outline_rounded,
                            color: AppColors.error),
                        SizedBox(width: 6.w),
                        Text(
                          Tr.t('delete'),
                          style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: _ExerciseManageCard(
                    exercise: exercise,
                    onTap: () =>
                        context.push('/exercise-detail', extra: exercise),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// O'chirishni tasdiqlash dialogi. `true` qaytsa — o'chiriladi.
  /// `confirmDismiss` `Dismissible` ni yo'qotishdan oldin rozi bo'lishni kutadi.
  Future<bool> _confirmDelete(BuildContext context, Exercise exercise) async {
    final bloc = context.read<ExerciseBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(Tr.t('deleteExerciseTitle'),
              style: TextStyle(fontSize: 16.sp)),
          content: Text(
            Tr.t('deleteExerciseConfirm', {'name': exercise.title}),
            style: TextStyle(fontSize: 13.5.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(Tr.t('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                Tr.t('delete'),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      bloc.add(DeleteExercise(exercise.id));
      return true;
    }
    return false;
  }
}

/// `MashqlarView._MashqCard` bilan bir xil ko'rinishdagi karta —
/// qo'shimcha ravishda o'chirish tugmasi bilan.
class _ExerciseManageCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseManageCard({
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final category = exercise.category.toUpperCase();
    final isMjt = category == 'MJT';
    final isUjt = category == 'UJT';
    final badgeColor = isMjt
        ? AppColors.warning
        : isUjt
            ? AppColors.success
            : AppColors.primaryBlue;
    final badgeLabel = isMjt
        ? 'MJT'
        : isUjt
            ? 'UJT'
            : 'Texnik';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: palette.border),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                RemoteImage(
                  url: exercise.image,
                  width: 68.w,
                  height: 68.w,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      if (exercise.category.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          exercise.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontSize: 11.5.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textHint,
                  size: 22.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
