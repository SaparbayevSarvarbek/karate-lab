import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/app_filter_chips.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
import '../viewmodels/mashqlar_bloc.dart';
import '../../../../core/widgets/app_snackbar.dart';

/// Mashqlar sahifasi: qidiruv + kategoriya chiplari (Barchasi / Texnik / UJT / MJT).
class MashqlarView extends StatefulWidget {
  const MashqlarView({super.key});

  @override
  State<MashqlarView> createState() => _MashqlarViewState();
}

class _MashqlarViewState extends State<MashqlarView> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'all'; // all | texnik | ujt | mjt

  static const _categories = <AppChipItem<String>>[
    AppChipItem(value: 'all', label: 'Barchasi'),
    AppChipItem(value: 'texnik', label: 'Texnik'),
    AppChipItem(value: 'ujt', label: 'UJT'),
    AppChipItem(value: 'mjt', label: 'MJT'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MashqItem> _filtered(List<MashqItem> items) {
    Iterable<MashqItem> result = items;
    if (_category != 'all') {
      result = result.where((m) =>
          m.kind == _category ||
          (m.kind == 'texnik' &&
              m.subtitle.toUpperCase() == _category.toUpperCase()));
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      result = result.where((m) => m.title.toLowerCase().contains(q));
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MashqlarBloc>()..add(const LoadMashqlar()),
      child: BlocListener<MashqlarBloc, MashqlarState>(
        listener: (context, state) {
          if (state is MashqlarError) {
            AppSnackbar.neutral(context, state.message);
          }
          if (state is MashqlarLoaded && state.warning != null) {
            AppSnackbar.neutral(context, state.warning!);
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.palette.background,
            appBar: KarateAppBar(
              title: Tr.t('navExercises'),
              showLogo: true,
            ),
            floatingActionButton: AppFab(
              label: 'Mashq',
              onPressed: () async {
                final added = await context.push('/add-exercise');
                if (added == true && context.mounted) {
                  context.read<MashqlarBloc>().add(const LoadMashqlar());
                }
              },
            ),
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
                    hint: Tr.t('searchExerciseHint'),
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
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<MashqlarBloc, MashqlarState>(
      builder: (context, state) {
        if (state is MashqlarLoading || state is MashqlarInitial) {
          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenH.w,
              AppSpacing.md.h,
              AppSpacing.screenH.w,
              96.h,
            ),
            children: List.generate(6, (_) => const ShimmerActionTile()),
          );
        }

        if (state is MashqlarLoaded) {
          final items = _filtered(state.items);
          if (items.isEmpty) {
            return AppEmptyView(
              icon: Icons.search_off_rounded,
              title: Tr.t('noSearchResult'),
              message: _query.isEmpty ? null : Tr.t('noSearchResultSub'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<MashqlarBloc>().add(const LoadMashqlar()),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenH.w,
                AppSpacing.md.h,
                AppSpacing.screenH.w,
                AppSpacing.screenBottom.h,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                child: _MashqCard(item: items[index]),
              ),
            ),
          );
        }

        return AppErrorView(
          message: 'Mashqlarni yuklab bo\'lmadi',
          retryLabel: Tr.t('retry'),
          onRetry: () => context.read<MashqlarBloc>().add(const LoadMashqlar()),
        );
      },
    );
  }
}

class _MashqCard extends StatelessWidget {
  final MashqItem item;

  const _MashqCard({required this.item});

  Color get _accent => item.isMjt
      ? AppColors.warning
      : item.isUjt
          ? AppColors.success
          : AppColors.primaryBlue;

  IconData get _icon => item.isMjt
      ? Icons.fitness_center_rounded
      : item.isUjt
          ? Icons.bolt_rounded
          : Icons.sports_martial_arts_rounded;

  String get _label =>
      item.isMjt ? 'MJT' : item.isUjt ? 'UJT' : 'Texnik';

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      icon: _icon,
      iconColor: _accent,
      title: item.title,
      subtitle: item.subtitle.isEmpty ? null : item.subtitle,
      showChevron: true,
      trailing: AppBadge(label: _label, color: _accent),
      onTap: () => _open(context),
    );
  }

  /// Faqat `kind` bo'yicha yo'naltiriladi. Kategoriya bo'yicha tekshirish
  /// xato edi: murabbiy qo'shgan "UJT"/"MJT" kategoriyali mashq test emas,
  /// shuning uchun test detali o'rniga mashq detaliga o'tishi kerak.
  void _open(BuildContext context) {
    if (item.kind == 'ujt') {
      context.push('/ujt-test-detail', extra: item.id);
    } else if (item.kind == 'mjt') {
      context.push('/mjt-test-detail', extra: item.id);
    } else if (item.exercise != null) {
      context.push('/exercise-detail', extra: item.exercise);
    }
  }
}
