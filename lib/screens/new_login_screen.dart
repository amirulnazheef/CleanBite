import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass_button.dart';

/// Login Screen - Flat Design with Liquid Glass Buttons
/// Supports Google Sign-In and Email/Password authentication
class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate login delay
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    
    // Simulate Google login delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spacing48),

                  // Logo
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
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
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Welcome Text
                  const Text(
                    'Welcome Back',
                    style: AppTheme.heading1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  const Text(
                    'Sign in to continue',
                    style: AppTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacing16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacing8),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Forgot password - Coming soon'),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: AppTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Login Button
                  LiquidGlassButton(
                    text: 'Sign In',
                    onPressed: _handleEmailLogin,
                    isLoading: _isLoading,
                    icon: Icons.login,
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                        ),
                        child: Text(
                          'OR',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing24),

                  // Google Sign In Button
                  LiquidGlassButton(
                    text: 'Continue with Google',
                    onPressed: _handleGoogleLogin,
                    color: AppTheme.cardBackground,
                    textColor: AppTheme.textPrimary,
                    icon: Icons.g_mobiledata,
                    isOutlined: true,
                  ),
                  const SizedBox(height: AppTheme.spacing32),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: AppTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: _navigateToSignup,
                        child: Text(
                          'Sign Up',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryButton,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
