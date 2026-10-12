import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_selection_card.dart';
import '../../../../core/widgets/app_step_badge.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  String? _selectedRole;

  void _onRoleSelected(String role) {
    setState(() => _selectedRole = role);
  }

  Future<void> _onContinue() async {
    final role = _selectedRole;
    if (role == null) return;

    // Sportchi uchun avval guruh tanlash sahifasi chiqadi.
    if (role == AppConstants.roleAthlete) {
      final group = await context.push<String>('/group-selection');
      if (group == null || !mounted) return; // Bekor qilindi
      context.push('/register', extra: (role: role, group: group));
    } else {
      context.push('/register', extra: (role: role, group: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: const KarateAppBar(title: 'KarateLab AI', showLogo: true),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                children: [
                  AppStepBadge(
                    label: '${Tr.t('setupBadge')} · 1 / 2',
                    icon: Icons.tune_rounded,
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Rolingizni tanlang',
                    style: AppTextStyles.screenTitle
                        .copyWith(color: palette.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Ilovadan qanday maqsadda foydalanmoqchisiz?',
                    style: AppTextStyles.body
                        .copyWith(color: palette.textSecondary),
                  ),
                  SizedBox(height: 22.h),
                  AppSelectionCard(
                    icon: Icons.sports_martial_arts,
                    title: 'Sportchi',
                    subtitle: Tr.t('athleteSubtitle'),
                    selected: _selectedRole == AppConstants.roleAthlete,
                    onTap: () => _onRoleSelected(AppConstants.roleAthlete),
                  ),
                  SizedBox(height: 12.h),
                  AppSelectionCard(
                    icon: Icons.assignment_ind_outlined,
                    title: 'Murabbiy',
                    subtitle: Tr.t('coachSubtitle'),
                    selected: _selectedRole == AppConstants.roleCoach,
                    onTap: () => _onRoleSelected(AppConstants.roleCoach),
                  ),
                ],
              ),
            ),
            AppBottomBar(
              child: CustomButton(
                text: 'Davom etish',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _selectedRole != null ? _onContinue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
