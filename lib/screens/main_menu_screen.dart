import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'scan_screen.dart';
import 'profile_screen.dart';

/// Main Menu Screen - Bottom Tab Bar Navigation
/// Contains Home, Scan, and Profile tabs
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ScanScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                  ),
                  _buildTabItem(
                    index: 1,
                    icon: Icons.qr_code_scanner_outlined,
                    activeIcon: Icons.qr_code_scanner,
                    label: 'Scan',
                  ),
                  _buildTabItem(
                    index: 2,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? AppTheme.spacing16 : AppTheme.spacing12,
          vertical: AppTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryButton.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primaryButton : AppTheme.textLight,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: AppTheme.spacing8),
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryButton,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
