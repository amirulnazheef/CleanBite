import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/classification_badge.dart';
import '../../core/routes/app_routes.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic>? resultData;

  const ResultScreen({super.key, this.resultData});

  @override
  Widget build(BuildContext context) {
    final productName = resultData?['productName'] ?? 'Unknown Product';
    final classification = resultData?['classification'] ?? 'halal';
    final ingredients = resultData?['ingredients'] as List<dynamic>? ?? [];

    return Scaffold(
      body: GradientBackground(
        useSafeArea: false,
        child: Column(
          children: [
            // Top Section with Classification
            Container(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 16,
                24,
                32,
              ),
              decoration: BoxDecoration(
                color: _getClassificationColor(classification).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Back Button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
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
                      const Spacer(),
                      // Share Button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Classification Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getClassificationColor(classification).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getClassificationIcon(classification),
                      size: 50,
                      color: _getClassificationColor(classification),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product Name
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Classification Badge
                  ClassificationBadge(
                    type: _getClassificationType(classification),
                    isLarge: true,
                  ),
                ],
              ),
            ),
            // Ingredients List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${ingredients.length} ingredients detected',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...ingredients.map((ingredient) {
                      final name = ingredient['name'] ?? '';
                      final status = ingredient['status'] ?? 'safe';
                      return _buildIngredientCard(context, name, status);
                    }),
                    const SizedBox(height: 24),
                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.info.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.info,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This classification is AI-generated and should be verified with official certifications when available.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.info,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Report Button
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          // TODO: Implement report functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Report functionality coming soon'),
                              backgroundColor: AppTheme.primaryOrange,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.flag_outlined,
                          color: AppTheme.textMuted,
                          size: 18,
                        ),
                        label: Text(
                          'Report incorrect result',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                        ),
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

  Widget _buildIngredientCard(BuildContext context, String name, String status) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.ingredientDetails,
          arguments: {
            'name': name,
            'status': status,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Status Indicator
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Ingredient Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    _getStatusLabel(status),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(status),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Color _getClassificationColor(String classification) {
    switch (classification.toLowerCase()) {
      case 'halal':
        return AppTheme.halalGreen;
      case 'haram':
        return AppTheme.haramRed;
      case 'shubhah':
      case 'doubtful':
        return AppTheme.shubhahOrange;
      case 'vegan':
        return AppTheme.veganGreen;
      case 'vegetarian':
        return AppTheme.vegetarianGreen;
      case 'kosher':
        return AppTheme.kosherBlue;
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getClassificationIcon(String classification) {
    switch (classification.toLowerCase()) {
      case 'halal':
        return Icons.check_circle;
      case 'haram':
        return Icons.cancel;
      case 'shubhah':
      case 'doubtful':
        return Icons.help_outline;
      case 'vegan':
        return Icons.eco;
      case 'vegetarian':
        return Icons.grass;
      case 'kosher':
        return Icons.star;
      default:
        return Icons.restaurant;
    }
  }

  ClassificationType _getClassificationType(String classification) {
    switch (classification.toLowerCase()) {
      case 'halal':
        return ClassificationType.halal;
      case 'haram':
        return ClassificationType.haram;
      case 'shubhah':
      case 'doubtful':
        return ClassificationType.shubhah;
      case 'vegan':
        return ClassificationType.vegan;
      case 'vegetarian':
        return ClassificationType.vegetarian;
      case 'kosher':
        return ClassificationType.kosher;
      default:
        return ClassificationType.halal;
    }
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
        return 'Safe ingredient';
      case 'doubtful':
        return 'Requires verification';
      case 'restricted':
        return 'Not recommended';
      default:
        return 'Unknown status';
    }
  }
}

