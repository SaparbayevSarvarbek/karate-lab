import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/models/auth_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/uz_phone_formatter.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/phone_text_field.dart';
import '../widgets/registration_step_indicator.dart';

class RegisterView extends StatefulWidget {
  final String role;
  final String? group;

  const RegisterView({super.key, required this.role, this.group});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1 controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2 controllers
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime? _selectedDate;

  // Step 3 controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _serverError;

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final palette = context.palette;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: palette.onBrand,
              surface: palette.surface,
              onSurface: palette.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _onNext() async {
    if (!(_formKeys[_currentStep].currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();

    if (_currentStep < 2) {
      if (_serverError != null) setState(() => _serverError = null);
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Ro'yxatdan o'tish yakuni — backend API (`POST /auth/register/`).
      setState(() => _isLoading = true);

      final request = RegisterRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        role: widget.role,
        phone: UzPhoneFormatter.full(_phoneController.text.trim()),
        dateOfBirth: _dobController.text.isEmpty
            ? null
            : _dobController.text.trim(),
        height: _heightController.text.isEmpty
            ? null
            : int.tryParse(_heightController.text.trim()),
        weight: _weightController.text.isEmpty
            ? null
            : int.tryParse(_weightController.text.trim()),
        group: widget.role == AppConstants.roleAthlete ? widget.group : null,
      );

      final result = await getIt<AuthRepository>().register(request);

      if (!mounted) return;
      setState(() => _isLoading = false);

      result.fold(
        (error) {
          // Xatoni sahifada qoldiradigan (snackbar emas) banner-da ko'rsatish —
          // masalan username band bo'lsa foydalanuvchi orqaga "qaytib" ketib
          // qolyapti deb adashmasin; formada turib xabarni ko'radi.
          setState(() => _serverError = error.message);
        },
        (response) {
          AppSnackbar.success(
            context,
            Tr.t('welcomeUser', {'name': response.user.displayName}),
          );
          context.go('/main', extra: response.role.toLowerCase());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: palette.background,
      appBar: KarateAppBar(
        title: Tr.t('registerTitle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _onBack,
        ),
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? AppLoadingView(label: Tr.t('processingRegister'))
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenH.w,
                      AppSpacing.sm.h,
                      AppSpacing.screenH.w,
                      0,
                    ),
                    child: RegistrationStepIndicator(
                      currentStep: _currentStep,
                      totalSteps: 3,
                      role: widget.role,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [_buildStep1(), _buildStep2(), _buildStep3()],
                    ),
                  ),
                  AppBottomBar(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_serverError != null) ...[
                          _ServerErrorBanner(message: _serverError!),
                          SizedBox(height: AppSpacing.md.h),
                        ],
                        CustomButton(
                          text: _currentStep == 2 ? 'Yakunlash' : 'Davom etish',
                          height: 54,
                          trailingIcon: _currentStep == 2
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded,
                          onPressed: _onNext,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _stepHeader(String title, String hint) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.screenTitle.copyWith(color: palette.textPrimary),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          hint,
          style: AppTextStyles.body.copyWith(color: palette.textSecondary),
        ),
        SizedBox(height: AppSpacing.xl.h),
      ],
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.xl.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      ),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepHeader(Tr.t('personalInfo'), Tr.t('personalInfoHint')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _firstNameController,
                  label: Tr.t('firstName'),
                  hintText: Tr.t('enterFirstName'),
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) =>
                      v!.isEmpty ? Tr.t('firstNameRequired') : null,
                ),
                SizedBox(height: AppSpacing.lg.h),
                CustomTextField(
                  controller: _lastNameController,
                  label: Tr.t('lastName'),
                  hintText: Tr.t('enterLastName'),
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) =>
                      v!.isEmpty ? Tr.t('lastNameRequired') : null,
                ),
                SizedBox(height: AppSpacing.lg.h),
                PhoneTextField(
                  controller: _phoneController,
                  label: Tr.t('phone'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.xl.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      ),
      child: Form(
        key: _formKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepHeader(Tr.t('physicalInfo'), Tr.t('physicalInfoHint')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: _dobController,
                      label: Tr.t('birthDate'),
                      hintText: Tr.t('dateFormatHint'),
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      validator: (v) =>
                          v!.isEmpty ? Tr.t('selectBirthDate') : null,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _heightController,
                        label: Tr.t('height'),
                        hintText: '180',
                        suffixText: Tr.t('centimetersShort'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return Tr.t('enterValue');
                          final val = int.tryParse(v);
                          if (val == null || val > 999) {
                            return Tr.t('maximum999');
                          }
                          return null;
                        },
                        onChanged: (v) {
                          if (v.length > 3) {
                            _heightController.text = v.substring(0, 3);
                            _heightController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                    offset: _heightController.text.length,
                                  ),
                                );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: CustomTextField(
                        controller: _weightController,
                        label: Tr.t('weight'),
                        hintText: '80',
                        suffixText: Tr.t('kilogramsShort'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return Tr.t('enterValue');
                          final val = int.tryParse(v);
                          if (val == null || val > 999) {
                            return Tr.t('maximum999');
                          }
                          return null;
                        },
                        onChanged: (v) {
                          if (v.length > 3) {
                            _weightController.text = v.substring(0, 3);
                            _weightController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                    offset: _weightController.text.length,
                                  ),
                                );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH.w,
        AppSpacing.xl.h,
        AppSpacing.screenH.w,
        AppSpacing.screenBottom.h,
      ),
      child: Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepHeader(Tr.t('accountSettings'), Tr.t('accountSettingsHint')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _usernameController,
                  label: Tr.t('username'),
                  hintText: 'username',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) {
                    if (v == null || v.isEmpty) return Tr.t('enterUsername');
                    if (v.length < 3) return Tr.t('usernameMinLength');
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg.h),
                CustomTextField(
                  controller: _passwordController,
                  label: Tr.t('password'),
                  hintText: Tr.t('minimumPasswordLength'),
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.palette.textHint,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return Tr.t('enterPassword');
                    if (v.length < 6) return Tr.t('minimumPasswordLength');
                    return null;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Serverdan qaytgan xatoni forma ustida ko'rsatuvchi banner.
///
/// Sahifada qolib ko'rsatiladi (snackbar emas) — foydalanuvchi xatoni
/// o'qib, maydonlarni shu yerdan tuzatib qayta yuborishi uchun.
class _ServerErrorBanner extends StatelessWidget {
  final String message;

  const _ServerErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard.dense(
      tone: palette.error.withValues(alpha: 0.08),
      borderColor: palette.error.withValues(alpha: 0.4),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: palette.error, size: 20.w),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.label.copyWith(color: palette.error),
            ),
          ),
        ],
      ),
    );
  }
}
