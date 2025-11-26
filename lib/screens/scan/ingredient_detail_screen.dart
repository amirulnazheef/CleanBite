import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';

class IngredientDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? ingredientData;

  const IngredientDetailScreen({super.key, this.ingredientData});

  @override
  Widget build(BuildContext context) {
    final name = ingredientData?['name'] ?? 'Unknown Ingredient';
    final status = ingredientData?['status'] ?? 'safe';

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
                        child: Icon(
                          Icons.arrow_back,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Ingredient Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
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
                    // Ingredient Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Status Icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getStatusIcon(status),
                              size: 40,
                              color: _getStatusColor(status),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Ingredient Name
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusLabel(status),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // What is it?
                    _buildInfoSection(
                      title: 'What is it?',
                      icon: Icons.help_outline,
                      content: _getIngredientDescription(name),
                    ),
                    const SizedBox(height: 16),
                    // Classification Reasoning
                    _buildInfoSection(
                      title: 'Why this classification?',
                      icon: Icons.lightbulb_outline,
                      content: _getClassificationReason(name, status),
                    ),
                    const SizedBox(height: 16),
                    // Dietary Info
                    _buildDietaryInfo(name),
                    const SizedBox(height: 16),
                    // Allergy Info
                    _buildAllergyInfo(name),
                    const SizedBox(height: 24),
                    // Sources
                    Text(
                      'Sources',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Information compiled from FDA, USDA, and certified Halal/Kosher certification bodies.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                        height: 1.5,
                      ),
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

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryInfo(String ingredientName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Dietary Compatibility',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDietaryChip('Halal', true),
              const SizedBox(width: 8),
              _buildDietaryChip('Kosher', true),
              const SizedBox(width: 8),
              _buildDietaryChip('Vegan', true),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDietaryChip('Vegetarian', true),
              const SizedBox(width: 8),
              _buildDietaryChip('Gluten-Free', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryChip(String label, bool isCompatible) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompatible
            ? AppTheme.success.withOpacity(0.1)
            : AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompatible
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompatible ? Icons.check : Icons.close,
            size: 14,
            color: isCompatible ? AppTheme.success : AppTheme.error,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isCompatible ? AppTheme.success : AppTheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyInfo(String ingredientName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: AppTheme.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Allergy Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'No common allergens detected in this ingredient. However, always check the complete product label for cross-contamination warnings.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return AppTheme.success;
      case 'doubtful':
        return AppTheme.warning;
      case 'restricted':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return Icons.check_circle;
      case 'doubtful':
        return Icons.help_outline;
      case 'restricted':
        return Icons.cancel;
      default:
        return Icons.circle;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'safe':
        return 'Safe';
      case 'doubtful':
        return 'Doubtful';
      case 'restricted':
        return 'Restricted';
      default:
        return 'Unknown';
    }
  }

  String _getIngredientDescription(String name) {
    // This would come from a database in production
    final descriptions = {
      'Water': 'Water (H2O) is a universal solvent and the most common ingredient in beverages and food products. It is essential for hydration and serves as a base for dissolving other ingredients.',
      'Sugar': 'Sugar, typically sucrose derived from sugarcane or sugar beets, is a carbohydrate sweetener. It provides energy and enhances flavor in food products.',
      'Natural Flavors': 'Natural flavors are flavoring substances derived from plant or animal sources, including fruit, vegetables, spices, herbs, bark, roots, or similar materials.',
      'Citric Acid': 'Citric acid is a weak organic acid found naturally in citrus fruits. It is commonly used as a preservative and flavoring agent to add a sour taste.',
      'Sodium Benzoate': 'Sodium benzoate is the sodium salt of benzoic acid. It is widely used as a food preservative to inhibit the growth of mold, yeast, and bacteria.',
    };
    return descriptions[name] ?? 'A common food ingredient used in various products.';
  }

  String _getClassificationReason(String name, String status) {
    if (status == 'safe') {
      return 'This ingredient is generally recognized as safe (GRAS) by food safety authorities. It does not contain any animal-derived components or substances that would conflict with Halal, Kosher, or vegetarian dietary requirements.';
    } else if (status == 'doubtful') {
      return 'The source of this ingredient may vary between manufacturers. "Natural Flavors" can be derived from either plant or animal sources. We recommend contacting the manufacturer for specific sourcing information if you have strict dietary requirements.';
    } else {
      return 'This ingredient has been flagged due to potential concerns with dietary compatibility. Please review the specific details and consult with relevant certification authorities if needed.';
    }
  }
}

