import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/role_card_widget.dart';
import '../widgets/role_selection_header.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  String? _selectedRole;

  void _onRoleSelected(String role) {
    setState(() => _selectedRole = role);
  }

  Future<void> _onContinue() async {
    final role = _selectedRole;
    if (role == null) return;

    // Sportchi uchun avval guruh tanlash sahifasi chiqadi.
    if (role == AppConstants.roleAthlete) {
      final group = await context.push<String>('/group-selection');
      if (group == null || !mounted) return; // Bekor qilindi
      context.push('/register', extra: (role: role, group: group));
    } else {
      context.push('/register', extra: (role: role, group: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KarateLab AI'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const RoleSelectionHeader(),
              const SizedBox(height: 48),
              RoleCardsRow(
                selectedRole: _selectedRole,
                onRoleSelected: _onRoleSelected,
              ),
              const Spacer(),
              CustomButton(
                text: 'Davom etish',
                onPressed: _selectedRole != null ? _onContinue : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCardsRow extends StatelessWidget {
  final String? selectedRole;
  final void Function(String) onRoleSelected;

  const RoleCardsRow({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleCardWidget(
          title: 'Sportchi',
          subtitle: 'Mashqlar va natijalarni kuzatish',
          icon: Icons.sports_martial_arts,
          role: AppConstants.roleAthlete,
          selectedRole: selectedRole,
          onTap: onRoleSelected,
        ),
        const SizedBox(height: 16),
        RoleCardWidget(
          title: 'Murabbiy',
          subtitle: 'Sportchilarni boshqarish va tahlil',
          icon: Icons.assignment_ind,
          role: AppConstants.roleCoach,
          selectedRole: selectedRole,
          onTap: onRoleSelected,
        ),
      ],
    );
  }
}
