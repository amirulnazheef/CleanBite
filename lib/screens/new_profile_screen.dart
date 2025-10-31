import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass_button.dart';

/// Profile Screen - Flat Design
/// User profile with settings and preferences
class NewProfileScreen extends StatelessWidget {
  const NewProfileScreen({super.key});

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
              children: [
                // Header
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile',
                    style: AppTheme.heading2,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Profile Card
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryButton.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '👤',
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing16),

                      // Name
                      const Text(
                        'Clean Eater',
                        style: AppTheme.heading3,
                      ),
                      const SizedBox(height: AppTheme.spacing4),

                      // Email
                      Text(
                        'user@cleanbite.com',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing24),

                      // Edit Profile Button
                      LiquidGlassButton(
                        text: 'Edit Profile',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit Profile - Coming soon'),
                            ),
                          );
                        },
                        icon: Icons.edit_outlined,
                        width: double.infinity,
                        color: AppTheme.secondaryButton,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.qr_code_scanner,
                        value: '0',
                        label: 'Scans',
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.favorite,
                        value: '0',
                        label: 'Favorites',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Menu Items
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: AppTheme.heading3,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),

                _MenuItem(
                  icon: Icons.restaurant_menu,
                  title: 'Dietary Preferences',
                  subtitle: 'Set your dietary restrictions',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dietary Preferences - Coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacing12),

                _MenuItem(
                  icon: Icons.warning_amber,
                  title: 'Allergen Alerts',
                  subtitle: 'Manage your allergen warnings',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Allergen Alerts - Coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacing12),

                _MenuItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language Settings - Coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacing12),

                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications - Coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Support Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Support',
                    style: AppTheme.heading3,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),

                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact us',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help & Support - Coming soon'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacing12),

                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'About CleanBite',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Logout Button
                LiquidGlassButton(
                  text: 'Logout',
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: Icons.logout,
                  width: double.infinity,
                  color: AppTheme.error,
                ),
                const SizedBox(height: AppTheme.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('🥗', style: TextStyle(fontSize: 30)),
            const SizedBox(width: AppTheme.spacing12),
            const Text('CleanBite'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: AppTheme.bodyMedium,
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'CleanBite helps you make informed dietary choices by scanning product barcodes and ingredient lists.',
              style: AppTheme.bodyMedium,
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              '© 2024 CleanBite. All rights reserved.',
              style: AppTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          LiquidGlassButton(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          LiquidGlassButton(
            text: 'Logout',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryButton,
            size: 32,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            value,
            style: AppTheme.heading2.copyWith(
              color: AppTheme.primaryButton,
            ),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            label,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Menu Item Widget
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryButton.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryButton,
              ),
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    subtitle,
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
