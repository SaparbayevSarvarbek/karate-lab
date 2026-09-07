import 'package:flutter/material.dart';

class RoleSelectionHeader extends StatelessWidget {
  const RoleSelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        RoleSelectionTitle(),
        SizedBox(height: 8),
        RoleSelectionSubtitle(),
      ],
    );
  }
}

class RoleSelectionTitle extends StatelessWidget {
  const RoleSelectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Rolingizni tanlang',
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}

class RoleSelectionSubtitle extends StatelessWidget {
  const RoleSelectionSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Ilovadan qanday maqsadda foydalanmoqchisiz?',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
