import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../mashqlar/presentation/views/mashqlar_view.dart';
import '../../../tests/presentation/views/tests_library_view.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../athletes/presentation/views/athletes_list_view.dart';
import 'coach_dashboard_view.dart';
import 'athlete_dashboard_view.dart';

class MainLayoutView extends StatefulWidget {
  final String role;

  const MainLayoutView({super.key, required this.role});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;

  bool get isCoach => widget.role == AppConstants.roleCoach;

  List<Widget> get _coachScreens => [
        CoachDashboardView(onSelectTab: _selectTab),
        const AthletesListView(),
        TestsLibraryView(userRole: widget.role),
        ProfileView(userRole: widget.role),
      ];

  List<Widget> get _athleteScreens => [
        AthleteDashboardView(onSelectTab: _selectTab),
        const MashqlarView(),
        TestsLibraryView(userRole: widget.role),
        ProfileView(userRole: widget.role),
      ];

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final screens = isCoach ? _coachScreens : _athleteScreens;

    return Scaffold(
      backgroundColor: context.palette.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        isCoach: isCoach,
        onTap: _selectTab,
      ),
    );
  }
}

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isCoach;
  final void Function(int) onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isCoach,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = isCoach ? _coachItems : _athleteItems;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              return Expanded(
                child: _NavBarItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  List<_NavItemData> get _coachItems => [
    _NavItemData(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: Tr.t('navDashboard')),
    _NavItemData(icon: Icons.people_outline, activeIcon: Icons.people, label: Tr.t('navAthletes')),
    _NavItemData(icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: Tr.t('navTests')),
    _NavItemData(icon: Icons.person_outline, activeIcon: Icons.person, label: Tr.t('navProfile')),
  ];

  List<_NavItemData> get _athleteItems => [
    _NavItemData(icon: Icons.home_outlined, activeIcon: Icons.home, label: Tr.t('navHome')),
    _NavItemData(icon: Icons.fitness_center_outlined, activeIcon: Icons.fitness_center, label: Tr.t('navExercises')),
    _NavItemData(icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: Tr.t('navTests')),
    _NavItemData(icon: Icons.person_outline, activeIcon: Icons.person, label: Tr.t('navProfile')),
  ];
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primaryBlue, Color(0xFF2B7AFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? Colors.white : palette.textSecondary,
                size: 22.w,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : palette.textSecondary,
                fontSize: 10.5.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
