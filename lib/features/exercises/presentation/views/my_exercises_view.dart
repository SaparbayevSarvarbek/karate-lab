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
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/app_filter_chips.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../viewmodels/exercise_bloc.dart';

/// Murabbiy uchun mashqlarni boshqarish sahifasi (Swagger: `GET /exercises/`).
///
/// Kartalar `MashqlarView` dagi karta bilan bir xil ko'rinishda — har bir
/// mashqni bosib ochish yoki chapga surib o'chirish mumkin.
class MyExercisesView extends StatefulWidget {
  const MyExercisesView({super.key});

  @override
  State<MyExercisesView> createState() => _MyExercisesViewState();
}

class _MyExercisesViewState extends State<MyExercisesView> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'all';

  static const _categories = <AppChipItem<String>>[
    AppChipItem(value: 'all', label: 'Barchasi'),
    AppChipItem(value: 'UJT', label: 'UJT'),
    AppChipItem(value: 'MJT', label: 'MJT'),
    AppChipItem(value: 'Texnik', label: 'Texnik'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> _filtered(List<Exercise> items) {
    Iterable<Exercise> result = items;
    if (_category != 'all') {
      result = result.where(
        (e) => e.category.toLowerCase() == _category.toLowerCase(),
      );
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      result = result.where((e) => e.title.toLowerCase().contains(q));
    }
    return result.toList();
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
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.screenTop.h,
                  AppSpacing.screenH.w,
                  AppSpacing.md.h,
                ),
                child: AppSearchField(
                  hint: Tr.t('searchExercise'),
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
              AppFilterChips<String>(
                items: _categories,
                selected: _category,
                onSelected: (v) => setState(() => _category = v),
              ),
              Expanded(child: _buildBody(context)),
            ],
          ),
          floatingActionButton: AppFab(
            label: 'Mashq',
            onPressed: () async {
              final added = await context.push('/add-exercise');
              if (added == true && context.mounted) {
                context.read<ExerciseBloc>().add(const LoadExercises());
              }
            },
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
          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenH.w,
              AppSpacing.md.h,
              AppSpacing.screenH.w,
              AppSpacing.screenBottom.h,
            ),
            children: List.generate(6, (_) => const ShimmerActionTile()),
          );
        }

        if (state is ExerciseError) {
          return AppErrorView(
            message: state.message,
            retryLabel: Tr.t('retry'),
            onRetry: () =>
                context.read<ExerciseBloc>().add(const LoadExercises()),
          );
        }

        if (state is ExercisesLoaded) {
          final items = _filtered(state.exercises);
          if (items.isEmpty) {
            return _query.isEmpty
                ? AppEmptyView(
                    icon: Icons.fitness_center_outlined,
                    title: Tr.t('myExercisesEmpty'),
                    message: 'Birinchi mashqni qo\'shing va u shu yerda ko\'rinadi.',
                  )
                : AppEmptyView(
                    icon: Icons.search_off_rounded,
                    title: Tr.t('noSearchResult'),
                    message: Tr.t('noSearchResultSub'),
                  );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ExerciseBloc>().add(const LoadExercises()),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenH.w,
                AppSpacing.md.h,
                AppSpacing.screenH.w,
                AppSpacing.screenBottom.h,
              ),
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
                    padding: EdgeInsetsDirectional.only(end: AppSpacing.xl.w),
                    margin: EdgeInsets.only(bottom: AppSpacing.md.h),
                    decoration: BoxDecoration(
                      color: context.palette.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.card.r),
                      border: Border.all(
                        color: context.palette.error.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: context.palette.error,
                          size: 20.w,
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Text(
                          Tr.t('delete'),
                          style: AppTextStyles.button
                              .copyWith(color: context.palette.error),
                        ),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                    child: _ExerciseManageCard(
                      exercise: exercise,
                      onTap: () =>
                          context.push('/exercise-detail', extra: exercise),
                    ),
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
    final palette = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(Tr.t('deleteExerciseTitle')),
        content: Text(Tr.t('deleteExerciseConfirm', {'name': exercise.title})),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(Tr.t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              Tr.t('delete'),
              style: TextStyle(color: palette.error, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bloc.add(DeleteExercise(exercise.id));
      return true;
    }
    return false;
  }
}

/// `MashqlarView` kartasi bilan bir xil ko'rinishdagi boshqaruv kartasi.
class _ExerciseManageCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseManageCard({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
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

    return AppListTile(
      icon: icon,
      iconColor: badgeColor,
      title: exercise.title,
      subtitle: exercise.category.isEmpty ? null : exercise.category,
      trailing: AppBadge(label: badgeLabel, color: badgeColor),
      showChevron: true,
      onTap: onTap,
    );
  }
}
