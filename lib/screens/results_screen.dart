import 'package:flutter/material.dart';
import '../models/product.dart';
import '../config/app_theme.dart';
import '../config/device_config.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    Product? product;
    
    if (args is Product) {
      product = args;
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: const Center(
          child: Text('No product data available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Product Results'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DeviceConfig.spacing16(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                width: DeviceConfig.getResponsiveSize(context, 150),
                height: DeviceConfig.getResponsiveSize(context, 150),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surfaceDark),
                ),
                child: Icon(
                  Icons.fastfood,
                  size: DeviceConfig.getResponsiveSize(context, 80),
                  color: AppTheme.primaryBrown,
                ),
              ),
            ),
            SizedBox(height: DeviceConfig.spacing24(context)),

            // Product Name
            Text(
              product.nameEnglish,
              style: TextStyle(
                fontSize: DeviceConfig.fontSize24(context),
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              product.nameKorean,
              style: TextStyle(
                fontSize: DeviceConfig.fontSize18(context),
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: DeviceConfig.spacing8(context)),
            Text(
              product.brand,
              style: TextStyle(
                fontSize: DeviceConfig.fontSize16(context),
                color: AppTheme.textLight,
              ),
            ),
            SizedBox(height: DeviceConfig.spacing24(context)),

            // Dietary Classification Badges
            Text(
              'Dietary Classifications',
              style: TextStyle(
                fontSize: DeviceConfig.fontSize18(context),
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: DeviceConfig.spacing12(context)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBadge('Halal', product.isHalal),
                _buildBadge('Vegan', product.isVegan),
                _buildBadge('Vegetarian', product.isVegetarian),
                _buildBadge('Kosher', product.isKosher),
              ],
            ),
            SizedBox(height: DeviceConfig.spacing24(context)),

            // Explanation
            Container(
              padding: EdgeInsets.all(DeviceConfig.spacing16(context)),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryBrown.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryBrown,
                        size: DeviceConfig.getResponsiveSize(context, 20),
                      ),
                      SizedBox(width: DeviceConfig.spacing8(context)),
                      Text(
                        'Explanation',
                        style: TextStyle(
                          fontSize: DeviceConfig.fontSize16(context),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DeviceConfig.spacing8(context)),
                  Text(
                    product.explanation,
                    style: TextStyle(
                      fontSize: DeviceConfig.fontSize14(context),
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: DeviceConfig.spacing24(context)),

            // Allergens
            if (product.allergens.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(DeviceConfig.spacing16(context)),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: AppTheme.error,
                          size: DeviceConfig.getResponsiveSize(context, 20),
                        ),
                        SizedBox(width: DeviceConfig.spacing8(context)),
                        Text(
                          'Allergen Warning',
                          style: TextStyle(
                            fontSize: DeviceConfig.fontSize16(context),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: DeviceConfig.spacing8(context)),
                    Text(
                      'Contains: ${product.allergens.join(", ")}',
                      style: TextStyle(
                        fontSize: DeviceConfig.fontSize14(context),
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: DeviceConfig.spacing24(context)),
            ],

            // Ingredients List
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: DeviceConfig.fontSize18(context),
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: DeviceConfig.spacing12(context)),
            ...product.ingredientsEnglish.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;
              final prod = product!; // Create non-nullable reference
              final isProblematic = prod.problematicIngredients.contains(ingredient) ||
                  (index < prod.ingredientsKorean.length && 
                   prod.problematicIngredients.contains(prod.ingredientsKorean[index]));
              
              return Padding(
                padding: EdgeInsets.only(bottom: DeviceConfig.spacing8(context)),
                child: Row(
                  children: [
                    Icon(
                      isProblematic ? Icons.cancel : Icons.check_circle,
                      color: isProblematic ? AppTheme.error : AppTheme.accentGreen,
                      size: DeviceConfig.getResponsiveSize(context, 20),
                    ),
                    SizedBox(width: DeviceConfig.spacing8(context)),
                    Expanded(
                      child: Text(
                        index < prod.ingredientsKorean.length
                            ? '$ingredient (${prod.ingredientsKorean[index]})'
                            : ingredient,
                        style: TextStyle(
                          fontSize: DeviceConfig.fontSize14(context),
                          color: isProblematic ? AppTheme.error : AppTheme.textPrimary,
                          fontWeight: isProblematic ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: DeviceConfig.spacing24(context)),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add to favorites
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to favorites')),
                      );
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      size: DeviceConfig.getResponsiveSize(context, 20),
                    ),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: DeviceConfig.fontSize16(context),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBrown,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: DeviceConfig.spacing12(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: DeviceConfig.spacing12(context)),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Report issue
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report submitted')),
                      );
                    },
                    icon: Icon(
                      Icons.flag_outlined,
                      size: DeviceConfig.getResponsiveSize(context, 20),
                    ),
                    label: Text(
                      'Report',
                      style: TextStyle(
                        fontSize: DeviceConfig.fontSize16(context),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBrown,
                      side: BorderSide(color: AppTheme.primaryBrown),
                      padding: EdgeInsets.symmetric(
                        vertical: DeviceConfig.spacing12(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, bool isCompliant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCompliant 
            ? AppTheme.accentGreen.withOpacity(0.1) 
            : AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompliant ? AppTheme.accentGreen : AppTheme.error,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompliant ? Icons.check_circle : Icons.cancel,
            color: isCompliant ? AppTheme.accentGreen : AppTheme.error,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isCompliant ? AppTheme.accentGreen : AppTheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
