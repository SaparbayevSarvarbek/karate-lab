import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../viewmodels/mashqlar_bloc.dart';

/// Mashqlar sahifasi: search + category chiplari (Barchasi / Texnik / UJT / MJT).
class MashqlarView extends StatefulWidget {
  const MashqlarView({super.key});

  @override
  State<MashqlarView> createState() => _MashqlarViewState();
}

class _MashqlarViewState extends State<MashqlarView> {
  final _searchController = TextEditingController();
  String _query = '';
  String _category = 'all'; // all | texnik | ujt | mjt

  static const _categories = <String, String>{
    'all': 'Barchasi',
    'texnik': 'Texnik',
    'ujt': 'UJT',
    'mjt': 'MJT',
  };

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
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
          if (state is MashqlarLoaded && state.warning != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.warning!),
                  backgroundColor: AppColors.warning,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.palette.background,
            appBar: const KarateAppBar(title: 'KarateLab AI', showLogo: true),
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
                      hintText: 'Mashq izlash...',
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
                      fillColor: context.palette.backgroundLight,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final code = _categories.keys.elementAt(index);
                      return _CategoryChip(
                        label: _categories[code]!,
                        selected: _category == code,
                        onTap: () => setState(() => _category = code),
                      );
                    },
                  ),
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
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MashqlarLoaded) {
          final items = _filtered(state.items);
          if (items.isEmpty) {
            return AppEmptyView(
              icon: Icons.search_off_rounded,
              title: 'Mashq topilmadi',
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<MashqlarBloc>().add(const LoadMashqlar()),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _MashqCard(item: items[index]),
            ),
          );
        }

        return AppErrorView(
          message: 'Mashqlarni yuklab bo\'lmadi',
          onRetry: () => context.read<MashqlarBloc>().add(const LoadMashqlar()),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : palette.backgroundLight,
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : palette.textSecondary,
            fontSize: 12.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
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
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          onTap: () => _open(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card.r),
              border: Border.all(color: palette.border),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                _IconTile(icon: _icon, color: _accent),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardTitle
                            .copyWith(color: palette.textPrimary),
                      ),
                      if (item.subtitle.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          item.subtitle,
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
                    color: _accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill.r),
                  ),
                  child: Text(
                    _label,
                    style: AppTextStyles.badge
                        .copyWith(color: _accent, letterSpacing: 0),
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
