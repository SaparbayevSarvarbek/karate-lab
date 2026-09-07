import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LoginLogoIcon(),
        SizedBox(height: 24),
        LoginWelcomeTitle(),
        SizedBox(height: 8),
        LoginWelcomeSubtitle(),
      ],
    );
  }
}

class LoginLogoIcon extends StatelessWidget {
  const LoginLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.sports_martial_arts, size: 48, color: Colors.white),
    );
  }
}

class LoginWelcomeTitle extends StatelessWidget {
  const LoginWelcomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Xush kelibsiz!',
      style: Theme.of(context).textTheme.displayMedium,
      textAlign: TextAlign.center,
    );
  }
}

class LoginWelcomeSubtitle extends StatelessWidget {
  const LoginWelcomeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Profilingizga kiring',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }
}
