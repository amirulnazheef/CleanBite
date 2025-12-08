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
      // Extract data from backend response
      final ingredients = backendResponse['ingredients'] as List<dynamic>? ?? [];
      final classification = backendResponse['product_classification'] as Map<String, dynamic>?;
      
      // Get user's dietary preferences
      final userPrefs = FirebaseAuthService().userData?.dietaryPreferences;
      final userDiets = <String>[];
      if (userPrefs?.halal == true) userDiets.add('halal');
      if (userPrefs?.kosher == true) userDiets.add('kosher');
      if (userPrefs?.vegan == true) userDiets.add('vegan');
      if (userPrefs?.vegetarian == true) userDiets.add('vegetarian');
      
      // Determine overall classification
      String overallClassification = 'unknown';
      if (classification != null) {
        // Check which dietary types are TRUE (product meets that requirement)
        List<String> compatibleTypes = [];
        if (classification['halal'] == true) compatibleTypes.add('halal');
        if (classification['kosher'] == true) compatibleTypes.add('kosher');
        if (classification['vegan'] == true) compatibleTypes.add('vegan');
        if (classification['vegetarian'] == true) compatibleTypes.add('vegetarian');
        
        // Prioritize: vegan > vegetarian > halal > kosher
        if (compatibleTypes.contains('vegan')) {
          overallClassification = 'vegan';
        } else if (compatibleTypes.contains('vegetarian')) {
          overallClassification = 'vegetarian';
        } else if (compatibleTypes.contains('halal')) {
          overallClassification = 'halal';
        } else if (compatibleTypes.contains('kosher')) {
          overallClassification = 'kosher';
        } else {
          // None are true - product is not compatible with any diet
          overallClassification = 'haram';
        }
      }

      // Format ingredients with proper status based on user's dietary choices
      final formattedIngredients = ingredients.map((ing) {
        String name;
        Map<String, dynamic> dietaryInfo = {};
        
        // Extract name and dietary info from ingredient object
        if (ing is Map<String, dynamic>) {
          name = ing['name']?.toString() ?? '';
          dietaryInfo = {
            'halal': ing['halal'] ?? false,
            'kosher': ing['kosher'] ?? false,
            'vegan': ing['vegan'] ?? false,
            'vegetarian': ing['vegetarian'] ?? false,
          };
        } else {
          name = ing.toString();
        }
        
        // Determine status based on user's dietary preferences
        String status = 'safe';
        List<String> restrictedFor = [];
        
        if (userDiets.isNotEmpty) {
          for (String diet in userDiets) {
            if (dietaryInfo[diet] == false) {
              status = 'restricted';
              restrictedFor.add(diet);
            }
          }
        }
        
        return {
          'name': name,
          'status': status,
          'restrictedFor': restrictedFor.join(', '),
          'dietaryInfo': dietaryInfo,
        };
      }).toList();

      // Navigate to results
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.result,
        arguments: {
          'productName': 'Scanned Product',
          'classification': overallClassification,
          'ingredients': formattedIngredients,
        },
      );
    } catch (e) {
      _showError('Error processing data: ${e.toString()}');
    }
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