import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../viewmodels/bloc/auth_bloc.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/login_footer_widget.dart';
import '../../../../core/widgets/app_snackbar.dart';

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
    AppSnackbar.info(context, 'Coming soon 🚀');
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
          AppSnackbar.error(context, state.message);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final palette = context.palette;

          return Scaffold(
            backgroundColor: palette.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH.w,
                  AppSpacing.lg.h,
                  AppSpacing.screenH.w,
                  AppSpacing.xxl.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.xxl.h),
                      const LoginHeaderWidget(),
                      SizedBox(height: AppSpacing.xxxl.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            CustomTextField(
                              controller: _usernameController,
                              label: 'Foydalanuvchi nomi',
                              hintText: 'Loginingizni kiriting',
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (v) =>
                                  v!.isEmpty ? 'Username kiriting' : null,
                            ),
                            SizedBox(height: AppSpacing.lg.h),
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Parol',
                              hintText: 'Parolingizni kiriting',
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: palette.textHint,
                                ),
                                onPressed: _togglePassword,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Parolni kiriting' : null,
                            ),
                            SizedBox(height: AppSpacing.xs.h),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: _onForgotPassword,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Parolni unutdingizmi?',
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            CustomButton(
                              text: 'Kirish',
                              height: 54,
                              trailingIcon: Icons.arrow_forward_rounded,
                              onPressed: isLoading ? null : _onLogin,
                              isLoading: isLoading,
                            ),
                          ],
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
