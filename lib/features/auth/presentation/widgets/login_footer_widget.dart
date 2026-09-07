import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LoginFooterWidget extends StatelessWidget {
  final VoidCallback onRegister;

  const LoginFooterWidget({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hisobingiz yo\'qmi?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: onRegister,
          child: const Text(
            'Ro\'yxatdan o\'tish',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
