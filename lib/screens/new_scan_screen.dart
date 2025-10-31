import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass_button.dart';

/// Scan Screen - Flat Design
/// Camera view for barcode scanning with instructions
class NewScanScreen extends StatefulWidget {
  const NewScanScreen({super.key});

  @override
  State<NewScanScreen> createState() => _NewScanScreenState();
}

class _NewScanScreenState extends State<NewScanScreen> {
  bool _isScanning = false;

  Future<void> _startScan() async {
    setState(() => _isScanning = true);
    
    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isScanning = false);
      
      // Navigate to results (mock)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan complete! Results coming soon...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _pickFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pick from gallery - Coming soon'),
      ),
    );
  }

  void _manualInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Manual input - Coming soon'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Scan Product',
                      style: AppTheme.heading2,
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _showInstructionsDialog(context);
                      },
                    ),
                  ],
                ),
              ),

              // Camera View Placeholder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Camera placeholder
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 100,
                                color: AppTheme.primaryButton.withOpacity(0.3),
                              ),
                              const SizedBox(height: AppTheme.spacing24),
                              Text(
                                _isScanning
                                    ? 'Scanning...'
                                    : 'Align barcode inside the frame',
                                style: AppTheme.bodyLarge.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_isScanning) ...[
                                const SizedBox(height: AppTheme.spacing16),
                                const CircularProgressIndicator(),
                              ],
                            ],
                          ),
                        ),

                        // Scan frame overlay
                        if (!_isScanning)
                          Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.primaryButton,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusLarge,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Instructions
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing24,
                ),
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Column(
                  children: [
                    _buildInstructionItem(
                      icon: Icons.center_focus_strong,
                      text: 'Position barcode in the center',
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    _buildInstructionItem(
                      icon: Icons.light_mode,
                      text: 'Ensure good lighting',
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    _buildInstructionItem(
                      icon: Icons.camera_alt,
                      text: 'Hold steady until scan completes',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  children: [
                    // Scan Button
                    LiquidGlassButton(
                      text: 'Scan Barcode',
                      onPressed: _startScan,
                      icon: Icons.qr_code_scanner,
                      width: double.infinity,
                      isLoading: _isScanning,
                    ),
                    const SizedBox(height: AppTheme.spacing16),

                    // Alternative Options
                    Row(
                      children: [
                        Expanded(
                          child: LiquidGlassButton(
                            text: 'Gallery',
                            onPressed: _pickFromGallery,
                            icon: Icons.photo_library_outlined,
                            color: AppTheme.secondaryButton,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: LiquidGlassButton(
                            text: 'Manual',
                            onPressed: _manualInput,
                            icon: Icons.edit_outlined,
                            color: AppTheme.secondaryButton,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryButton,
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Scan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogInstruction('1', 'Find the barcode on the product'),
            const SizedBox(height: AppTheme.spacing12),
            _buildDialogInstruction('2', 'Position it inside the frame'),
            const SizedBox(height: AppTheme.spacing12),
            _buildDialogInstruction('3', 'Hold steady until scan completes'),
            const SizedBox(height: AppTheme.spacing12),
            _buildDialogInstruction('4', 'View instant dietary information'),
          ],
        ),
        actions: [
          LiquidGlassButton(
            text: 'Got it',
            onPressed: () => Navigator.pop(context),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildDialogInstruction(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.primaryButton,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
