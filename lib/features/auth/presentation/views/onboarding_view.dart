import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/onboarding_dot_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'AI yordamida chempionlik sari',
      'description':
          'KarateLab AI ga xush kelibsiz. Bizning tizim sun\'iy intellekt yordamida sportchilarni tahlil qilib, chempionlik sari yetaklaydi.',
      'icon': 'sports_martial_arts',
    },
    {
      'title': 'Mashqlarni kuzatish',
      'description':
          'Barcha mashqlar natijalarini va statistikasini bir joyda kuzatib boring.',
      'icon': 'fitness_center',
    },
    {
      'title': 'Murabbiy va Sportchi',
      'description':
          'Ilova murabbiylar va sportchilar uchun alohida qulayliklarni taklif etadi.',
      'icon': 'people',
    },
  ];

  void _onNext() {
    if (_currentPage == _onboardingData.length - 1) {
      context.go('/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    data: _onboardingData[index],
                  );
                },
              ),
            ),
            OnboardingBottomSection(
              currentPage: _currentPage,
              totalPages: _onboardingData.length,
              onNext: _onNext,
              onSkip: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingBottomSection extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingBottomSection({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingDotIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: currentPage == totalPages - 1 ? 'Boshlash' : 'Keyingisi',
            onPressed: onNext,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: currentPage != totalPages - 1
                ? TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'O\'tkazib yuborish',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
