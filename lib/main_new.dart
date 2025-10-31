import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/new_splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/new_login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations (Portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const CleanBiteApp());
}

class CleanBiteApp extends StatelessWidget {
  const CleanBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanBite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const NewSplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const NewLoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainMenuScreen(),
      },
      builder: (context, child) {
        // Ensure proper scaling
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
