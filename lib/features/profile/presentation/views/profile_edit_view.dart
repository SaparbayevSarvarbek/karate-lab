import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/api/models/profile_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/repositories/profile_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/models/profile_model.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/utils/uz_phone_formatter.dart';
import '../../../../core/widgets/app_bottom_bar.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/karate_app_bar.dart';
import '../../../../core/widgets/phone_text_field.dart';

/// Profil ma'lumotlarini tahrirlash sahifasi (Swagger: `GET/PUT /profile/`).
///
/// Bo'y/vazn API (`heightCm`/`weightKg`) da saqlanadi va zaxira sifatida
/// SharedPrefs'dagi `user_profile` kalitida ham dublikat saqlanadi.
class ProfileEditView extends StatefulWidget {
  final String? role;

  const ProfileEditView({super.key, this.role});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _saving = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  final TextEditingController _dobController = TextEditingController();
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  DateTime? _birthDate;
  String? _avatarUrl;
  bool _avatarBusy = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final role = widget.role ?? AppConstants.roleAthlete;
    final isCoach = role == AppConstants.roleCoach;

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();

    _load(isCoach);
  }

  Future<void> _load(bool isCoach) async {
    // Lokal zaxira: API ishlamay qolsa ishlatiladi.
    ProfileModel? saved;
    try {
      final prefs = await SharedPrefsService.getInstance();
      saved = await prefs.getUserProfile();
    } catch (_) {
      saved = null;
    }

    // API asosiy manba.
    try {
      final result = await getIt<ProfileRepository>().getProfile();
      result.fold((error) {
        _fillFromLocal(saved);
        // Lokal zaxira ham bo'lmasa, sahifa sababsiz bo'sh ko'rinmasin.
        if (saved == null && mounted) {
          AppSnackbar.error(context, error.message);
        }
      }, _fillFromApi);
    } catch (_) {
      _fillFromLocal(saved);
    }

    // API bo'y/vazn keltirmagan bo'lsa lokal zaxirani ishlat.
    if (_heightController.text.isEmpty && saved?.heightCm != null) {
      _heightController.text = saved!.heightCm!.toString();
    }
    if (_weightController.text.isEmpty && saved?.weightKg != null) {
      _weightController.text = saved!.weightKg!.toString();
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _fillFromApi(Profile profile) {
    final names = profile.fullName.trim().split(RegExp(r'\s+'));
    _firstNameController.text = names.isNotEmpty ? names.first : '';
    _lastNameController.text = names.length > 1
        ? names.sublist(1).join(' ')
        : '';
    _phoneController.text = UzPhoneFormatter.field(profile.phone);
    _setBirthDate(DateTime.tryParse(profile.birthDate ?? ''));
    if (profile.avatar != null && profile.avatar!.isNotEmpty) {
      _avatarUrl = profile.avatar;
    }
    _heightController.text = profile.heightCm?.toString() ?? '';
    _weightController.text = profile.weightKg?.toString() ?? '';
  }

  void _fillFromLocal(ProfileModel? saved) {
    if (saved == null) return;
    _firstNameController.text = saved.firstName;
    _lastNameController.text = saved.lastName;
    _phoneController.text = UzPhoneFormatter.field(saved.phone);
    _setBirthDate(DateTime.tryParse(saved.dateOfBirth ?? ''));
    if (saved.heightCm != null) {
      _heightController.text = saved.heightCm!.toString();
    }
    if (saved.weightKg != null) {
      _weightController.text = saved.weightKg!.toString();
    }
  }

  void _setBirthDate(DateTime? date) {
    if (date == null) return;
    _birthDate = date;
    _dobController.text =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _setBirthDate(picked));
    }
  }

  Future<void> _pickAvatar() async {
    if (_avatarBusy) return;
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() => _avatarBusy = true);
      final result = await getIt<ProfileRepository>().uploadAvatar(picked.path);
      if (!mounted) return;
      await result.fold(
        (error) async {
          if (mounted) AppSnackbar.error(context, error.message);
        },
        (_) async {
          AppSnackbar.success(context, Tr.t('profilePhotoUploaded'));
          final updated = await getIt<ProfileRepository>().getProfile();
          if (!mounted) return;
          updated.fold(
            (_) {},
            (profile) => setState(() => _avatarUrl = profile.avatar),
          );
        },
      );
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, Tr.t('profilePhotoUploadError'));
      }
    } finally {
      if (mounted) setState(() => _avatarBusy = false);
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
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    final fullName =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
            .trim();
    final phone = UzPhoneFormatter.full(_phoneController.text.trim());
    final birthDate = _birthDate == null
        ? null
        : '${_birthDate!.year.toString().padLeft(4, '0')}-'
              '${_birthDate!.month.toString().padLeft(2, '0')}-'
              '${_birthDate!.day.toString().padLeft(2, '0')}';

    final request = UpdateProfileRequest(
      fullName: fullName,
      phone: phone,
      birthDate: birthDate,
      heightCm: int.tryParse(_heightController.text.trim()),
      weightKg: int.tryParse(_weightController.text.trim()),
    );

    try {
      try {
        final prefs = await SharedPrefsService.getInstance();
        await prefs.saveUserProfile(
          ProfileModel(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: phone,
            dateOfBirth: birthDate,
            heightCm: int.tryParse(_heightController.text.trim()),
            weightKg: int.tryParse(_weightController.text.trim()),
          ),
        );
      } catch (_) {}

      final result = await getIt<ProfileRepository>().updateProfile(request);

      if (!mounted) return;

      await result.fold(
        (error) async {
          AppSnackbar.error(context, error.message);
        },
        (profile) async {
          if (!mounted) return;
          AppSnackbar.success(context, Tr.t('profileSaved'));
          context.pop<Profile>(profile);
        },
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: KarateAppBar(title: Tr.t('editProfileTitle')),
      body: _isLoading
          ? const AppLoadingView()
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.screenTop.h,
                  AppSpacing.screenH.w,
                  AppSpacing.screenBottom.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AvatarSection(
                        avatarUrl: _avatarUrl,
                        busy: _avatarBusy,
                        onCameraTap: _pickAvatar,
                      ),
                      SizedBox(height: AppSpacing.xxl.h),
                      AppSectionHeader(title: Tr.t('personalInformation')),
                      SizedBox(height: AppSpacing.md.h),
                      AppCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _firstNameController,
                                    hintText: Tr.t('firstName'),
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? Tr.t('firstNameRequired')
                                        : null,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md.w),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _lastNameController,
                                    hintText: Tr.t('lastName'),
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? Tr.t('lastNameRequired')
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            PhoneTextField(controller: _phoneController),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.sectionGap.h),
                      AppSectionHeader(title: Tr.t('physicalInformation')),
                      SizedBox(height: AppSpacing.md.h),
                      AppCard(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickBirthDate,
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  controller: _dobController,
                                  hintText: Tr.t('birthDateFormatHint'),
                                  prefixIcon: const Icon(Icons.cake_outlined),
                                  suffixIcon: const Icon(
                                    Icons.calendar_today_rounded,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _heightController,
                                    hintText: Tr.t('height'),
                                    keyboardType: TextInputType.number,
                                    prefixIcon: const Icon(
                                      Icons.height_rounded,
                                    ),
                                    suffixText: Tr.t('centimetersShort'),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md.w),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _weightController,
                                    hintText: Tr.t('weight'),
                                    keyboardType: TextInputType.number,
                                    prefixIcon: const Icon(
                                      Icons.monitor_weight_outlined,
                                    ),
                                    suffixText: Tr.t('kilogramsShort'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : AppBottomBar(
              child: CustomButton(
                text: _saving ? Tr.t('saving') : Tr.t('save'),
                isLoading: _saving,
                onPressed: _save,
                trailingIcon: Icons.check_rounded,
              ),
            ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String? avatarUrl;
  final bool busy;
  final VoidCallback onCameraTap;

  const _AvatarSection({
    required this.avatarUrl,
    required this.busy,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 44.w,
                backgroundColor: palette.backgroundLight,
                backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
                child: hasAvatar
                    ? null
                    : Icon(
                        Icons.person_rounded,
                        size: 44.w,
                        color: palette.textHint,
                      ),
              ),
              if (busy)
                Positioned.fill(
                  child: CircleAvatar(
                    radius: 44.w,
                    backgroundColor: Colors.black.withValues(alpha: 0.35),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              // Kamera tugmasi: ko'rinishi 34px, bosilish maydoni 44px.
              PositionedDirectional(
                bottom: -2,
                end: -2,
                child: GestureDetector(
                  onTap: busy ? null : onCameraTap,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 44.w,
                    height: 44.w,
                    child: Center(
                      child: Container(
                        width: 34.w,
                        height: 34.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: palette.background,
                            width: 2.w,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 17.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'Rasmni o\'zgartirish uchun bosing',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
