import 'package:flutter/material.dart';

class DeviceConfig {
  // iPhone 16 Pro specifications
  static const double iphone16ProWidth = 2622;
  static const double iphone16ProHeight = 1206;
  static const double iphone16ProPPI = 460;
  static const double iphone16ProDiagonal = 6.3;
  static const double iphone16ProAspectRatio = 19.5 / 9;
  
  // Design dimensions (logical pixels for Flutter)
  // Flutter uses logical pixels, not physical pixels
  // iPhone 16 Pro uses 3x scale factor
  static const double designWidth = 393; // 2622 / 3 ≈ 874, but iOS uses 393 logical width
  static const double designHeight = 852; // 1206 / 3 ≈ 402, but iOS uses 852 logical height
  
  // Get scale factor based on screen width
  static double getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / designWidth;
  }
  
  // Get responsive size
  static double getResponsiveSize(BuildContext context, double size) {
    return size * getScaleFactor(context);
  }
  
  // Get responsive width
  static double getResponsiveWidth(BuildContext context, double width) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (width / designWidth) * screenWidth;
  }
  
  // Get responsive height
  static double getResponsiveHeight(BuildContext context, double height) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (height / designHeight) * screenHeight;
  }
  
  // Check if device is iPhone 16 Pro or similar
  static bool isIPhone16ProSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.height / size.width;
    // Check if aspect ratio is close to 19.5:9 (2.166...)
    return (aspectRatio - iphone16ProAspectRatio).abs() < 0.1;
  }
  
  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  
  // Standard spacing values (scaled)
  static double spacing4(BuildContext context) => getResponsiveSize(context, 4);
  static double spacing8(BuildContext context) => getResponsiveSize(context, 8);
  static double spacing12(BuildContext context) => getResponsiveSize(context, 12);
  static double spacing16(BuildContext context) => getResponsiveSize(context, 16);
  static double spacing24(BuildContext context) => getResponsiveSize(context, 24);
  static double spacing32(BuildContext context) => getResponsiveSize(context, 32);
  static double spacing40(BuildContext context) => getResponsiveSize(context, 40);
  static double spacing48(BuildContext context) => getResponsiveSize(context, 48);
  
  // Standard font sizes (scaled)
  static double fontSize12(BuildContext context) => getResponsiveSize(context, 12);
  static double fontSize14(BuildContext context) => getResponsiveSize(context, 14);
  static double fontSize16(BuildContext context) => getResponsiveSize(context, 16);
  static double fontSize18(BuildContext context) => getResponsiveSize(context, 18);
  static double fontSize20(BuildContext context) => getResponsiveSize(context, 20);
  static double fontSize24(BuildContext context) => getResponsiveSize(context, 24);
  static double fontSize28(BuildContext context) => getResponsiveSize(context, 28);
  static double fontSize32(BuildContext context) => getResponsiveSize(context, 32);
  static double fontSize48(BuildContext context) => getResponsiveSize(context, 48);
}
