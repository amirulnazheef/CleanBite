import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass_button.dart';
import '../providers/user_provider.dart';

/// Profile Screen - Flat Design
/// User profile with settings and preferences
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;
        final preferences = userProvider.preferences;

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
                                _getInitials(user?.name ?? preferences.name),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryButton,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing16),

                          // Name
                          Text(
                            user?.name ?? preferences.name,
                            style: AppTheme.heading3,
                          ),
                          const SizedBox(height: AppTheme.spacing4),

                          // Email
                          Text(
                            user?.email ?? 'No email',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing8),

                          // Member Since
                          if (user != null)
                            Text(
                              'Member since ${_formatDate(user.createdAt)}',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textLight,
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

                    // Preferences Summary
                    if (preferences.dietaryRestrictions.isNotEmpty ||
                        preferences.allergens.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Your Preferences',
                              style: AppTheme.heading3,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing16),
                          
                          if (preferences.dietaryRestrictions.isNotEmpty)
                            _PreferenceCard(
                              icon: Icons.restaurant_menu,
                              title: 'Dietary Restrictions',
                              items: preferences.dietaryRestrictions,
                            ),
                          
                          if (preferences.allergens.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: AppTheme.spacing12),
                              child: _PreferenceCard(
                                icon: Icons.warning_amber,
                                title: 'Allergens',
                                items: preferences.allergens,
                              ),
                            ),
                          const SizedBox(height: AppTheme.spacing32),
                        ],
                      ),

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
                      subtitle: preferences.dietaryRestrictions.isEmpty
                          ? 'Set your dietary restrictions'
                          : '${preferences.dietaryRestrictions.length} restriction(s)',
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
                      subtitle: preferences.allergens.isEmpty
                          ? 'Manage your allergen warnings'
                          : '${preferences.allergens.length} allergen(s)',
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
                      subtitle: preferences.language == 'en' ? 'English' : 'Korean',
                      onTap: () {
                        _showLanguageDialog(context, userProvider);
                      },
                    ),
                    const SizedBox(height: AppTheme.spacing12),

                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: preferences.notifications ? 'Enabled' : 'Disabled',
                      onTap: () {
                        userProvider.toggleNotifications();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              preferences.notifications
                                  ? 'Notifications disabled'
                                  : 'Notifications enabled',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacing12),

                    _MenuItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: preferences.darkMode ? 'Enabled' : 'Disabled',
                      onTap: () {
                        userProvider.toggleDarkMode();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              preferences.darkMode
                                  ? 'Dark mode disabled'
                                  : 'Dark mode enabled',
                            ),
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
                        _showLogoutDialog(context, userProvider);
                      },
                      icon: Icons.logout,
                      width: double.infinity,
                      color: AppTheme.error,
                    ),
                    const SizedBox(height: AppTheme.spacing16),

                    // Delete Account Button
                    TextButton(
                      onPressed: () {
                        _showDeleteAccountDialog(context, userProvider);
                      },
                      child: Text(
                        'Delete Account',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.error,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showLanguageDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: userProvider.preferences.language,
                onChanged: (value) {
                  if (value != null) {
                    userProvider.updateLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('한국어 (Korean)'),
              leading: Radio<String>(
                value: 'ko',
                groupValue: userProvider.preferences.language,
                onChanged: (value) {
                  if (value != null) {
                    userProvider.updateLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
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

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
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
            onPressed: () async {
              await userProvider.logout();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          LiquidGlassButton(
            text: 'Delete',
            onPressed: () async {
              await userProvider.deleteAccount();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              }
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

/// Preference Card Widget
class _PreferenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _PreferenceCard({
    required this.icon,
    required this.title,
    required this.items,
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
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryButton, size: 20),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButton.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      item,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryButton,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
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
