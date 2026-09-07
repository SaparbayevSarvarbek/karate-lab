import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Karate mashg'ulot guruhlari (sportchi ro'yxatdan o'tishida tanlanadi).
///
/// Faqat `O'MG` hozircha tanlanadi; qolgan guruhlar "Tez orada" toastsini
/// ko'rsatadi.
class TrainingGroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String groupKey;
  final bool selectable;
  final bool isSelected;
  final VoidCallback? onSelect;

  const TrainingGroupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.groupKey,
    this.selectable = false,
    this.isSelected = false,
    this.onSelect,
  });

  void _handleTap(BuildContext context) {
    if (selectable) {
      onSelect?.call();
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Tez orada 🚀'),
            backgroundColor: AppColors.primaryBlue,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.06)
              : AppColors.backgroundWhite,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!selectable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.textHint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tez orada',
                  style: TextStyle(fontSize: 10, color: AppColors.textHint),
                ),
              )
            else
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primaryBlue : AppColors.textHint,
              ),
          ],
        ),
      ),
    );
  }
}
