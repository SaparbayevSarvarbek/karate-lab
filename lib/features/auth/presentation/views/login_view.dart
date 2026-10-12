import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../viewmodels/bloc/auth_bloc.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/login_footer_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _onForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon 🚀'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      LoginRequested(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  void _onRegister() {
    context.push('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/main', extra: state.role);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final palette = context.palette;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.sm.h,
                  AppSpacing.screenH.w,
                  AppSpacing.xxl.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.xxxl.h),
                      const LoginHeaderWidget(),
                      SizedBox(height: AppSpacing.xxxl.h),
                      Container(
                        padding: EdgeInsets.all(AppSpacing.lg.w),
                        decoration: BoxDecoration(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(AppRadius.card.r),
                          border: Border.all(color: palette.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              controller: _usernameController,
                              hintText: 'Foydalanuvchi nomi',
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (v) =>
                                  v!.isEmpty ? 'Username kiriting' : null,
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: 'Parol',
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textHint,
                                ),
                                onPressed: _togglePassword,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Parolni kiriting' : null,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _onForgotPassword,
                                child: Text(
                                  'Parolni unutdingizmi?',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm.h),
                            CustomButton(
                              text: 'Kirish',
                              onPressed: isLoading ? null : _onLogin,
                              isLoading: isLoading,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl.h),
                      LoginFooterWidget(onRegister: _onRegister),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
