import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_step_badge.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../widgets/language_option_widget.dart';

class LanguageSelectionView extends StatefulWidget {
  const LanguageSelectionView({super.key});

  @override
  State<LanguageSelectionView> createState() => _LanguageSelectionViewState();
}

class _LanguageSelectionViewState extends State<LanguageSelectionView> {
  String _selectedLanguage = 'uz';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = LocaleController.instance.language;
  }

  void _onLanguageSelected(String code) {
    setState(() {
      _selectedLanguage = code;
    });
  }

  Future<void> _onContinue() async {
    if (_saving) return;
    setState(() => _saving = true);

    final prefs = await SharedPrefsService.getInstance();
    final isLoggedIn = prefs.getAccessToken() != null;

    await LocaleController.instance.setLanguage(_selectedLanguage);

    if (isLoggedIn) {
      await getIt<SettingsRepository>().updateLanguage(_selectedLanguage);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(Tr.t('languageSaved')),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/main');
      }
      return;
    }

    await prefs.setFirstTimeLaunchDone();
    if (!mounted) return;
    context.go('/onboarding');
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
                    label: '${Tr.t('setupBadge')} · 1 / 3',
                    icon: Icons.tune_rounded,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    Tr.t('chooseLanguage'),
                    style: AppTextStyles.screenTitle
                        .copyWith(color: palette.textPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    Tr.t('chooseLanguageHint'),
                    style: AppTextStyles.body
                        .copyWith(color: palette.textSecondary),
                  ),
                  SizedBox(height: 24.h),
                  LanguageOptionWidget(
                    title: 'O\'zbekcha',
                    subtitle: Tr.t('langUzSubtitle'),
                    flag: '🇺🇿',
                    code: 'uz',
                    selectedLanguage: _selectedLanguage,
                    onTap: _onLanguageSelected,
                  ),
                  SizedBox(height: 12.h),
                  LanguageOptionWidget(
                    title: 'English',
                    subtitle: Tr.t('langEnSubtitle'),
                    flag: '🇺🇸',
                    code: 'en',
                    selectedLanguage: _selectedLanguage,
                    onTap: _onLanguageSelected,
                  ),
                ],
              ),
            ),
            AppBottomBar(
              child: CustomButton(
                text: Tr.t('continueText'),
                trailingIcon: Icons.arrow_forward_rounded,
                isLoading: _saving,
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
