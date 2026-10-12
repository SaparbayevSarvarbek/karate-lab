import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: [
          LoginEmailField(controller: emailController),
          SizedBox(height: AppSpacing.lg.h),
          LoginPasswordField(
            controller: passwordController,
            obscurePassword: obscurePassword,
            onToggle: onTogglePassword,
          ),
          SizedBox(height: AppSpacing.xs.h),
          LoginForgotPasswordButton(onTap: onForgotPassword),
        ],
      ),
    );
  }
}

class LoginEmailField extends StatelessWidget {
  final TextEditingController controller;

  const LoginEmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Email manzil',
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Iltimos, email kiriting';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Noto\'g\'ri email format';
        }
        return null;
      },
    );
  }
}

class LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onToggle;

  const LoginPasswordField({
    super.key,
    required this.controller,
    required this.obscurePassword,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Parol',
      obscureText: obscurePassword,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textHint,
        ),
        onPressed: onToggle,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Iltimos, parolni kiriting';
        }
        if (value.length < 6) {
          return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
        }
        return null;
      },
    );
  }
}

class LoginForgotPasswordButton extends StatelessWidget {
  final VoidCallback onTap;

  const LoginForgotPasswordButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          'Parolni unutdingizmi?',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
