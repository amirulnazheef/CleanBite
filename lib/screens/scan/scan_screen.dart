import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/image_picker_service.dart';
import '../../core/services/backend_service.dart';

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
              icon: Icons.document_scanner,
              title: 'Scan Ingredients',
              description: 'Capture label with your camera',
              gradient: AppTheme.buttonGradient,
              onTap: () {
                _showCaptureOptions(context);
              },
            ),
            const SizedBox(height: 16),
            // Option 2: Upload Image
            _buildScanOption(
              context,
              icon: Icons.photo_library_rounded,
              title: 'Upload Ingredients',
              description: 'Select existing photo',
              gradient: LinearGradient(
                colors: [
                  AppTheme.success.withValues(alpha: 0.8),
                  AppTheme.success,
                ],
              ),
              onTap: () {
                _pickImage(context);
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
                  _buildStep('1', 'Scan or upload the ingredients list'),
                  _buildStep('2', 'Let CleanBite read every ingredient'),
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

  Future<void> _pickImage(BuildContext context) async {
    await _handleImageSelection(
      context,
      picker: () => ImagePickerService().pickFromGallery(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      ),
      selectingLabel: 'Selecting image...',
      source: 'gallery',
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    await _handleImageSelection(
      context,
      picker: () => ImagePickerService().pickFromCamera(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      ),
      selectingLabel: 'Opening camera...',
      source: 'camera',
    );
  }

  void _showCaptureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
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
              'Scan ingredients',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to scan',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildOptionTile(
              context,
              icon: Icons.camera_alt_outlined,
              title: 'Use Camera',
              subtitle: 'Capture label photo',
              onTap: () {
                Navigator.pop(sheetContext);
                _captureImage(context);
              },
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              context,
              icon: Icons.photo_library_outlined,
              title: 'Upload from Gallery',
              subtitle: 'Select existing photo',
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImageSelection(
    BuildContext context, {
    required Future<ImagePickerResult?> Function() picker,
    required String selectingLabel,
    required String source,
  }) async {
    debugPrint('🔍 _handleImageSelection called - source: $source');
    
    // Show loading indicator
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Text(selectingLabel),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    final result = await picker();
    debugPrint('📸 ImagePickerService returned: ${result != null}');

    if (result == null || result.path == null) {
      debugPrint('❌ No image selected');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No image selected'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
      return;
    }

    final path = result.path!;
    debugPrint('✅ Image selected: $path');

    // Show processing indicator
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Processing image...'),
            ],
          ),
          duration: Duration(minutes: 1),
        ),
      );
    }

    try {
      // Prepare file for backend based on platform
      dynamic fileForBackend;
      String? fileName = result.name;

      if (kIsWeb) {
        fileForBackend = result.bytes;
        debugPrint('🌐 Web platform - bytes: ${result.bytes?.length}');
      } else {
        fileForBackend = File(path);
        debugPrint('📱 Mobile platform - file: $path');
      }

      debugPrint('🚀 Creating BackendService instance');
      final backend = BackendService();
      
      debugPrint('🚀 Calling backend.processImage()');
      final response = await backend.processImage(
        fileForBackend,
        fileName: fileName,
      );
      debugPrint('📥 Backend response received: ${response != null}');
      if (response != null) {
        debugPrint('📥 Response keys: ${response.keys}');
        debugPrint('📥 Response status: ${response['status']}');
      }

      // Hide loading snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }

      if (response != null && context.mounted) {
        debugPrint('✅ Navigating to processing screen');
        // Success - navigate to processing/results screen
        Navigator.of(context).pushNamed(
          AppRoutes.processing,
          arguments: {
            'type': 'ingredients',
            'source': source,
            'imagePath': path,
            'imageBytes': result.bytes,
            'imageName': result.name,
            'backendResponse': response,
          },
        );
      } else if (context.mounted) {
        debugPrint('❌ Backend returned null');
        // Backend returned null - show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to process image. Please try again.'),
            backgroundColor: AppTheme.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _handleImageSelection(
                  context,
                  picker: picker,
                  selectingLabel: selectingLabel,
                  source: source,
                );
              },
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Exception in _handleImageSelection: $e');
      debugPrint('Stack trace: $stackTrace');
      // Exception occurred
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _handleImageSelection(
                  context,
                  picker: picker,
                  selectingLabel: selectingLabel,
                  source: source,
                );
              },
            ),
          ),
        );
      }
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
