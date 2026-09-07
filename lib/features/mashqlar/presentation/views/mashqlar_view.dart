import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
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
      result = result.where((m) => m.kind == _category);
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
            appBar: AppBar(
              title: const Text('Mashqlar'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v.trim()),
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Mashq izlash...',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13.sp,
                      ),
                      prefixIcon: Icon(Icons.search, size: 20.w),
                      filled: true,
                      fillColor: context.palette.backgroundLight,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 56.w, color: context.palette.textHint),
                  SizedBox(height: 12.h),
                  Text(
                    'Mashq topilmadi',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: context.palette.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<MashqlarBloc>().add(const LoadMashqlar()),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _MashqCard(item: items[index]),
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 56.w, color: AppColors.error),
              SizedBox(height: 12.h),
              Text(
                'Mashqlarni yuklab bo\'lmadi',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () =>
                    context.read<MashqlarBloc>().add(const LoadMashqlar()),
                child: const Text('Qayta urinish'),
              ),
            ],
          ),
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
          borderRadius: BorderRadius.circular(999.r),
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

class _MashqCard extends StatelessWidget {
  final MashqItem item;

  const _MashqCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _open(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: palette.border),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                RemoteImage(
                  url: item.imageUrl,
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
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                      ),
                      if (item.subtitle.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          item.subtitle,
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
                    color: item.isUjt
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    item.isUjt ? 'UJT' : 'Texnik',
                    style: TextStyle(
                      color: item.isUjt ? AppColors.success : AppColors.primaryBlue,
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

  void _open(BuildContext context) {
    if (item.isUjt) {
      context.push('/ujt-test-detail', extra: item.id);
    } else if (item.exercise != null) {
      context.push('/exercise-detail', extra: item.exercise);
    }
  }
}
