import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../viewmodels/athlete_bloc.dart';

/// Murabbiy uchun sportchilar ro'yxati (Swagger: `GET /athletes/`).
class AthletesListView extends StatefulWidget {
  const AthletesListView({super.key});

  @override
  State<AthletesListView> createState() => _AthletesListViewState();
}

class _AthletesListViewState extends State<AthletesListView> {
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Athlete> _filtered(List<Athlete> athletes) {
    if (_query.isEmpty) return athletes;
    final q = _query.toLowerCase();
    return athletes.where((a) => a.fullName.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AthleteBloc>()..add(const LoadAthletes()),
      child: BlocBuilder<AthleteBloc, AthleteState>(
        builder: (context, state) => _buildScaffold(context, state),
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, AthleteState state) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: const KarateAppBar(title: 'KarateLab AI', showLogo: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v.trim()),
              style: TextStyle(fontSize: 14.sp, color: palette.textPrimary),
              decoration: InputDecoration(
                hintText: Tr.t('searchAthlete'),
                hintStyle: TextStyle(color: palette.textHint, fontSize: 13.sp),
                prefixIcon: Icon(Icons.search_rounded,
                    size: 20.w, color: palette.textHint),
                filled: true,
                isDense: true,
                fillColor: palette.surface,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button.r),
                  borderSide: BorderSide(color: palette.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button.r),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Barchasi',
                  selected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'Tugalladi',
                  selected: _filter == 'done',
                  onTap: () => setState(() => _filter = 'done'),
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'Faol',
                  selected: _filter == 'active',
                  onTap: () => setState(() => _filter = 'active'),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(context, state)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AthleteState state) {
    if (state is AthleteLoading || state is AthleteInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AthleteActionLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AthleteError) {
      return AppErrorView(
        message: state.message,
        retryLabel: Tr.t('retry'),
        onRetry: () => context.read<AthleteBloc>().add(const LoadAthletes()),
      );
    }

    if (state is AthletesLoaded) {
      final athletes = _filtered(state.athletes);
      if (athletes.isEmpty) {
        return AppEmptyView(
          icon: Icons.people_outline,
          title: _query.isEmpty ? Tr.t('athletesEmpty') : Tr.t('noOneFound'),
        );
      }
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<AthleteBloc>().add(const LoadAthletes()),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          itemCount: athletes.length,
          itemBuilder: (context, index) =>
              _buildAthleteTile(context, athletes[index]),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAthleteTile(BuildContext context, Athlete athlete) {
    final palette = context.palette;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/athlete-profile', extra: athlete),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                AvatarImage(
                  url: athlete.avatar,
                  name: athlete.fullName,
                  size: 44,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        athlete.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5.sp,
                          color: palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        athlete.age > 0
                            ? '${Tr.t('yearsOld', {'age': '${athlete.age}'})} • ${athlete.username}'
                            : athlete.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: Tr.t('delete'),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 20.w,
                  ),
                  onPressed: () => _showDeleteDialog(context, athlete),
                ),
                GestureDetector(
                  onTap: () => context.push('/athlete-profile', extra: athlete),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.pill.r),
                    ),
                    child: Text(
                      'Ko\'rish',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
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

  void _showDeleteDialog(BuildContext context, Athlete athlete) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(Tr.t('deleteAthleteTitle'), style: TextStyle(fontSize: 16.sp)),
          content: Text(
            Tr.t('deleteAthleteConfirm', {'name': athlete.fullName}),
            style: TextStyle(fontSize: 13.5.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(Tr.t('cancel')),
            ),
            TextButton(
              onPressed: () {
                context.read<AthleteBloc>().add(DeleteAthlete(athlete.id));
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                Tr.t('delete'),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : palette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : palette.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
