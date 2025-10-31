import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

/// Splash Screen - Flat Design with Fade Animation
/// Shows app logo and name, then transitions to onboarding
class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to onboarding after delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo (using emoji for now, replace with actual logo)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryButton.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🥗',
                            style: TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing32),
                      
                      // App Name
                      const Text(
                        'CleanBite',
                        style: AppTheme.heading1,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      
                      // Tagline
                      const Text(
                        'Eat smart. Scan fast.',
                        style: AppTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
