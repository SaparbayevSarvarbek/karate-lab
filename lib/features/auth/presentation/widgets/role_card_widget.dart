import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RoleCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String role;
  final String? selectedRole;
  final void Function(String) onTap;

  const RoleCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.role,
    required this.selectedRole,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => onTap(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.06)
              : AppColors.backgroundWhite,
        ),
        child: Row(
          children: [
            RoleCardIcon(icon: icon, isSelected: isSelected),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoleCardTitle(title: title, isSelected: isSelected),
                  const SizedBox(height: 4),
                  RoleCardSubtitle(subtitle: subtitle),
                ],
              ),
            ),
            if (isSelected) const RoleCardSelectedBadge(),
          ],
        ),
      ),
    );
  }
}

class RoleCardIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const RoleCardIcon({super.key, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBlue
            : AppColors.backgroundLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 32,
        color: isSelected ? Colors.white : AppColors.textSecondary,
      ),
    );
  }
}

class RoleCardTitle extends StatelessWidget {
  final String title;
  final bool isSelected;

  const RoleCardTitle({super.key, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 16,
        color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RoleCardSubtitle extends StatelessWidget {
  final String subtitle;

  const RoleCardSubtitle({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class RoleCardSelectedBadge extends StatelessWidget {
  const RoleCardSelectedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.check_circle,
      color: AppColors.primaryBlue,
      size: 20,
    );
  }
}
