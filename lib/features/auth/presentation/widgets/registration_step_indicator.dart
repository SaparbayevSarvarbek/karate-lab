import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class RegistrationStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String role;

  const RegistrationStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RegistrationRoleBadge(role: role),
        const SizedBox(height: 12),
        RegistrationProgressBar(currentStep: currentStep, totalSteps: totalSteps),
        const SizedBox(height: 8),
        RegistrationStepText(currentStep: currentStep, totalSteps: totalSteps),
      ],
    );
  }
}

class RegistrationRoleBadge extends StatelessWidget {
  final String role;

  const RegistrationRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            role == AppConstants.roleCoach ? Icons.assignment_ind : Icons.sports_martial_arts,
            color: AppColors.primaryBlue,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            role == AppConstants.roleCoach ? 'Murabbiy' : 'Sportchi',
            style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class RegistrationProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressBar({super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: (currentStep + 1) / totalSteps,
        backgroundColor: AppColors.border,
        color: AppColors.primaryBlue,
        minHeight: 6,
      ),
    );
  }
}

class RegistrationStepText extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationStepText({super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${currentStep + 1}/$totalSteps qadam',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
    );
  }
}
