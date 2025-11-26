import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/image_picker_service.dart';

class IngredientScannerScreen extends StatefulWidget {
  const IngredientScannerScreen({super.key});

  @override
  State<IngredientScannerScreen> createState() => _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen> {
  bool _flashOn = false;
  bool _photoTaken = false;
  ImagePickerResult? _capturedImage;

  void _takePhoto() {
    setState(() {
      _photoTaken = true;
    });
  }

  void _retakePhoto() {
    setState(() {
      _photoTaken = false;
      _capturedImage = null;
    });
  }

  void _usePhoto() {
    if (_capturedImage != null) {
      Navigator.of(context).pushNamed(
        AppRoutes.processing,
        arguments: {
          'type': 'ingredients',
          'source': 'gallery',
          'imagePath': _capturedImage!.path,
          'imageBytes': _capturedImage!.bytes,
          'imageName': _capturedImage!.name,
          'data': 'Sample ingredients: Water, Sugar, Salt, Natural Flavors, Citric Acid, Sodium Benzoate',
        },
      );
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.processing,
        arguments: {
          'type': 'ingredients',
          'source': 'camera',
          'data': 'Sample ingredients: Water, Sugar, Salt, Natural Flavors, Citric Acid, Sodium Benzoate',
        },
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final result = await ImagePickerService().pickFromGallery(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (result != null && mounted) {
      setState(() {
        _photoTaken = true;
        _capturedImage = result;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected: ${result.name ?? "image"}'),
          backgroundColor: AppTheme.success,
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No image selected'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview Placeholder
          Container(
            color: _photoTaken ? Colors.grey[900] : Colors.black87,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _photoTaken ? Icons.image : Icons.document_scanner,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _photoTaken 
                        ? (_capturedImage != null ? 'Image from gallery' : 'Photo captured')
                        : 'Camera Preview\n(Add camera package for live preview)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Grid Overlay (only when not photo taken)
          if (!_photoTaken)
            CustomPaint(
              painter: GridOverlayPainter(),
              child: Container(),
            ),
          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  _buildCircleButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  // Flash Toggle (only when camera active)
                  if (!_photoTaken)
                    _buildCircleButton(
                      icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                      onTap: () {
                        setState(() {
                          _flashOn = !_flashOn;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _photoTaken ? 'Review Photo' : 'Scan Ingredients',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _photoTaken 
                        ? 'Make sure the text is clear and readable'
                        : 'Position the ingredients list within frame',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_photoTaken) ...[
                    // Photo taken - show retake and use buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          icon: Icons.refresh,
                          label: 'Retake',
                          onTap: _retakePhoto,
                          isOutlined: true,
                        ),
                        const SizedBox(width: 20),
                        _buildActionButton(
                          icon: Icons.check,
                          label: 'Use Photo',
                          onTap: _usePhoto,
                          isOutlined: false,
                        ),
                      ],
                    ),
                  ] else ...[
                    // Camera mode - show capture button with gallery
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gallery button (bottom left)
                        _buildCircleButton(
                          icon: Icons.photo_library_outlined,
                          onTap: _pickFromGallery,
                        ),
                        const SizedBox(width: 40),
                        // Capture button (center)
                        GestureDetector(
                          onTap: _takePhoto,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        // Placeholder for symmetry
                        const SizedBox(width: 44, height: 44),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isOutlined,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppTheme.primaryOrange,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isOutlined ? Colors.white : AppTheme.primaryOrange,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw grid lines
    final horizontalSpacing = size.height / 3;
    final verticalSpacing = size.width / 3;

    for (int i = 1; i < 3; i++) {
      // Horizontal lines
      canvas.drawLine(
        Offset(0, horizontalSpacing * i),
        Offset(size.width, horizontalSpacing * i),
        paint,
      );
      // Vertical lines
      canvas.drawLine(
        Offset(verticalSpacing * i, 0),
        Offset(verticalSpacing * i, size.height),
        paint,
      );
    }

    // Draw frame rectangle
    final framePaint = Paint()
      ..color = AppTheme.primaryOrange.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final margin = 40.0;
    final frameRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        margin,
        size.height * 0.25,
        size.width - margin * 2,
        size.height * 0.4,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(frameRect, framePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
