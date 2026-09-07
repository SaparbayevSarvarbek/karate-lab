import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/api/models/profile_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/profile_repository.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/models/profile_model.dart';
import '../../../../core/services/shared_prefs_service.dart';
import '../../../../core/utils/uz_phone_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
    try {
      final prefs = await SharedPrefsService.getInstance();
      final saved = await prefs.getUserProfile();

      // Ism, telefon, tug'ilgan sana API dan; bo'y/vazn lokal yoki API dan.
      final result = await getIt<ProfileRepository>().getProfile();
      result.fold(
        (_) => _fillFromLocal(saved),
        (profile) {
          final names = profile.fullName.trim().split(RegExp(r'\s+'));
          _firstNameController.text = names.isNotEmpty ? names.first : '';
          _lastNameController.text =
              names.length > 1 ? names.sublist(1).join(' ') : '';
          _phoneController.text = UzPhoneFormatter.field(profile.phone);
          _setBirthDate(DateTime.tryParse(profile.birthDate ?? ''));
          if (profile.avatar != null && profile.avatar!.isNotEmpty) {
            _avatarUrl = profile.avatar;
          }
          final height = saved?.heightCm ?? profile.heightCm;
          final weight = saved?.weightKg ?? profile.weightKg;
          _heightController.text = height?.toString() ?? '';
          _weightController.text = weight?.toString() ?? '';
        },
      );
      if (_heightController.text.isEmpty) {
        _heightController.text = saved?.heightCm?.toString() ?? '';
      }
      if (_weightController.text.isEmpty) {
        _weightController.text = saved?.weightKg?.toString() ?? '';
      }
    } catch (_) {
      _fillFromLocal(null);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _fillFromLocal(ProfileModel? saved) {
    if (saved == null) return;
    _firstNameController.text = saved.firstName;
    _lastNameController.text = saved.lastName;
    _phoneController.text = UzPhoneFormatter.field(saved.phone);
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
      final result =
          await getIt<ProfileRepository>().uploadAvatar(picked.path);
      if (!mounted) return;
      await result.fold(
        (error) async => _showSnackBar(error.message, AppColors.error),
        (_) async {
          _showSnackBar('Foto muvaffaqiyatli yuklandi', AppColors.success);
          final updated = await getIt<ProfileRepository>().getProfile();
          if (!mounted) return;
          updated.fold(
            (_) {},
            (profile) => setState(() => _avatarUrl = profile.avatar),
          );
        },
      );
    } catch (_) {
      _showSnackBar('Foto yuklashda xatolik yuz berdi', AppColors.error);
    } finally {
      if (mounted) setState(() => _avatarBusy = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
        await prefs.saveUserProfile(ProfileModel(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: phone,
          dateOfBirth: birthDate,
          heightCm: int.tryParse(_heightController.text.trim()),
          weightKg: int.tryParse(_weightController.text.trim()),
        ));
      } catch (_) {}

      final result =
          await getIt<ProfileRepository>().updateProfile(request);

      if (!mounted) return;

      await result.fold(
        (error) async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
        },
        (profile) async {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Profil saqlandi'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
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
      appBar: AppBar(
        title: const Text('Profilni tahrirlash'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
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
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Shaxsiy ma\'lumotlar'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstNameController,
                              hintText: 'Ism',
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ism kiriting' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameController,
                              hintText: 'Familiya',
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Familiya kiriting' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PhoneTextField(controller: _phoneController),
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Jismoniy ko\'rsatkichlar'),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickBirthDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _dobController,
                            hintText: 'Tug\'ilgan sana (YYYY-MM-DD)',
                            prefixIcon: const Icon(Icons.cake_outlined),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _heightController,
                              hintText: 'Bo\'y (sm)',
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.height),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Center(child: Text('sm', style: TextStyle(color: AppColors.textHint))),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _weightController,
                              hintText: 'Vazn (kg)',
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.monitor_weight_outlined),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Center(child: Text('kg', style: TextStyle(color: AppColors.textHint))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: CustomButton(
                  text: _saving ? 'Saqlanmoqda...' : 'Saqlash',
                  isLoading: _saving,
                  onPressed: _save,
                ),
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
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
            child: hasAvatar
                ? null
                : const Icon(Icons.person, size: 48, color: AppColors.textHint),
          ),
          if (busy)
            Positioned.fill(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.black.withValues(alpha: 0.35),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: busy ? null : onCameraTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16));
  }
}
