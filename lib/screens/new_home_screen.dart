import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass_button.dart';

/// Home Screen - Flat Design
/// Main dashboard with recent scans and quick actions
class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CleanBite',
                          style: AppTheme.heading1.copyWith(
                            color: AppTheme.primaryButton,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        const Text(
                          'Eat smart. Scan fast.',
                          style: AppTheme.bodyMedium,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notifications - Coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products or ingredients...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing16,
                        vertical: AppTheme.spacing16,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Search - Coming soon'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.qr_code_scanner,
                        title: 'Scan Product',
                        color: AppTheme.primaryButton,
                        onTap: () {
                          // Navigate to scan tab
                          DefaultTabController.of(context).animateTo(1);
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.history,
                        title: 'Scan History',
                        color: AppTheme.secondaryButton,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Scan History - Coming soon'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Dietary Filters
                const Text(
                  'Dietary Preferences',
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing8,
                  children: [
                    _DietaryChip(label: 'Halal', icon: '🕌'),
                    _DietaryChip(label: 'Vegan', icon: '🌱'),
                    _DietaryChip(label: 'Vegetarian', icon: '🥬'),
                    _DietaryChip(label: 'Kosher', icon: '✡️'),
                    _DietaryChip(label: 'Gluten-Free', icon: '🌾'),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Recent Scans
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Scans',
                      style: AppTheme.heading3,
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('View All - Coming soon'),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                
                // Empty State
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing32),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      const Text(
                        'No scans yet',
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      const Text(
                        'Start scanning products to see them here',
                        style: AppTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing24),
                      LiquidGlassButton(
                        text: 'Scan Now',
                        onPressed: () {
                          DefaultTabController.of(context).animateTo(1);
                        },
                        icon: Icons.qr_code_scanner,
                        width: 200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Dietary Chip Widget
class _DietaryChip extends StatelessWidget {
  final String label;
  final String icon;

  const _DietaryChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: AppTheme.primaryButton.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: AppTheme.spacing8),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
