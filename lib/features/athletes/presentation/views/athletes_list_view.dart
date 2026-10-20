import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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

    void openProfile() => context.push('/athlete-profile', extra: athlete);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: Dismissible(
        key: ValueKey(athlete.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => _confirmDelete(context, athlete),
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: EdgeInsetsDirectional.only(end: AppSpacing.xl.w),
          decoration: BoxDecoration(
            color: palette.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.card.r),
            border: Border.all(color: palette.error.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: palette.error,
                size: 20.w,
              ),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                Tr.t('delete'),
                style: AppTextStyles.button.copyWith(color: palette.error),
              ),
            ],
          ),
        ),
        child: AppListTile(
          leading: AvatarImage(
            url: athlete.avatar,
            name: athlete.fullName,
            size: 48,
          ),
          title: athlete.fullName,
          subtitle: subtitle,
          showChevron: true,
          onTap: openProfile,
        ),
      ),
    );
  }

  /// O'chirishni tasdiqlash. `true` qaytsa — `Dismissible` elementni olib tashlaydi.
  Future<bool> _confirmDelete(BuildContext context, Athlete athlete) async {
    final bloc = context.read<AthleteBloc>();
    final palette = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.panel.r),
        ),
        title: Text(
          Tr.t('deleteAthleteTitle'),
          style: AppTextStyles.sectionTitle.copyWith(
            color: palette.textPrimary,
          ),
        ),
        content: Text(
          Tr.t('deleteAthleteConfirm', {'name': athlete.fullName}),
          style: AppTextStyles.body.copyWith(color: palette.textSecondary),
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
              style: AppTextStyles.label.copyWith(color: palette.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bloc.add(DeleteAthlete(athlete.id));
      return true;
    }
    return false;
  }
}
