import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/services/firebase_auth_service.dart';

class AllergenSetupScreen extends StatefulWidget {
  const AllergenSetupScreen({super.key});

  @override
  State<AllergenSetupScreen> createState() => _AllergenSetupScreenState();
}

class _AllergenSetupScreenState extends State<AllergenSetupScreen> {
  late Set<String> _selectedAllergens;
  late List<String> _customAllergens;
  final TextEditingController _customAllergenController = TextEditingController();
  bool _isLoading = false;

  final List<AllergenItem> _commonAllergens = [
    AllergenItem(id: 'peanuts', name: 'Peanuts', icon: '🥜'),
    AllergenItem(id: 'tree_nuts', name: 'Tree Nuts', icon: '🌰'),
    AllergenItem(id: 'milk', name: 'Milk/Dairy', icon: '🥛'),
    AllergenItem(id: 'eggs', name: 'Eggs', icon: '🥚'),
    AllergenItem(id: 'wheat', name: 'Wheat/Gluten', icon: '🌾'),
    AllergenItem(id: 'soy', name: 'Soy', icon: '🫘'),
    AllergenItem(id: 'fish', name: 'Fish', icon: '🐟'),
    AllergenItem(id: 'shellfish', name: 'Shellfish', icon: '🦐'),
    AllergenItem(id: 'sesame', name: 'Sesame', icon: '🌱'),
    AllergenItem(id: 'mustard', name: 'Mustard', icon: '🟡'),
    AllergenItem(id: 'celery', name: 'Celery', icon: '🥬'),
    AllergenItem(id: 'sulfites', name: 'Sulfites', icon: '⚗️'),
  ];

  @override
  void initState() {
    super.initState();
    _loadAllergens();
  }

  void _loadAllergens() {
    final user = FirebaseAuthService().userData;
    _selectedAllergens = Set<String>.from(user?.allergens ?? []);
    _customAllergens = List<String>.from(user?.customAllergens ?? []);
  }

  @override
  void dispose() {
    _customAllergenController.dispose();
    super.dispose();
  }

  void _addCustomAllergen() {
    final text = _customAllergenController.text.trim();
    if (text.isNotEmpty && !_customAllergens.contains(text)) {
      setState(() {
        _customAllergens.add(text);
        _customAllergenController.clear();
      });
    }
  }

  Future<void> _saveAllergens() async {
    setState(() => _isLoading = true);
    
    final success = await FirebaseAuthService().updateAllergens(
      allergens: _selectedAllergens.toList(),
      customAllergens: _customAllergens,
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Allergen settings saved!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            // App Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Allergen Alerts',
                      style: AppTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your allergens',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll alert you when scanned products contain these ingredients.',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    // Allergen Grid
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _commonAllergens.map((allergen) {
                        final isSelected = _selectedAllergens.contains(allergen.id);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedAllergens.remove(allergen.id);
                              } else {
                                _selectedAllergens.add(allergen.id);
                              }
                            });
                          },
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.error.withValues(alpha: 0.1)
                                  : AppTheme.surfaceWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.error
                                    : AppTheme.inputBorder,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  allergen.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    allergen.name,
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.error,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    // Custom Allergen Input
                    Text(
                      'Add custom allergen',
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customAllergenController,
                            decoration: InputDecoration(
                              hintText: 'Enter allergen name',
                              filled: true,
                              fillColor: AppTheme.surfaceWhite,
                            ),
                            onSubmitted: (_) => _addCustomAllergen(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _addCustomAllergen,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppTheme.buttonGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Custom Allergens List
                    if (_customAllergens.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _customAllergens.map((allergen) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  allergen,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _customAllergens.remove(allergen);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: AppTheme.error,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Warning Info
                    LiquidGlassContainer(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppTheme.warning.withValues(alpha: 0.1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            color: AppTheme.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Always read product labels carefully. Our detection is AI-assisted and may not catch all allergens or cross-contamination.',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Summary
                    if (_selectedAllergens.isNotEmpty || _customAllergens.isNotEmpty)
                      LiquidGlassContainer(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white.withValues(alpha: 0.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your alerts (${_selectedAllergens.length + _customAllergens.length})',
                              style: AppTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You\'ll be warned when products contain any of your selected allergens.',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Save Button
                    CustomButton(
                      text: 'Save Allergen Settings',
                      onPressed: _saveAllergens,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllergenItem {
  final String id;
  final String name;
  final String icon;

  AllergenItem({
    required this.id,
    required this.name,
    required this.icon,
  });
}
