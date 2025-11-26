import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/routes/app_routes.dart';

class ProcessingScreen extends StatefulWidget {
  final Map<String, dynamic>? scanData;

  const ProcessingScreen({super.key, this.scanData});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;
  
  final List<ProcessingStep> _steps = [
    ProcessingStep(
      title: 'Reading product data...',
      icon: Icons.qr_code_scanner,
    ),
    ProcessingStep(
      title: 'Extracting ingredients...',
      icon: Icons.list_alt,
    ),
    ProcessingStep(
      title: 'Translating if needed...',
      icon: Icons.translate,
    ),
    ProcessingStep(
      title: 'Analyzing dietary info...',
      icon: Icons.analytics_outlined,
    ),
    ProcessingStep(
      title: 'Generating classification...',
      icon: Icons.check_circle_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _simulateProcessing();
  }

  Future<void> _simulateProcessing() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
      }
    }

    // Navigate to results after processing
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.result,
        arguments: {
          'productName': 'Sample Product',
          'classification': 'halal',
          'ingredients': [
            {'name': 'Water', 'status': 'safe'},
            {'name': 'Sugar', 'status': 'safe'},
            {'name': 'Natural Flavors', 'status': 'doubtful'},
            {'name': 'Citric Acid', 'status': 'safe'},
            {'name': 'Sodium Benzoate', 'status': 'safe'},
          ],
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.14159,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryOrange.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 50,
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                // Title
                Text(
                  'Analyzing Product',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please wait while we process...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 48),
                // Processing Steps
                ...List.generate(_steps.length, (index) {
                  final step = _steps[index];
                  final isCompleted = index < _currentStep;
                  final isCurrent = index == _currentStep;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        // Status Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.success
                                : isCurrent
                                    ? AppTheme.primaryOrange
                                    : AppTheme.inputBorder,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCompleted
                                ? Icons.check
                                : step.icon,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Step Title
                        Expanded(
                          child: Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: isCurrent || isCompleted
                                  ? AppTheme.textDark
                                  : AppTheme.textMuted,
                              fontWeight: isCurrent
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        // Loading Indicator
                        if (isCurrent)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryOrange,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProcessingStep {
  final String title;
  final IconData icon;

  ProcessingStep({
    required this.title,
    required this.icon,
  });
}

