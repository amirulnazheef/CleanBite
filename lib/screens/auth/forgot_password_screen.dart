import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/services/firebase_auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // Call Firebase to send reset email
      final result = await FirebaseAuthService().sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result.success) {
            _emailSent = true;
          } else {
            _errorMessage = result.errorMessage;
          }
        });
        
        if (!result.success && _errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        useSafeArea: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          _emailSent ? Icons.check_circle_outline : Icons.lock_reset,
                          size: 50,
                          color: _emailSent ? AppTheme.success : AppTheme.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Form Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCream.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: AppTheme.primaryOrange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Back to login',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _emailSent ? 'Check your email' : 'Forgot Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _emailSent
                            ? 'We\'ve sent a password reset link to ${_emailController.text}'
                            : 'Enter your email address and we\'ll send you a link to reset your password.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textMuted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (!_emailSent) ...[
                        // Email Field
                        CustomTextField(
                          hintText: 'E-mail',
                          prefixIcon: Icons.mail_outline,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                        const SizedBox(height: 32),
                        // Reset Button
                        CustomButton(
                          text: 'Send Reset Link',
                          onPressed: _handleResetPassword,
                          isLoading: _isLoading,
                        ),
                      ] else ...[
                        // Success Message
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: AppTheme.success,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Password reset email sent!',
                                      style: TextStyle(
                                        color: AppTheme.success,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '1. Check your inbox for an email from Firebase\n'
                                '2. Click the reset link in the email\n'
                                '3. Create your new password\n'
                                '4. Return to the app and login',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Don\'t see the email? Check your spam folder.',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Resend Button
                        CustomButton(
                          text: 'Resend Email',
                          isOutlined: true,
                          onPressed: () {
                            setState(() => _emailSent = false);
                          },
                        ),
                        const SizedBox(height: 16),
                        // Back to Login
                        CustomButton(
                          text: 'Back to Login',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
