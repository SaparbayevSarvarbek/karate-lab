import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/l10n/app_translations.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../exercises/presentation/views/my_exercises_view.dart';
import '../../../mashqlar/presentation/views/mashqlar_view.dart';
import '../../../tests/presentation/views/tests_library_view.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../athletes/presentation/views/athletes_list_view.dart';
import '../../../../core/widgets/app_snackbar.dart';
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
  DateTime? _lastBackPress;

  /// Orqaga tugmasini birinchi bosishda snackbar, ikkinchisida chiqish.
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
      return true; // chiqishga ruxsat
    }
    _lastBackPress = now;
    if (!mounted) return false;
    AppSnackbar.neutral(context, 'Chiqish uchun yana bir marta bosing');
    return false;
  }

  bool get isCoach => widget.role == AppConstants.roleCoach;

  /// Sahifalar bir marta quriladi va holati saqlanadi (`_LazyIndexedStack`).
  late final List<Widget> _screens = isCoach
      ? [
          CoachDashboardView(onSelectTab: _selectTab),
          const AthletesListView(),
          const MyExercisesView(),
          TestsLibraryView(userRole: widget.role),
          ProfileView(userRole: widget.role),
        ]
      : [
          AthleteDashboardView(onSelectTab: _selectTab),
          const MashqlarView(),
          TestsLibraryView(userRole: widget.role),
          ProfileView(userRole: widget.role),
        ];

  void _selectTab(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.palette.background,
        body: _LazyIndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: MainBottomNavBar(
          currentIndex: _currentIndex,
          isCoach: isCoach,
          onTap: _selectTab,
        ),
      ),
    );
  }
}

/// `IndexedStack` ning dangasa (lazy) varianti.
///
/// Oddiy `IndexedStack` barcha sahifalarni darhol quradi — natijada ilova
/// ochilganda 4-5 ta ekran bir vaqtda tarmoqqa so'rov yuboradi va sekin
/// ishga tushadi. Bu yerda sahifa faqat birinchi marta ochilganda quriladi,
/// keyin esa holati saqlanib qoladi.
class _LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _LazyIndexedStack({required this.index, required this.children});

  @override
  State<_LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<_LazyIndexedStack> {
  late final List<bool> _activated =
      List<bool>.filled(widget.children.length, false);

  @override
  void initState() {
    super.initState();
    _activated[widget.index] = true;
  }

  @override
  void didUpdateWidget(covariant _LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _activated[widget.index] = true;
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          _activated[i] ? widget.children[i] : const SizedBox.shrink(),
      ],
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
    final palette = context.palette;
    final items = isCoach ? _coachItems : _athleteItems;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.panel.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.panel.r),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.panel.r),
              border: Border.all(color: palette.border),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                child: Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: _NavBarItem(
                          icon: items[i].icon,
                          activeIcon: items[i].activeIcon,
                          label: items[i].label,
                          isSelected: currentIndex == i,
                          onTap: () => onTap(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<_NavItemData> get _coachItems => [
        _NavItemData(
          icon: Icons.space_dashboard_outlined,
          activeIcon: Icons.space_dashboard_rounded,
          label: Tr.t('navDashboard'),
        ),
        _NavItemData(
          icon: Icons.people_alt_outlined,
          activeIcon: Icons.people_alt_rounded,
          label: Tr.t('navAthletes'),
        ),
        _NavItemData(
          icon: Icons.fitness_center_outlined,
          activeIcon: Icons.fitness_center_rounded,
          label: Tr.t('navExercises'),
        ),
        _NavItemData(
          icon: Icons.assignment_outlined,
          activeIcon: Icons.assignment_rounded,
          label: Tr.t('navTests'),
        ),
        _NavItemData(
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
          label: Tr.t('navProfile'),
        ),
      ];

  List<_NavItemData> get _athleteItems => [
        _NavItemData(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: Tr.t('navHome'),
        ),
        _NavItemData(
          icon: Icons.fitness_center_outlined,
          activeIcon: Icons.fitness_center_rounded,
          label: Tr.t('navExercises'),
        ),
        _NavItemData(
          icon: Icons.assignment_outlined,
          activeIcon: Icons.assignment_rounded,
          label: Tr.t('navTests'),
        ),
        _NavItemData(
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
          label: Tr.t('navProfile'),
        ),
      ];
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItemData({
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
    final foreground =
        isSelected ? AppColors.primaryBlue : palette.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 46.w,
                height: 28.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.button.r),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: 21.w,
                  color: foreground,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navLabel.copyWith(
                  color: foreground,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
