import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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
    return Column(
      children: [
        LoginEmailField(controller: emailController),
        const SizedBox(height: 16),
        LoginPasswordField(
          controller: passwordController,
          obscurePassword: obscurePassword,
          onToggle: onTogglePassword,
        ),
        const SizedBox(height: 8),
        LoginForgotPasswordButton(onTap: onForgotPassword),
      ],
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
        child: const Text(
          'Parolni unutdingizmi?',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
