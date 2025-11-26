import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/image_picker_service.dart';

/// Simplified Scan Screen with two main options
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Scan Product',
              style: AppTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how you want to scan',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // Main Options
            // Option 1: Scan with Camera
            _buildScanOption(
              context,
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan with Camera',
              description: 'Scan barcode or ingredients',
              gradient: AppTheme.buttonGradient,
              onTap: () {
                _showCameraOptions(context);
              },
            ),
            const SizedBox(height: 16),
            // Option 2: Upload Image
            _buildScanOption(
              context,
              icon: Icons.photo_library_rounded,
              title: 'Upload Image',
              description: 'Select from gallery',
              gradient: LinearGradient(
                colors: [
                  AppTheme.success.withValues(alpha: 0.8),
                  AppTheme.success,
                ],
              ),
              onTap: () {
                _showUploadOptions(context);
              },
            ),
            const SizedBox(height: 20),
            // How it works section
            LiquidGlassContainer(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.white.withValues(alpha: 0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppTheme.primaryOrange,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'How it works',
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildStep('1', 'Scan or upload a barcode'),
                  _buildStep('2', 'If not found, scan ingredient list'),
                  _buildStep('3', 'Get instant dietary classification'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTheme.labelSmall.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTheme.bodyMedium.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showCameraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Scan with Camera',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'What do you want to scan?',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildOptionTile(
              context,
              icon: Icons.qr_code,
              title: 'Scan Barcode',
              subtitle: 'Scan product barcode',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(AppRoutes.scanBarcode);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              context,
              icon: Icons.document_scanner,
              title: 'Scan Ingredients',
              subtitle: 'Take photo of ingredient list',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(AppRoutes.scanIngredients);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Image',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'What type of image are you uploading?',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildOptionTile(
              context,
              icon: Icons.qr_code,
              title: 'Barcode Image',
              subtitle: 'Upload barcode photo from gallery',
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, isBarcode: true);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              context,
              icon: Icons.list_alt,
              title: 'Ingredients List Image',
              subtitle: 'Upload ingredients photo from gallery',
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, isBarcode: false);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, {required bool isBarcode}) async {
    final result = await ImagePickerService().pickFromGallery(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (result != null && context.mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected: ${result.name ?? "image"}'),
          backgroundColor: AppTheme.success,
          duration: const Duration(seconds: 1),
        ),
      );
      
      // Navigate to processing screen with image data
      Navigator.of(context).pushNamed(
        AppRoutes.processing,
        arguments: {
          'type': isBarcode ? 'barcode' : 'ingredients',
          'source': 'gallery',
          'imagePath': result.path,
          'imageBytes': result.bytes,
          'imageName': result.name,
        },
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No image selected'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryOrange,
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
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
