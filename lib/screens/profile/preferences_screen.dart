import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/services/firebase_auth_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late bool _halal;
  late bool _kosher;
  late bool _vegan;
  late bool _vegetarian;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    final user = FirebaseAuthService().userData;
    final prefs = user?.dietaryPreferences;
    
    _halal = prefs?.halal ?? false;
    _kosher = prefs?.kosher ?? false;
    _vegan = prefs?.vegan ?? false;
    _vegetarian = prefs?.vegetarian ?? false;
  }

  Future<void> _savePreferences() async {
    setState(() => _isLoading = true);
    
    final newPrefs = DietaryPreferences(
      halal: _halal,
      kosher: _kosher,
      vegan: _vegan,
      vegetarian: _vegetarian,
    );
    
    final success = await FirebaseAuthService().updateDietaryPreferences(newPrefs);
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Preferences saved!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save preferences'),
            backgroundColor: AppTheme.error,
          ),
        );
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
                      'Dietary Preferences',
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
                    // Main Preferences
                    Text(
                      'Dietary Requirements',
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPreferenceCard(
                      title: 'Halal',
                      subtitle: 'Filter for halal-compliant products',
                      icon: Icons.check_circle_outline,
                      value: _halal,
                      onChanged: (v) => setState(() => _halal = v),
                    ),
                    const SizedBox(height: 12),
                    _buildPreferenceCard(
                      title: 'Kosher',
                      subtitle: 'Filter for kosher-compliant products',
                      icon: Icons.star_outline,
                      value: _kosher,
                      onChanged: (v) => setState(() => _kosher = v),
                    ),
                    const SizedBox(height: 12),
                    _buildPreferenceCard(
                      title: 'Vegan',
                      subtitle: 'Exclude all animal products',
                      icon: Icons.eco_outlined,
                      value: _vegan,
                      onChanged: (v) => setState(() => _vegan = v),
                    ),
                    const SizedBox(height: 12),
                    _buildPreferenceCard(
                      title: 'Vegetarian',
                      subtitle: 'Exclude meat but allow dairy/eggs',
                      icon: Icons.grass,
                      value: _vegetarian,
                      onChanged: (v) => setState(() => _vegetarian = v),
                    ),
                    const SizedBox(height: 32),
                    // Save Button
                    CustomButton(
                      text: 'Save Preferences',
                      onPressed: _savePreferences,
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

  Widget _buildPreferenceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return LiquidGlassContainer(
      backgroundColor: Colors.white.withValues(alpha: 0.7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: value
                        ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                        : AppTheme.inputBorder.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: value ? AppTheme.primaryOrange : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.titleMedium,
                      ),
                      Text(
                        subtitle,
                        style: AppTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppTheme.primaryOrange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
