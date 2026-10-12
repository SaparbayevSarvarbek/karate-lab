import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/exercise_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
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
          appBar: KarateAppBar(title: Tr.t('myExercisesTitle')),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: context.palette.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: Tr.t('searchExercise'),
                    hintStyle: TextStyle(
                      color: context.palette.textHint,
                      fontSize: 13.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.w,
                      color: context.palette.textHint,
                    ),
                    filled: true,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    fillColor: context.palette.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button.r),
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
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading ||
            state is ExerciseActionLoading ||
            state is ExerciseInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExerciseError) {
          return AppErrorView(
            message: state.message,
            retryLabel: Tr.t('retry'),
            onRetry: () => context.read<ExerciseBloc>().add(const LoadExercises()),
          );
        }

        if (state is ExercisesLoaded) {
          final items = _filtered(state.exercises);
          if (items.isEmpty) {
            return _query.isEmpty
                ? AppEmptyView(
                    icon: Icons.fitness_center_outlined,
                    title: Tr.t('myExercisesEmpty'),
                  )
                : AppEmptyView(
                    icon: Icons.search_off_rounded,
                    title: Tr.t('exerciseNotFound'),
                  );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ExerciseBloc>().add(const LoadExercises()),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final exercise = items[index];
                return Dismissible(
                  key: ValueKey(exercise.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async =>
                      await _confirmDelete(context, exercise),
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: EdgeInsetsDirectional.only(end: 24.w),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.card.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delete_outline_rounded,
                            color: AppColors.error),
                        SizedBox(width: 8.w),
                        Text(
                          Tr.t('delete'),
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
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

/// Karta ichidagi 44x44 yumaloq ikonka bloki.
class _IconTile extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconTile({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(icon, size: 22.w, color: color),
    );
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
    final icon = isMjt
        ? Icons.fitness_center_rounded
        : isUjt
            ? Icons.bolt_rounded
            : Icons.sports_martial_arts_rounded;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card.r),
              border: Border.all(color: palette.border),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                _IconTile(icon: icon, color: badgeColor),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle
                            .copyWith(color: palette.textPrimary),
                      ),
                      if (exercise.category.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          exercise.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption
                              .copyWith(color: palette.textSecondary),
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
                    borderRadius: BorderRadius.circular(AppRadius.pill.r),
                  ),
                  child: Text(
                    badgeLabel,
                    style: AppTextStyles.badge
                        .copyWith(color: badgeColor, letterSpacing: 0),
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
