import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/settings_repository.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/custom_button.dart';
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
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        title: const Text('KarateLab AI'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const LanguageSelectionHeader(),
              const SizedBox(height: 32),
              LanguageOptionWidget(
                title: 'O\'zbekcha',
                flag: '🇺🇿',
                code: 'uz',
                selectedLanguage: _selectedLanguage,
                onTap: _onLanguageSelected,
              ),
              const SizedBox(height: 16),
              LanguageOptionWidget(
                title: 'English',
                flag: '🇺🇸',
                code: 'en',
                selectedLanguage: _selectedLanguage,
                onTap: _onLanguageSelected,
              ),
              const Spacer(),
              CustomButton(
                text: Tr.t('continueText'),
                isLoading: _saving,
                onPressed: _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageSelectionHeader extends StatelessWidget {
  const LanguageSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.t('chooseLanguage'),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: palette.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          Tr.t('chooseLanguageHint'),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
              ),
        ),
      ],
    );
  }
}
