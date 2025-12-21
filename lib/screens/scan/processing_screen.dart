import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_auth_service.dart';

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
      title: 'Reading ingredient text...',
      icon: Icons.document_scanner,
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

    _processBackendResponse();
  }

  Future<void> _processBackendResponse() async {
    // Simulate processing steps with animation
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _currentStep = i;
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    // Get the backend response from scanData
    final backendResponse = widget.scanData?['backendResponse'] as Map<String, dynamic>?;
    
    if (backendResponse == null) {
      _showError('No response from backend. Please try again.');
      return;
    }

    // Check if backend returned success
    if (backendResponse['status'] != 'success') {
      _showError('Failed to process image. Please try again.');
      return;
    }

    try {
      // Extract data from backend response (new format)
      final productName = backendResponse['productName']?.toString() ?? 'Scanned Product';
      final classification = backendResponse['classification'] as Map<String, dynamic>?;
      final formattedIngredients = _normalizeIngredients(backendResponse['ingredients']);
      final dietarySummary = backendResponse['dietary_summary']?.toString();
      final allergens = _normalizeStringList(backendResponse['allergens']);

      // Determine overall classification using backend flags and ingredient statuses
      final overallClassification = _deriveClassification(classification, formattedIngredients);

      // Navigate to results
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.result,
        arguments: {
          'productName': productName,
          'classification': overallClassification,
          'classificationMap': classification,
          'ingredients': formattedIngredients,
          'dietarySummary': dietarySummary,
          'allergens': allergens,
          'facts': backendResponse['facts'],
          'usedAI': backendResponse['used_ai'],
        },
      );
    } catch (e) {
      _showError('Error processing data: ${e.toString()}');
    }
  }

  List<Map<String, String>> _normalizeIngredients(dynamic raw) {
    if (raw is! List) return [];

    return raw.map<Map<String, String>>((ing) {
      if (ing is Map<String, dynamic>) {
        return {
          'name': ing['name']?.toString() ?? '',
          'status': ing['status']?.toString() ?? 'safe',
          'restrictedFor': ing['restrictedFor']?.toString() ?? '',
        };
      }

      return {
        'name': ing.toString(),
        'status': 'safe',
        'restrictedFor': '',
      };
    }).toList();
  }

  List<String> _normalizeStringList(dynamic value) {
    if (value is! List) return [];
    return value.map((e) => e.toString()).toList();
  }

  String _deriveClassification(
    Map<String, dynamic>? classificationFlags,
    List<Map<String, String>> ingredients,
  ) {
    bool hasRestricted = false;
    bool hasDoubtful = false;

    for (final ing in ingredients) {
      final status = ing['status']?.toLowerCase() ?? '';
      if (status == 'restricted') {
        hasRestricted = true;
        break;
      } else if (status == 'doubtful') {
        hasDoubtful = true;
      }
    }

    if (hasRestricted) return 'avoid';
    if (hasDoubtful) return 'doubtful';

    if (classificationFlags != null) {
      final vegan = classificationFlags['vegan'] == true;
      final vegetarian = classificationFlags['vegetarian'] == true;
      final halal = classificationFlags['halal'] == true;
      final kosher = classificationFlags['kosher'] == true;

      if (vegan) return 'vegan';
      if (vegetarian) return 'vegetarian';
      if (halal) return 'halal';
      if (kosher) return 'kosher';
      return 'avoid'; // backend explicitly marked incompatible
    }

    return 'safe to consume';
  }

  void _showError(String message) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
        child: SafeArea(
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
