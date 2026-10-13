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
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_filter_chips.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/shimmer_placeholder.dart';
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

  static const _filters = <AppChipItem<String>>[
    AppChipItem(value: 'all', label: 'Barchasi'),
    AppChipItem(value: 'done', label: 'Tugalladi'),
    AppChipItem(value: 'active', label: 'Faol'),
  ];

  EdgeInsets get _listPadding => EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.md.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      );

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
        builder: (context, state) => Scaffold(
          backgroundColor: context.palette.background,
          appBar: KarateAppBar(title: Tr.t('navAthletes'), showLogo: true),
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
                  hint: Tr.t('searchAthlete'),
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
              AppFilterChips<String>(
                items: _filters,
                selected: _filter,
                onSelected: (v) => setState(() => _filter = v),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AthleteState state) {
    if (state is AthleteLoading ||
        state is AthleteActionLoading ||
        state is AthleteInitial) {
      return ListView(
        padding: _listPadding,
        children: List.generate(
          6,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: const ShimmerAthleteCard(),
          ),
        ),
      );
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
          icon: Icons.people_outline_rounded,
          title: _query.isEmpty ? Tr.t('athletesEmpty') : Tr.t('noOneFound'),
        );
      }
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<AthleteBloc>().add(const LoadAthletes()),
        child: ListView.builder(
          padding: _listPadding,
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
    final subtitle = athlete.age > 0
        ? '${Tr.t('yearsOld', {'age': '${athlete.age}'})} • ${athlete.username}'
        : athlete.username;

    void openProfile() =>
        context.push('/athlete-profile', extra: athlete);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: AppListTile(
        leading: AvatarImage(
          url: athlete.avatar,
          name: athlete.fullName,
          size: 48,
        ),
        title: athlete.fullName,
        subtitle: subtitle,
        onTap: openProfile,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: Tr.t('delete'),
              onPressed: () => _showDeleteDialog(context, athlete),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: palette.error,
                size: 20.w,
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            _ViewPill(onTap: openProfile),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Athlete athlete) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final palette = dialogContext.palette;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.panel.r),
          ),
          title: Text(
            Tr.t('deleteAthleteTitle'),
            style: AppTextStyles.sectionTitle.copyWith(color: palette.textPrimary),
          ),
          content: Text(
            Tr.t('deleteAthleteConfirm', {'name': athlete.fullName}),
            style: AppTextStyles.body.copyWith(color: palette.textSecondary),
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
                style: AppTextStyles.label.copyWith(color: palette.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Kartadagi "Ko'rish" amali — brend tusli pill.
class _ViewPill extends StatelessWidget {
  final VoidCallback onTap;

  const _ViewPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppRadius.pill.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        child: Container(
          height: 44.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Text(
            'Ko\'rish',
            style: AppTextStyles.label.copyWith(color: AppColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}
