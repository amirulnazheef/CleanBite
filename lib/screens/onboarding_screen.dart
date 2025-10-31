import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass_button.dart';

/// Onboarding Screen - Flat Design with Page View
/// Three slides introducing the app features
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: '📱',
      title: 'Scan any product',
      description: 'Simply scan the barcode or ingredient list of any food product to get instant information.',
      color: AppTheme.primaryButton,
    ),
    OnboardingPage(
      icon: '✅',
      title: 'Get instant dietary classification',
      description: 'Know immediately if a product is Halal, Vegan, Kosher, or contains allergens.',
      color: AppTheme.secondaryButton,
    ),
    OnboardingPage(
      icon: '⚙️',
      title: 'Personalize your preferences',
      description: 'Set your dietary restrictions and allergen alerts to get personalized recommendations.',
      color: AppTheme.info,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text(
                      'Skip',
                      style: AppTheme.bodyLarge,
                    ),
                  ),
                ),
              ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index == _currentPage),
                  ),
                ),
              ),

              // Next/Get Started Button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: LiquidGlassButton(
                  text: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: _nextPage,
                  width: double.infinity,
                  icon: _currentPage == _pages.length - 1
                      ? Icons.arrow_forward
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              boxShadow: [
                BoxShadow(
                  color: page.color.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                page.icon,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing48),

          // Title
          Text(
            page.title,
            style: AppTheme.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),

          // Description
          Text(
            page.description,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryButton : AppTheme.textLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Onboarding Page Model
class OnboardingPage {
  final String icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
