import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/models/athlete_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/remote_image.dart';
import '../viewmodels/athlete_bloc.dart';

/// Sportchi profili (Swagger: `GET /athletes/{id}/`).
class AthleteProfileView extends StatelessWidget {
  final Athlete? athlete;

  const AthleteProfileView({super.key, this.athlete});

  @override
  Widget build(BuildContext context) {
    final initial = athlete;

    return BlocProvider(
      create: (_) {
        final bloc = getIt<AthleteBloc>();
        if (initial != null && initial.id > 0) {
          bloc.add(LoadAthleteById(initial.id));
        }
        return bloc;
      },
      child: _AthleteProfileContent(initial: initial),
    );
  }
}

class _AthleteProfileContent extends StatelessWidget {
  final Athlete? initial;

  const _AthleteProfileContent({this.initial});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AthleteBloc, AthleteState>(
      builder: (context, state) {
        final athlete =
            state is AthleteLoaded ? state.athlete : (initial ?? const Athlete());

        return Scaffold(
          backgroundColor: context.palette.background,
          body: CustomScrollView(
            slivers: [
              _ProfileAppBar(athlete: athlete),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(athlete: athlete),
                      const SizedBox(height: 24),
                      _InfoCard(
                        title: 'Shaxsiy ma\'lumotlar',
                        rows: [
                          InfoRow(label: 'Ism', value: athlete.firstName),
                          InfoRow(label: 'Familiya', value: athlete.lastName),
                          InfoRow(
                            label: 'Tug\'ilgan sana',
                            value: athlete.birthDate ?? '—',
                          ),
                          InfoRow(
                            label: 'Telefon',
                            value: (athlete.phone == null || athlete.phone!.isEmpty)
                                ? '—'
                                : athlete.phone!,
                          ),
                          InfoRow(
                            label: 'Yosh',
                            value:
                                athlete.age > 0 ? '${athlete.age} yosh' : '—',
                          ),
                          InfoRow(label: 'Username', value: athlete.username),
                        ],
                      ),
                      if (state is AthleteLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  final Athlete athlete;

  const _ProfileAppBar({required this.athlete});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primaryBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryNavy, Color(0xFF1E40AF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 36.h),
              AvatarImage(
                url: athlete.avatar,
                name: athlete.fullName,
                size: 96,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Athlete athlete;

  const _ProfileHeader({required this.athlete});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          athlete.fullName.isEmpty ? 'Sportchi' : athlete.fullName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '@${athlete.username}',
          style: TextStyle(color: palette.textSecondary),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<InfoRow> rows;

  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: palette.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
