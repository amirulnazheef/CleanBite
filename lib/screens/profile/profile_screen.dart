import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthService>(
      builder: (context, authService, child) {
        final user = authService.userData;
        final firebaseUser = authService.currentUser;
        
        // Debug: Print photo URLs
        debugPrint('Profile Photo Debug:');
        debugPrint('  Firebase Auth photoURL: ${firebaseUser?.photoURL}');
        debugPrint('  Firestore photoUrl: ${user?.photoUrl}');
        debugPrint('  Final photoUrl: ${firebaseUser?.photoURL ?? user?.photoUrl}');
        
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      // Avatar - show Google photo if available
                      _buildProfileAvatar(user, firebaseUser),
                      const SizedBox(height: 16),
                      // Name - from Firebase
                      Text(
                        user?.displayName ?? firebaseUser?.displayName ?? 'User',
                        style: AppTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      // Email - from Firebase
                      Text(
                        user?.email ?? firebaseUser?.email ?? 'email@example.com',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Settings Sections
                Text(
                  'Account',
                  style: AppTheme.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile).then((_) => setState(() {})),
                  ),
                  _SettingsItem(
                    icon: Icons.history,
                    title: 'Scan History',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.history),
                  ),
                ]),
                const SizedBox(height: 24),
                Text(
                  'Preferences',
                  style: AppTheme.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(
                    icon: Icons.restaurant_menu,
                    title: 'Dietary Preferences',
                    subtitle: _buildDietarySubtitle(user),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.preferences).then((_) => setState(() {})),
                  ),
                  _SettingsItem(
                    icon: Icons.warning_amber_outlined,
                    title: 'Allergen Alerts',
                    subtitle: _buildAllergenSubtitle(user),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.allergens).then((_) => setState(() {})),
                  ),
                ]),
                const SizedBox(height: 24),
                Text(
                  'App',
                  style: AppTheme.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 24),
                Text(
                  'Support',
                  style: AppTheme.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingsCard([
                  _SettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help & FAQ',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.info_outline,
                    title: 'About CleanBite',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 24),
                // Logout Button
                LiquidGlassContainer(
                  borderRadius: 16,
                  backgroundColor: Colors.white.withValues(alpha: 0.7),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
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
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  authService.signOut();
                                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(color: AppTheme.error),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: AppTheme.error,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Logout',
                              style: AppTheme.titleMedium.copyWith(
                                color: AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar(UserData? userData, dynamic firebaseUser) {
    // Get photo URL - prioritize Firebase Auth (always up-to-date) then Firestore
    final photoUrl = firebaseUser?.photoURL ?? userData?.photoUrl;
    
    debugPrint('_buildProfileAvatar - photoUrl: $photoUrl');
    
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryOrange,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl.isNotEmpty && photoUrl != 'null'
            ? Image.network(
                photoUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                headers: const {
                  'Accept': 'image/*',
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Image load error: $error');
                  debugPrint('Stack trace: $stackTrace');
                  return const Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.primaryOrange,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryOrange,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              )
            : const Icon(
                Icons.person,
                size: 50,
                color: AppTheme.primaryOrange,
              ),
      ),
    );
  }

  String _buildDietarySubtitle(UserData? user) {
    if (user == null) return 'Not configured';
    
    final prefs = user.dietaryPreferences;
    final List<String> active = [];
    
    if (prefs.halal) active.add('Halal');
    if (prefs.kosher) active.add('Kosher');
    if (prefs.vegan) active.add('Vegan');
    if (prefs.vegetarian) active.add('Vegetarian');
    
    if (active.isEmpty) return 'Not configured';
    return active.join(', ');
  }

  String _buildAllergenSubtitle(UserData? user) {
    if (user == null) return 'Not configured';
    
    final count = user.allergens.length + user.customAllergens.length;
    if (count == 0) return 'No allergens set';
    return '$count allergen${count > 1 ? 's' : ''} configured';
  }

  Widget _buildSettingsCard(List<_SettingsItem> items) {
    return LiquidGlassContainer(
      borderRadius: 16,
      backgroundColor: Colors.white.withValues(alpha: 0.7),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.vertical(
                    top: index == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: index == items.length - 1 ? const Radius.circular(16) : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            color: AppTheme.primaryOrange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTheme.titleMedium,
                              ),
                              if (item.subtitle != null)
                                Text(
                                  item.subtitle!,
                                  style: AppTheme.labelSmall,
                                ),
                            ],
                          ),
                        ),
                        if (item.trailing != null)
                          item.trailing!
                        else if (item.onTap != null)
                          const Icon(
                            Icons.chevron_right,
                            color: AppTheme.textMuted,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 72,
                  color: AppTheme.inputBorder.withValues(alpha: 0.5),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
}
