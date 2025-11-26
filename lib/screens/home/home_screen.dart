import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_auth_service.dart';
import '../scan/scan_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const DashboardPage(),
    const ScanScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient covering entire screen
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
          ),
          // Page content - no animation
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          // Liquid Glass Tab Bar at bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: _buildLiquidGlassTabBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiquidGlassTabBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          // Outer glow
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: 0,
          ),
          // Soft shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.8),
                  Colors.white.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                ),
                _buildTabItem(
                  index: 1,
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan',
                  isCenter: true,
                ),
                _buildTabItem(
                  index: 2,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
    bool isCenter = false,
  }) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 20 : 16,
          vertical: 8,
        ),
        decoration: isCenter
            ? BoxDecoration(
                gradient: isSelected ? AppTheme.buttonGradient : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              )
            : BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isCenter && isSelected
                  ? Colors.white
                  : isSelected
                      ? AppTheme.primaryOrange
                      : AppTheme.textMuted.withValues(alpha: 0.7),
              size: isCenter ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.labelSmall.copyWith(
                color: isCenter && isSelected
                    ? Colors.white
                    : isSelected
                        ? AppTheme.primaryOrange
                        : AppTheme.textMuted.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: isSelected ? 12 : 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();
    final userData = authService.userData;
    final firebaseUser = authService.currentUser;
    
    // Get display name from Firestore userData, or Firebase Auth user, or default
    final userName = userData?.displayName ?? 
                     firebaseUser?.displayName ?? 
                     'User';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Hello, ',
                    style: AppTheme.displayMedium,
                  ),
                  TextSpan(
                    text: '$userName!',
                    style: AppTheme.displayMedium.copyWith(
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Getting Started Section
            Text(
              'Getting started',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            // Setup Profile Card
            _buildSetupCard(
              context,
              icon: Icons.check_circle,
              iconColor: AppTheme.primaryOrange,
              title: 'Setup your profile',
              subtitle: 'Choose your allergens',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.allergens);
              },
            ),
            const SizedBox(height: 32),
            // Recent Scans Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent scans',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.history);
                  },
                  child: Text(
                    'See all',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Empty State or Recent Scans
            _buildRecentScans(context),
            const SizedBox(height: 32),
            // Quick Actions
            Text(
              'Quick actions',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.qr_code_scanner,
                    label: 'Scan Barcode',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.scanBarcode);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.camera_alt_outlined,
                    label: 'Scan Ingredients',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.scanIngredients);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white.withValues(alpha: 0.7),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScans(BuildContext context) {
    // For now, show empty state - scan history will be loaded from Firestore
    // TODO: Implement StreamBuilder for FirebaseAuthService().getScanHistory()
    return _buildEmptyState();
  }

  Widget _buildEmptyState() {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(32),
      backgroundColor: Colors.white.withValues(alpha: 0.5),
      borderOpacity: 0.2,
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: AppTheme.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No scans yet',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by scanning a product barcode\nor ingredients list',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white.withValues(alpha: 0.7),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppTheme.buttonGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
