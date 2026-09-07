import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
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
      appBar: AppBar(
        title: Text(Tr.t('navAthletes')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: state is AthleteActionLoading
                ? null
                : () => _showAddAthleteSheet(context),
          ),
        ],
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
                hintText: Tr.t('searchAthlete'),
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13.sp),
                prefixIcon: Icon(Icons.search, size: 20.w),
                filled: true,
                isDense: true,
                fillColor: palette.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(context, state)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AthleteState state) {
    final palette = context.palette;

    if (state is AthleteLoading || state is AthleteInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AthleteActionLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AthleteError) {
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
              onPressed: () =>
                  context.read<AthleteBloc>().add(const LoadAthletes()),
              child: Text(Tr.t('retry')),
            ),
          ],
        ),
      );
    }

    if (state is AthletesLoaded) {
      final athletes = _filtered(state.athletes);
      if (athletes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline_rounded,
                  size: 56.w, color: palette.textHint),
              SizedBox(height: 14.h),
              Text(
                _query.isEmpty
                    ? Tr.t('athletesEmpty')
                    : Tr.t('noOneFound'),
                style: TextStyle(color: palette.textSecondary, fontSize: 13.sp),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async =>
            context.read<AthleteBloc>().add(const LoadAthletes()),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
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
        borderRadius: BorderRadius.circular(16.r),
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
                  size: 46,
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
                            ? '${Tr.t('yearsOld', {'age': '${athlete.age}'})} • @${athlete.username}'
                            : '@${athlete.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: Tr.t('delete'),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 20.w,
                  ),
                  onPressed: () => _showDeleteDialog(context, athlete),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: palette.textHint, size: 20.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddAthleteSheet(BuildContext context) {
    final bloc = context.read<AthleteBloc>();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    DateTime? birthDate;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final palette = sheetContext.palette;
        return Container(
          decoration: BoxDecoration(
            color: palette.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              left: 24.w,
              right: 24.w,
              top: 20.h,
            ),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                String birthLabel = Tr.t('birthDate');
                if (birthDate != null) {
                  birthLabel =
                      '${birthDate!.year.toString().padLeft(4, '0')}-'
                      '${birthDate!.month.toString().padLeft(2, '0')}-'
                      '${birthDate!.day.toString().padLeft(2, '0')}';
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 14.h),
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: palette.border,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                      ),
                      Text(
                        Tr.t('addNewAthlete'),
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: firstNameController,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(labelText: Tr.t('firstName')),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: lastNameController,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(labelText: Tr.t('lastName')),
                      ),
                      SizedBox(height: 12.h),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today_rounded),
                        label: Text(birthLabel, style: TextStyle(fontSize: 13.sp)),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2005),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            birthDate = picked;
                            setSheetState(() {});
                          }
                        },
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            final firstName = firstNameController.text.trim();
                            final lastName = lastNameController.text.trim();

                            if (firstName.isEmpty || lastName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(Tr.t('nameRequired')),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            final date = birthDate;
                            if (date == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(Tr.t('selectBirthDate')),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            final isoDate =
                                '${date.year.toString().padLeft(4, '0')}-'
                                '${date.month.toString().padLeft(2, '0')}-'
                                '${date.day.toString().padLeft(2, '0')}';

                            bloc.add(
                              AddAthlete(
                                CreateAthleteRequest(
                                  firstName: firstName,
                                  lastName: lastName,
                                  birthDate: isoDate,
                                ),
                              ),
                            );
                            Navigator.of(sheetContext).pop();
                          },
                          child: Text(Tr.t('add')),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
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
