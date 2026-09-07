import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_palette.dart';

class LanguageOptionWidget extends StatelessWidget {
  final String title;
  final String flag;
  final String code;
  final String selectedLanguage;
  final void Function(String) onTap;

  const LanguageOptionWidget({
    super.key,
    required this.title,
    required this.flag,
    required this.code,
    required this.selectedLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isSelected = selectedLanguage == code;
    return InkWell(
      onTap: () => onTap(code),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : palette.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.05)
              : palette.surface,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : palette.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }
}
