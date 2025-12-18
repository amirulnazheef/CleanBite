import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/image_picker_service.dart';
import '../../core/services/backend_service.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  final MobileScannerController _scannerController =
      MobileScannerController();

  bool _flashOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /* -------------------- BARCODE HANDLER -------------------- */

  Future<void> _handleBarcode(
    String barcode, {
    bool fromImage = false,
  }) async {
    if (_isProcessing && !fromImage) return;
    if (mounted) setState(() => _isProcessing = true);

    try {
      final product = await _fetchProductFromFirestore(barcode);

      if (!mounted) return;

      if (product != null) {
        Navigator.of(context).pushNamed(
          AppRoutes.processing,
          arguments: {
            'type': 'barcode',
            'barcode': barcode,
            'backendResponse': product, // expected to mirror backend payload shape
          },
        );
      } else {
        _showError('Product not found in database');
      }
    } catch (_) {
      _showError('Failed to fetch product data');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      } else {
        _isProcessing = false;
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchProductFromFirestore(String barcode) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(barcode)
        .get();

    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;

    return _mapProductDocument(barcode, data);
  }

  Map<String, dynamic> _mapProductDocument(
    String barcode,
    Map<String, dynamic> data,
  ) {
    final classificationFlags = {
      'halal': data['halal'] == true,
      'kosher': data['kosher'] == true,
      'vegan': data['vegan'] == true,
      'vegetarian': data['vegetarian'] == true,
    };

    final hasAnyFlagTrue = classificationFlags.values.any((v) => v == true);
    final flagsOrNull = hasAnyFlagTrue ? classificationFlags : null;

    return {
      'status': 'success',
      'productName': data['productName']?.toString() ?? 'Unknown product',
      'classification': flagsOrNull,
      'ingredients': <Map<String, dynamic>>[],
      'dietary_summary': data['dietarySummary']?.toString(),
      'allergens': (data['allergens'] as List?)?.map((e) => e.toString()).toList() ?? <String>[],
      'facts': {
        'verified': data['verified'] == true,
        'source': 'firestore',
        'barcode': barcode,
      },
      'used_ai': false,
    };
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  /* -------------------- GALLERY PICK -------------------- */

  Future<void> _pickFromGallery() async {
    final result = await ImagePickerService().pickFromGallery(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (result == null || !mounted) return;

    await _processBarcodeImage(result);
  }

  Future<void> _processBarcodeImage(ImagePickerResult image) async {
    if (_isProcessing) return;
    if (mounted) {
      setState(() => _isProcessing = true);
    }

    try {
      dynamic payload;
      if (image.bytes != null) {
        payload = Uint8List.fromList(image.bytes!);
      } else if (image.path != null) {
        payload = File(image.path!);
      } else {
        _showError('Image data unavailable');
        return;
      }

      final backend = BackendService();
      final resp = await backend.processImage(
        payload,
        fileName: image.name,
        endpoint: '/read-barcode',
      );

      if (!mounted) return;

      if (resp != null && resp['success'] == true && resp['barcode'] != null) {
        final detected = resp['barcode'].toString();
        await _handleBarcode(detected, fromImage: true);
      } else {
        _showError('No barcode detected in the selected image');
      }
    } catch (_) {
      if (mounted) {
        _showError('Failed to read barcode from image');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      } else {
        _isProcessing = false;
      }
    }
  }

  /* -------------------- UI -------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// CAMERA
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final String? value = barcode.rawValue;

              if (value != null) {
                _handleBarcode(value);
              }
            },
          ),

          /// OVERLAY
          CustomPaint(
            painter: ScanOverlayPainter(),
            child: Container(),
          ),

          /// SCAN LINE
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 280,
                height: 180,
                child: AnimatedBuilder(
                  animation: _scanLineAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _scanLineAnimation.value * 160),
                      child: child,
                    );
                  },
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.primaryOrange,
                          AppTheme.primaryOrange,
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppTheme.primaryOrange.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.close,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  _circleButton(
                    icon: _flashOn ? Icons.flash_on : Icons.flash_off,
                    onTap: () {
                      setState(() {
                        _flashOn = !_flashOn;
                        _scannerController.toggleTorch();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM CONTROLS
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
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Scan Barcode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Align barcode within the frame',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _circleButton(
                        icon: Icons.photo_library_outlined,
                        onTap: _pickFromGallery,
                      ),
                      const SizedBox(width: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      const SizedBox(width: 44, height: 44),
                    ],
                  ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.scanIngredients);
                    },
                    child: Text(
                      'Product not found? Scan ingredients instead',
                      style: TextStyle(
                        color: AppTheme.primaryOrangeLight,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
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
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

/* -------------------- OVERLAY PAINTER -------------------- */

class ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    const scanWidth = 280.0;
    const scanHeight = 180.0;
    final left = (size.width - scanWidth) / 2;
    final top = (size.height - scanHeight) / 2;
    final right = left + scanWidth;
    final bottom = top + scanHeight;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, right, bottom),
          const Radius.circular(20),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final bracketPaint = Paint()
      ..color = AppTheme.primaryOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const c = 30.0;

    canvas.drawLine(Offset(left, top), Offset(left + c, top), bracketPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + c), bracketPaint);

    canvas.drawLine(Offset(right, top), Offset(right - c, top), bracketPaint);
    canvas.drawLine(Offset(right, top), Offset(right, top + c), bracketPaint);

    canvas.drawLine(
        Offset(left, bottom), Offset(left + c, bottom), bracketPaint);
    canvas.drawLine(
        Offset(left, bottom), Offset(left, bottom - c), bracketPaint);

    canvas.drawLine(
        Offset(right, bottom), Offset(right - c, bottom), bracketPaint);
    canvas.drawLine(
        Offset(right, bottom), Offset(right, bottom - c), bracketPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
