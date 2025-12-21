import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/classification_badge.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_auth_service.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic>? resultData;

  const ResultScreen({super.key, this.resultData});

  @override
  Widget build(BuildContext context) {
    final productName = resultData?['productName']?.toString() ?? 'Unknown Product';
    final ingredients = _normalizeIngredients(resultData?['ingredients']);
    final classificationFlags =
        (resultData?['classificationMap'] as Map<String, dynamic>?) ?? {};
    final allergens = _normalizeStringList(resultData?['allergens']);
    final userData = FirebaseAuthService().userData;
    final userPrefs = userData?.dietaryPreferences;
    final containsAnimalMeat = _containsAnimalMeat(ingredients, allergens);
    final containsAnimalProducts = _containsAnimalProducts(ingredients, allergens);
    final classification = _calculateOverallClassification(
      ingredients,
      classificationFlags,
      userData,
      allergens,
      containsAnimalMeat,
      containsAnimalProducts,
    );
    final adjustedFlags =
        _adjustFlagsForClassification(classificationFlags, classification, containsAnimalMeat, containsAnimalProducts);
    final hasPositiveDietFlag = adjustedFlags.values.whereType<bool>().any((v) => v);
    final dietarySummary = _buildDietarySummary(
      baseSummary: resultData?['dietarySummary']?.toString(),
      classification: classification,
      containsAnimalMeat: containsAnimalMeat,
      hasPositiveDietFlag: hasPositiveDietFlag,
    );
    final facts = _normalizeFacts(resultData?['facts']);
    final usedAI = resultData?['usedAI'] == true;

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
                  if (usedAI) ...[
                    const SizedBox(height: 10),
                    _buildAiBadge(),
                  ],
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
                    if (dietarySummary != null && dietarySummary.isNotEmpty) ...[
                      _buildSummaryCard(dietarySummary),
                      const SizedBox(height: 16),
                    ],
                    if (adjustedFlags.isNotEmpty) ...[
                      _buildDietaryFlags(adjustedFlags, userPrefs),
                      const SizedBox(height: 16),
                    ],
                    _buildAllergenSection(allergens),
                    const SizedBox(height: 20),
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
                      final name = ingredient['name']?.toString() ?? '';
                      final status = ingredient['status']?.toString() ?? 'safe';
                      final restrictedFor = ingredient['restrictedFor']?.toString() ?? '';
                      final filteredRestricted = _filterRestrictedFor(restrictedFor, userPrefs);
                      final displayStatus = status == 'restricted' && filteredRestricted.isEmpty
                          ? 'safe'
                          : status;
                      return _buildIngredientCard(
                        context,
                        name,
                        displayStatus,
                        filteredRestricted,
                      );
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

  Widget _buildAiBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppTheme.primaryOrange,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'AI-assisted result',
            style: TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.description_outlined,
            color: AppTheme.primaryOrange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dietary summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryFlags(Map<String, dynamic> flags, DietaryPreferences? prefs) {
    if (flags.isEmpty) return const SizedBox.shrink();
    final selectedKeys = _selectedPreferenceKeys(prefs);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.inputBorder.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu,
                color: AppTheme.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text(
                'Dietary compatibility',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFlagChip(
                'Halal',
                flags['halal'] == true,
                Icons.mosque,
                AppTheme.halalGreen,
              ),
              _buildFlagChip(
                'Kosher',
                flags['kosher'] == true,
                Icons.star_outline,
                AppTheme.kosherBlue,
              ),
              _buildFlagChip(
                'Vegan',
                flags['vegan'] == true,
                Icons.eco,
                AppTheme.veganGreen,
              ),
              _buildFlagChip(
                'Vegetarian',
                flags['vegetarian'] == true,
                Icons.grass,
                AppTheme.vegetarianGreen,
              ),
              if (selectedKeys.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Based on your preferences: ${selectedKeys.join(', ')}',
                    style: AppTheme.labelSmall.copyWith(color: AppTheme.textMuted),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlagChip(
    String label,
    bool isCompatible,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCompatible
            ? color.withOpacity(0.12)
            : AppTheme.inputBorder.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompatible
              ? color.withOpacity(0.4)
              : AppTheme.inputBorder.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompatible ? icon : Icons.remove,
            size: 16,
            color: isCompatible ? color : AppTheme.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isCompatible ? color : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergenSection(List<String> allergens) {
    final hasAllergens = allergens.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.inputBorder.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: hasAllergens ? AppTheme.error : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                'Allergens reported',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasAllergens)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allergens
                  .map(
                    (allergen) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppTheme.error,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            allergen,
                            style: TextStyle(
                              color: AppTheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              'No allergens flagged by the backend for this product.',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFactsSection(List<String> facts) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.inputBorder.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fact_check_outlined,
                color: AppTheme.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text(
                'Facts from backend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (facts.isEmpty)
            Text(
              'No additional facts provided.',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            )
          else
            ...facts.map(_buildBulletRow),
        ],
      ),
    );
  }

  Widget _buildBulletRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textDark,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCard(BuildContext context, String name, String status, String restrictedFor) {
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
          border: Border.all(
            color: status == 'restricted' 
                ? AppTheme.error.withOpacity(0.3)
                : AppTheme.inputBorder.withOpacity(0.1),
            width: status == 'restricted' ? 2 : 1,
          ),
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
                    status == 'restricted' && restrictedFor.isNotEmpty
                        ? 'Not suitable for: $restrictedFor'
                        : _getStatusLabel(status),
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

  List<Map<String, String>> _normalizeIngredients(dynamic raw) {
    if (raw is! List) return [];

    return raw.map<Map<String, String>>((item) {
      if (item is Map<String, dynamic>) {
        return {
          'name': item['name']?.toString() ?? '',
          'status': item['status']?.toString() ?? 'safe',
          'restrictedFor': item['restrictedFor']?.toString() ?? '',
        };
      }
      return {
        'name': item.toString(),
        'status': 'safe',
        'restrictedFor': '',
      };
    }).toList();
  }

  List<String> _normalizeStringList(dynamic value) {
    if (value is! List) return [];
    return value.map((e) => e.toString()).toList();
  }

  List<String> _normalizeFacts(dynamic raw) {
    if (raw is Map) {
      return raw.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .toList()
          .cast<String>();
    }
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    if (raw != null) return [raw.toString()];
    return [];
  }

  Color _getClassificationColor(String classification) {
    switch (classification.toLowerCase()) {
      case 'safe to consume':
      case 'safe':
      case 'halal': // Backward compatibility
        return AppTheme.halalGreen;
      case 'avoid':
      case 'haram': // Backward compatibility
        return AppTheme.haramRed;
      case 'doubtful':
      case 'shubhah': // Backward compatibility
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
      case 'safe to consume':
      case 'safe':
      case 'halal': // Backward compatibility
        return Icons.check_circle;
      case 'avoid':
      case 'haram': // Backward compatibility
        return Icons.cancel;
      case 'doubtful':
      case 'shubhah': // Backward compatibility
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
      case 'safe to consume':
      case 'safe':
      case 'halal': // Backward compatibility
        return ClassificationType.safeToConsume;
      case 'avoid':
      case 'haram': // Backward compatibility
        return ClassificationType.avoid;
      case 'doubtful':
      case 'shubhah': // Backward compatibility
        return ClassificationType.doubtful;
      case 'vegan':
        return ClassificationType.vegan;
      case 'vegetarian':
        return ClassificationType.vegetarian;
      case 'kosher':
        return ClassificationType.kosher;
      default:
        return ClassificationType.safeToConsume;
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

  String _buildDietarySummary({
    String? baseSummary,
    required String classification,
    required bool containsAnimalMeat,
    required bool hasPositiveDietFlag,
  }) {
    final lowered = classification.toLowerCase();
    if (lowered == 'avoid') {
      return 'This product is not compatible with your dietary preferences.';
    }
    if (containsAnimalMeat) {
      return 'Contains meat ingredients without verified halal or kosher sourcing.';
    }
    if (!hasPositiveDietFlag) {
      return 'No dietary compatibility confirmed for this product.';
    }
    if (baseSummary != null && baseSummary.isNotEmpty) return baseSummary;
    return 'Overall assessment: $classification';
  }

  Map<String, dynamic> _adjustFlagsForClassification(
    Map<String, dynamic> flags,
    String classification,
    bool containsAnimalMeat,
    bool containsAnimalProducts,
  ) {
    final adjusted = Map<String, dynamic>.from(flags);
    if (adjusted.isEmpty) return adjusted;

    if (containsAnimalMeat) {
      adjusted['halal'] = false;
      adjusted['vegan'] = false;
      adjusted['vegetarian'] = false;
    } else if (containsAnimalProducts) {
      adjusted['vegan'] = false;
      // Vegetarian diets can include dairy/eggs, so leave vegetarian flag untouched
    }
    return adjusted;
  }

  /// Calculate overall product classification based on ingredient statuses
  /// Priority: restricted > doubtful > safe
  String _calculateOverallClassification(
    List<Map<String, String>> ingredients,
    Map<String, dynamic> flags,
    UserData? user,
    List<String> detectedAllergens,
    bool containsAnimalMeat,
    bool containsAnimalProducts,
  ) {
    bool hasRestricted = false;
    bool hasDoubtful = false;
    bool hasPreferences = false;
    bool hasAllergenPrefs = false;
    bool globalRestricted = false; // applies to everyone
    bool preferenceSpecificRestricted = false;
    bool preferenceSpecificDoubtful = false;
    bool preferenceConflict = false;
    bool preferenceUnknown = false;

    final prefs = user?.dietaryPreferences;
    if (prefs != null) {
      hasPreferences = prefs.halal || prefs.kosher || prefs.vegan || prefs.vegetarian;
    }

    final userAllergens = <String>{};
    if (user != null) {
      userAllergens.addAll(user.allergens.map((a) => a.toLowerCase()));
      userAllergens.addAll(user.customAllergens.map((a) => a.toLowerCase()));
    }
    hasAllergenPrefs = userAllergens.isNotEmpty;

    // Meat present and halal/vegan/vegetarian preference enabled -> treat as conflict
    if (containsAnimalMeat) {
      if (prefs?.halal == true || prefs?.vegan == true || prefs?.vegetarian == true) {
        preferenceConflict = true;
      }
    } else if (containsAnimalProducts) {
      if (prefs?.vegan == true) {
        preferenceConflict = true;
      }
    }

    // No preferences or allergens configured: user can consume everything
    if (!hasPreferences && !hasAllergenPrefs) {
      return 'safe to consume';
    }

    for (var ingredient in ingredients) {
      final status = ingredient['status']?.toString().toLowerCase() ?? 'safe';
      final restrictedFor = ingredient['restrictedFor']?.toLowerCase() ?? '';
      final name = ingredient['name']?.toLowerCase() ?? '';

      if (status == 'restricted' && restrictedFor.isEmpty) {
        // Backend marked this universally restricted
        globalRestricted = true;
      } else if (status == 'restricted' && hasPreferences) {
        // Only matters if user has the matching preference enabled
        if (_matchesUserPreference(restrictedFor, prefs)) {
          preferenceSpecificRestricted = true;
        }
      }

      if (status == 'doubtful' && hasPreferences) {
        preferenceSpecificDoubtful = true;
      }

      // Treat ambiguous proteins like gelatin as doubtful only when preferences are set
      if (name.contains('gelatin') && hasPreferences) {
        preferenceSpecificDoubtful = true;
      }
    }

    // Allergen check against user profile
    if (hasAllergenPrefs) {
      final detected = detectedAllergens.map((a) => a.toLowerCase()).toSet();
      if (detected.any(userAllergens.contains)) {
        hasRestricted = true;
      }
    }

    // Preference alignment (halal/kosher/vegan/vegetarian)
    void evaluatePreference(bool isEnabled, dynamic flag) {
      if (!isEnabled) return;
      if (flag == true) return;
      if (flag == false) {
        preferenceConflict = true; // explicitly fails the preference
      } else {
        preferenceUnknown = true; // unknown status → doubtful
      }
    }

    if (prefs != null) {
      evaluatePreference(prefs.halal, flags['halal']);
      evaluatePreference(prefs.kosher, flags['kosher']);
      evaluatePreference(prefs.vegan, flags['vegan']);
      evaluatePreference(prefs.vegetarian, flags['vegetarian']);
    }

    // Final decision: only safe to consume / doubtful / avoid
    if (globalRestricted || hasRestricted || (hasPreferences && (preferenceConflict || preferenceSpecificRestricted))) {
      return 'avoid';
    }
    if (hasPreferences && (hasDoubtful || preferenceUnknown || preferenceSpecificDoubtful)) {
      return 'doubtful';
    }
    return 'safe to consume';
  }

  bool _matchesUserPreference(String restrictedFor, DietaryPreferences? prefs) {
    if (prefs == null) return false;
    final tag = restrictedFor.toLowerCase();
    if (tag.contains('halal') && prefs.halal) return true;
    if (tag.contains('kosher') && prefs.kosher) return true;
    if (tag.contains('vegan') && prefs.vegan) return true;
    if (tag.contains('vegetarian') && prefs.vegetarian) return true;
    return false;
  }

  List<String> _selectedPreferenceKeys(DietaryPreferences? prefs) {
    if (prefs == null) return [];
    final keys = <String>[];
    if (prefs.halal) keys.add('halal');
    if (prefs.kosher) keys.add('kosher');
    if (prefs.vegan) keys.add('vegan');
    if (prefs.vegetarian) keys.add('vegetarian');
    return keys;
  }

  String _filterRestrictedFor(String restrictedFor, DietaryPreferences? prefs) {
    if (restrictedFor.isEmpty) return '';
    final selected = _selectedPreferenceKeys(prefs);
    if (selected.isEmpty) return '';

    final parts = restrictedFor.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    final allowedLabels = <String>[];
    for (final part in parts) {
      final lower = part.toLowerCase();
      if (lower.contains('halal') && selected.contains('halal')) allowedLabels.add(part);
      if (lower.contains('kosher') && selected.contains('kosher')) allowedLabels.add(part);
      if (lower.contains('vegan') && selected.contains('vegan')) allowedLabels.add(part);
      if (lower.contains('vegetarian') && selected.contains('vegetarian')) allowedLabels.add(part);
    }

    return allowedLabels.join(', ');
  }

  bool _statusAppliesToPrefs(String status, String restrictedFor, List<String> prefs) {
    if (prefs.isEmpty) return true; // No preference filter; treat statuses as-is
    if (status != 'restricted' && status != 'doubtful') return false;
    if (restrictedFor.isEmpty) return true; // Conservative if backend didn't specify

    final parts = restrictedFor.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    for (final part in parts) {
      final key = _mapLabelToPrefKey(part);
      if (key != null && prefs.contains(key)) {
        return true;
      }
    }
    return false;
  }

  String? _mapLabelToPrefKey(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('halal')) return 'halal';
    if (lower.contains('kosher')) return 'kosher';
    if (lower.contains('vegan')) return 'vegan';
    if (lower.contains('vegetarian')) return 'vegetarian';
    return null;
  }

  bool _containsAnimalMeat(
    List<Map<String, String>> ingredients,
    List<String> allergens,
  ) {
    const meatKeywords = [
      'beef',
      'meat',
      'chicken',
      'lamb',
      'mutton',
      'pork',
      'gelatin',
      'animal fat',
      'animal',
    ];

    bool matches(String text) {
      final lower = text.toLowerCase();
      return meatKeywords.any((k) => lower.contains(k));
    }

    for (final ing in ingredients) {
      final name = ing['name']?.toString() ?? '';
      if (matches(name)) return true;
    }
    for (final allergen in allergens) {
      if (matches(allergen)) return true;
    }
    return false;
  }

  bool _containsAnimalProducts(
    List<Map<String, String>> ingredients,
    List<String> allergens,
  ) {
    const animalProductKeywords = [
      'milk',
      'dairy',
      'cheese',
      'butter',
      'cream',
      'whey',
      'casein',
      'egg',
      'egg white',
      'egg yolk',
      'lactose',
      'honey',
    ];

    bool matches(String text) {
      final lower = text.toLowerCase();
      return animalProductKeywords.any((k) => lower.contains(k));
    }

    for (final ing in ingredients) {
      final name = ing['name']?.toString() ?? '';
      if (matches(name)) return true;
    }
    for (final allergen in allergens) {
      if (matches(allergen)) return true;
    }
    return false;
  }
}
