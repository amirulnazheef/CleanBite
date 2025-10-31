import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../config/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final preferences = userProvider.preferences;
          
          return ListView(
            children: [
              // Language Settings
              _buildSectionHeader('Language'),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('App Language'),
                subtitle: Text(preferences.language == 'en' ? 'English' : '한국어'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLanguageDialog(context, userProvider);
                },
              ),
              const Divider(),

              // Dietary Preferences
              _buildSectionHeader('Dietary Preferences'),
              ListTile(
                leading: const Icon(Icons.restaurant_menu),
                title: const Text('Dietary Restrictions'),
                subtitle: Text(
                  preferences.dietaryRestrictions.isEmpty
                      ? 'None selected'
                      : preferences.dietaryRestrictions.join(', '),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showDietaryDialog(context, userProvider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning_amber),
                title: const Text('Allergen Alerts'),
                subtitle: Text(
                  preferences.allergens.isEmpty
                      ? 'None selected'
                      : preferences.allergens.join(', '),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showAllergensDialog(context, userProvider);
                },
              ),
              const Divider(),

              // Appearance
              _buildSectionHeader('Appearance'),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: preferences.darkMode,
                onChanged: (value) {
                  userProvider.toggleDarkMode();
                },
              ),
              const Divider(),

              // Notifications
              _buildSectionHeader('Notifications'),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive alerts and updates'),
                value: preferences.notifications,
                onChanged: (value) {
                  userProvider.toggleNotifications();
                },
              ),
              const Divider(),

              // About
              _buildSectionHeader('About'),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy - Coming soon')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terms of Service - Coming soon')),
                  );
                },
              ),
              const Divider(),

              // Support
              _buildSectionHeader('Support'),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Contact Support'),
                subtitle: const Text('support@cleanbite.com'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email client...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text('Send Feedback'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback form - Coming soon')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rate App'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening app store...')),
                  );
                },
              ),
              const Divider(),

              // Data Management
              _buildSectionHeader('Data'),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear Cache'),
                subtitle: const Text('Free up storage space'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showClearCacheDialog(context);
                },
              ),
              const Divider(),

              // Account
              _buildSectionHeader('Account'),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.error),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppTheme.error),
                ),
                onTap: () {
                  _showLogoutDialog(context, userProvider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: AppTheme.error),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(color: AppTheme.error),
                ),
                onTap: () {
                  _showDeleteAccountDialog(context, userProvider);
                },
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: userProvider.preferences.language,
              onChanged: (value) {
                userProvider.updateLanguage(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('한국어 (Korean)'),
              value: 'ko',
              groupValue: userProvider.preferences.language,
              onChanged: (value) {
                userProvider.updateLanguage(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDietaryDialog(BuildContext context, UserProvider userProvider) {
    final options = ['halal', 'vegan', 'vegetarian', 'kosher', 'gluten-free', 'dairy-free'];
    final selected = List<String>.from(userProvider.preferences.dietaryRestrictions);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Dietary Restrictions'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return CheckboxListTile(
                  title: Text(option.toUpperCase()),
                  value: selected.contains(option),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selected.add(option);
                      } else {
                        selected.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                userProvider.updateDietaryRestrictions(selected);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllergensDialog(BuildContext context, UserProvider userProvider) {
    final options = ['nuts', 'dairy', 'gluten', 'soy', 'eggs', 'shellfish', 'fish'];
    final selected = List<String>.from(userProvider.preferences.allergens);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Allergen Alerts'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return CheckboxListTile(
                  title: Text(option.toUpperCase()),
                  value: selected.contains(option),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selected.add(option);
                      } else {
                        selected.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                userProvider.updateAllergens(selected);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache? This will free up storage space.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
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
            ElevatedButton(
              onPressed: () {
                userProvider.logout();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, UserProvider userProvider) {
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
            ElevatedButton(
              onPressed: () {
                userProvider.deleteAccount();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
        ],
      ),
    );
  }
}
