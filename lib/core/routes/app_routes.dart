import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/scan/scan_screen.dart';
import '../../screens/scan/barcode_scanner_screen.dart';
import '../../screens/scan/ingredient_scanner_screen.dart';
import '../../screens/scan/processing_screen.dart';
import '../../screens/scan/result_screen.dart';
import '../../screens/scan/ingredient_detail_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/preferences_screen.dart';
import '../../screens/profile/allergen_setup_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/error/error_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String scanMenu = '/scan-menu';
  static const String scanBarcode = '/scan-barcode';
  static const String scanIngredients = '/scan-ingredients';
  static const String processing = '/processing';
  static const String result = '/result';
  static const String ingredientDetails = '/ingredient-details';
  static const String profile = '/profile';
  static const String preferences = '/profile/preferences';
  static const String allergens = '/profile/allergens';
  static const String editProfile = '/profile/edit';
  static const String history = '/history';
  static const String error = '/error';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);
      case onboarding:
        return _fadeRoute(const OnboardingScreen(), settings);
      case login:
        return _slideRoute(const LoginScreen(), settings);
      case signup:
        return _slideRoute(const SignupScreen(), settings);
      case forgotPassword:
        return _slideRoute(const ForgotPasswordScreen(), settings);
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      case scanMenu:
        return _slideUpRoute(const ScanScreen(), settings);
      case scanBarcode:
        return _slideRoute(const BarcodeScannerScreen(), settings);
      case scanIngredients:
        return _slideRoute(const IngredientScannerScreen(), settings);
      case processing:
        final args = settings.arguments as Map<String, dynamic>?;
        return _fadeRoute(ProcessingScreen(scanData: args), settings);
      case result:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slideRoute(ResultScreen(resultData: args), settings);
      case ingredientDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slideRoute(IngredientDetailScreen(ingredientData: args), settings);
      case profile:
        return _slideRoute(const ProfileScreen(), settings);
      case preferences:
        return _slideRoute(const PreferencesScreen(), settings);
      case allergens:
        return _slideRoute(const AllergenSetupScreen(), settings);
      case editProfile:
        return _slideRoute(const EditProfileScreen(), settings);
      case history:
        return _slideRoute(const HistoryScreen(), settings);
      case error:
        final args = settings.arguments as Map<String, dynamic>?;
        return _fadeRoute(ErrorScreen(errorData: args), settings);
      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideUpRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
