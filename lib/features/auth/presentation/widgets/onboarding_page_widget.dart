import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingPageWidget extends StatelessWidget {
  final Map<String, String> data;

  const OnboardingPageWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIllustration(iconName: data['icon'] ?? 'sports_martial_arts'),
          const SizedBox(height: 48),
          OnboardingPageTitle(title: data['title'] ?? ''),
          const SizedBox(height: 16),
          OnboardingPageDescription(description: data['description'] ?? ''),
        ],
      ),
    );
  }
}

class OnboardingIllustration extends StatelessWidget {
  final String iconName;

  const OnboardingIllustration({super.key, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withValues(alpha: 0.1),
            AppColors.primaryBlue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Icon(
        Icons.sports_martial_arts,
        size: 100,
        color: AppColors.primaryBlue,
      ),
    );
  }
}

class OnboardingPageTitle extends StatelessWidget {
  final String title;

  const OnboardingPageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}

class OnboardingPageDescription extends StatelessWidget {
  final String description;

  const OnboardingPageDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
