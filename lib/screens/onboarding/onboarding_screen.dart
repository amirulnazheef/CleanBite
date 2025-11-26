import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      imagePath: 'assets/images/onboard1.png',
      title: 'Scan any product',
      subtitle: 'Simply scan the barcode or take\nphoto of the ingredients list',
    ),
    OnboardingData(
      imagePath: 'assets/images/onboard2.png',
      title: 'Get instant dietary classification',
      subtitle: 'Know immediately if a product is Halal,\nKosher, Vegan, Vegetarian, or allergies',
    ),
    OnboardingData(
      imagePath: 'assets/images/onboard3.png',
      title: 'Personalized your preferences',
      subtitle: 'Set your dietary restrictions and allergen alerts',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  void _skipToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        useSafeArea: false,
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 20),
                  child: TextButton(
                    onPressed: _skipToLogin,
                    child: Text(
                      'Skip',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              // Page Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              // Page Indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildIndicator(index == _currentPage),
                  ),
                ),
              ),
              // Next Button
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: CustomButton(
                  text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image from assets
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset(
              data.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon if image not found
                return _buildFallbackIcon(data.imagePath);
              },
            ),
          ),
          const SizedBox(height: 60),
          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIcon(String imagePath) {
    IconData icon;
    if (imagePath.contains('onboard1')) {
      icon = Icons.phone_android;
    } else if (imagePath.contains('onboard2')) {
      icon = Icons.description_outlined;
    } else {
      icon = Icons.settings;
    }

    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 80,
        color: AppTheme.textMuted.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryOrange : AppTheme.inputBorder,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String imagePath;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}
