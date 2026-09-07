import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/api/models/auth_models.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../core/utils/uz_phone_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  Future<void> _selectDate(BuildContext context) async {
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
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
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

  Future<void> _onNext() async {
    if (!(_formKeys[_currentStep].currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();

    if (_currentStep < 2) {
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
        dateOfBirth:
            _dobController.text.isEmpty ? null : _dobController.text.trim(),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Xush kelibsiz, ${response.user.displayName}!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.go('/main', extra: response.role.toLowerCase());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Ro\'yxatdan o\'tish'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Ro\'yxatdan o\'tkazilmoqda...', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButton(
                text: _currentStep == 2 ? 'Yakunlash' : 'Davom etish',
                onPressed: _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shaxsiy ma\'lumotlar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('1/3 qadam', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _firstNameController,
              hintText: 'Ism',
              prefixIcon: const Icon(Icons.person),
              validator: (v) => v!.isEmpty ? 'Ismni kiriting' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _lastNameController,
              hintText: 'Familiya',
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => v!.isEmpty ? 'Familiyani kiriting' : null,
            ),
            const SizedBox(height: 16),
            PhoneTextField(controller: _phoneController),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jismoniy ma\'lumotlar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('2/3 qadam', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: _dobController,
                  hintText: 'Tug\'ilgan sana',
                  prefixIcon: const Icon(Icons.calendar_today),
                  validator: (v) => v!.isEmpty ? 'Tug\'ilgan sanani tanlang' : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _heightController,
                    hintText: 'Bo\'y',
                    prefixIcon: const Icon(Icons.height),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12, top: 12),
                      child: Text('sm', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Kiriting';
                      final val = int.tryParse(v);
                      if (val == null || val > 999) return 'Max 999';
                      return null;
                    },
                    onChanged: (v) {
                      if (v.length > 3) {
                        _heightController.text = v.substring(0, 3);
                        _heightController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _heightController.text.length),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _weightController,
                    hintText: 'Vazn',
                    prefixIcon: const Icon(Icons.monitor_weight_outlined),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12, top: 12),
                      child: Text('kg', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Kiriting';
                      final val = int.tryParse(v);
                      if (val == null || val > 999) return 'Max 999';
                      return null;
                    },
                    onChanged: (v) {
                      if (v.length > 3) {
                        _weightController.text = v.substring(0, 3);
                        _weightController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _weightController.text.length),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            if (widget.role == AppConstants.roleCoach) ...[
              const SizedBox(height: 16),
              const RegistrationCoachNote(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hisob sozlamalari', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('3/3 qadam', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _usernameController,
              hintText: 'Foydalanuvchi nomi',
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Username kiriting';
                if (v.length < 3) return 'Kamida 3 ta belgi kiriting';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Parol',
              obscureText: _obscurePassword,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Parolni kiriting';
                if (v.length < 6) return 'Kamida 6 ta belgi kiriting';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationCoachNote extends StatelessWidget {
  const RegistrationCoachNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Murabbiy sifatida ro\'yxatdan o\'tayapsiz. Siz sportchilarni boshqara olasiz.',
              style: TextStyle(color: AppColors.primaryBlue, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
