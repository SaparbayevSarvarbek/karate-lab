import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_selection_card.dart';
import '../../../../core/widgets/app_step_badge.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';

/// Karate mashg'ulot guruhini tanlash sahifasi (sportchi ro'yxatdan o'tishida).
///
/// Tanlangan guruh `context.pop(guruh)` orqali qaytariladi. Faqat `O'MG`
/// hozircha tanlanadi; qolgan guruhlar "Tez orada" toastini ko'rsatadi.
class GroupSelectionView extends StatefulWidget {
  final String? initialGroup;

  const GroupSelectionView({super.key, this.initialGroup});

  @override
  State<GroupSelectionView> createState() => _GroupSelectionViewState();
}

class _GroupSelectionViewState extends State<GroupSelectionView> {
  String? _selectedGroup;

  // (title, subtitle, selectable)
  static const List<(String, String, bool)> _groups = [
    ('SSG', 'sport-sog\'lomlashtirish guruhi', false),
    ('BTG', 'boshlang\'ich tayyorgarlik guruhi', false),
    ('O\'MG', 'o\'quv-mashg\'ulot guruhi', true),
    ('SKEG', 'sportda kamolotga erishish guruhi', false),
    ('OSMG', 'oliy sport mahorati guruhi', false),
  ];

  @override
  void initState() {
    super.initState();
    _selectedGroup = widget.initialGroup;
  }

  void _onSelect(String group, bool selectable) {
    if (!selectable) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Tez orada 🚀'),
            backgroundColor: AppColors.primaryBlue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    setState(() => _selectedGroup = group);
  }

  void _onContinue() {
    final group = _selectedGroup;
    if (group == null) return;
    context.pop(group);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: const KarateAppBar(
        title: 'Mashg\'ulot guruhini tanlang',
        showLogo: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                children: [
                  AppStepBadge(
                    label: Tr.t('groupBadge'),
                    icon: Icons.groups_rounded,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Guruhni tanlang',
                    style: AppTextStyles.screenTitle
                        .copyWith(color: palette.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    Tr.t('groupSelectHint'),
                    style: AppTextStyles.body
                        .copyWith(color: palette.textSecondary),
                  ),
                  SizedBox(height: 24.h),
                  for (final (title, subtitle, selectable) in _groups) ...[
                    AppSelectionCard(
                      icon: Icons.workspace_premium_outlined,
                      title: title,
                      subtitle: subtitle,
                      selected: _selectedGroup == title,
                      enabled: selectable,
                      trailingLabel:
                          selectable ? null : Tr.t('comingSoonBadge'),
                      onTap: () => _onSelect(title, selectable),
                    ),
                    if (title != _groups.last.$1) SizedBox(height: 12.h),
                  ],
                ],
              ),
            ),
            AppBottomBar(
              child: CustomButton(
                text: 'Davom etish',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _selectedGroup != null ? _onContinue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
