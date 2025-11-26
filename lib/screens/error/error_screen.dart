import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/custom_button.dart';

class ErrorScreen extends StatelessWidget {
  final Map<String, dynamic>? errorData;

  const ErrorScreen({super.key, this.errorData});

  @override
  Widget build(BuildContext context) {
    final errorType = errorData?['type'] ?? 'generic';
    final errorInfo = _getErrorInfo(errorType);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Error Icon
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: errorInfo.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    errorInfo.icon,
                    size: 70,
                    color: errorInfo.color,
                  ),
                ),
                const SizedBox(height: 40),
                // Error Title
                Text(
                  errorInfo.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                // Error Description
                Text(
                  errorInfo.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Suggestions
                if (errorInfo.suggestions.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Try this:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...errorInfo.suggestions.map((suggestion) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.success,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                const Spacer(),
                // Action Buttons
                CustomButton(
                  text: errorInfo.primaryAction,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (errorInfo.onPrimaryAction != null) {
                      errorInfo.onPrimaryAction!();
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (errorInfo.secondaryAction != null)
                  CustomButton(
                    text: errorInfo.secondaryAction!,
                    isOutlined: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ErrorInfo _getErrorInfo(String errorType) {
    switch (errorType) {
      case 'camera_permission':
        return ErrorInfo(
          icon: Icons.camera_alt_outlined,
          color: AppTheme.warning,
          title: 'Camera Access Required',
          description: 'We need camera access to scan barcodes and ingredients. Please grant permission in your device settings.',
          suggestions: [
            'Go to Settings > Apps > CleanBite > Permissions',
            'Enable Camera access',
            'Restart the app',
          ],
          primaryAction: 'Open Settings',
          secondaryAction: 'Go Back',
        );
      case 'barcode_not_found':
        return ErrorInfo(
          icon: Icons.qr_code_scanner,
          color: AppTheme.shubhahOrange,
          title: 'Barcode Not Found',
          description: 'We couldn\'t detect a barcode in the image. Make sure the barcode is clearly visible.',
          suggestions: [
            'Ensure good lighting',
            'Hold your camera steady',
            'Position barcode within the frame',
            'Try cleaning the barcode surface',
          ],
          primaryAction: 'Try Again',
        );
      case 'ingredients_unreadable':
        return ErrorInfo(
          icon: Icons.text_fields,
          color: AppTheme.shubhahOrange,
          title: 'Text Not Readable',
          description: 'We couldn\'t read the ingredients from the image. The text might be too blurry or small.',
          suggestions: [
            'Take a clearer photo',
            'Move closer to the text',
            'Ensure good lighting',
            'Avoid shadows on the label',
          ],
          primaryAction: 'Try Again',
        );
      case 'product_not_found':
        return ErrorInfo(
          icon: Icons.search_off,
          color: AppTheme.info,
          title: 'Product Not Found',
          description: 'This product isn\'t in our database yet. You can help by uploading the ingredients.',
          suggestions: [
            'Take a photo of the ingredients list',
            'Submit for community review',
            'Check back later for updates',
          ],
          primaryAction: 'Upload Ingredients',
          secondaryAction: 'Skip',
        );
      case 'network_error':
        return ErrorInfo(
          icon: Icons.wifi_off,
          color: AppTheme.error,
          title: 'No Connection',
          description: 'Please check your internet connection and try again.',
          suggestions: [
            'Check your WiFi or mobile data',
            'Try moving to an area with better signal',
            'Disable VPN if using one',
          ],
          primaryAction: 'Retry',
          secondaryAction: 'Go Offline',
        );
      case 'server_error':
        return ErrorInfo(
          icon: Icons.cloud_off,
          color: AppTheme.error,
          title: 'Server Unavailable',
          description: 'Our servers are temporarily unavailable. Please try again later.',
          suggestions: [
            'Wait a few minutes',
            'Check our status page',
            'Contact support if the issue persists',
          ],
          primaryAction: 'Retry',
          secondaryAction: 'Go Back',
        );
      default:
        return ErrorInfo(
          icon: Icons.error_outline,
          color: AppTheme.error,
          title: 'Something Went Wrong',
          description: 'An unexpected error occurred. Please try again.',
          suggestions: [
            'Restart the app',
            'Clear app cache',
            'Update to the latest version',
          ],
          primaryAction: 'Try Again',
          secondaryAction: 'Go Home',
        );
    }
  }
}

class ErrorInfo {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<String> suggestions;
  final String primaryAction;
  final String? secondaryAction;
  final VoidCallback? onPrimaryAction;

  ErrorInfo({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    this.suggestions = const [],
    required this.primaryAction,
    this.secondaryAction,
    this.onPrimaryAction,
  });
}

