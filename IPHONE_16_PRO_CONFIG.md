# iPhone 16 Pro Configuration for CleanBite

## Device Specifications

### iPhone 16 Pro Display
- **Screen Resolution**: 2622 × 1206 pixels (physical)
- **Pixel Density**: 460 PPI
- **Screen Size**: 6.3 inches (diagonal)
- **Aspect Ratio**: 19.5:9 (2.166:1)
- **Logical Resolution**: 393 × 852 points (3x scale factor)
- **Display Type**: Super Retina XDR OLED

## Flutter Configuration

### 1. Device Config (`lib/config/device_config.dart`)
This file provides responsive sizing utilities optimized for iPhone 16 Pro:

```dart
// Design dimensions (logical pixels)
static const double designWidth = 393;
static const double designHeight = 852;

// Helper methods for responsive sizing
- getScaleFactor(context)
- getResponsiveSize(context, size)
- getResponsiveWidth(context, width)
- getResponsiveHeight(context, height)
- spacing4/8/12/16/24/32/40/48(context)
- fontSize12/14/16/18/20/24/28/32/48(context)
```

### 2. Main App Configuration (`lib/main.dart`)
- **Portrait-only orientation** (UIInterfaceOrientationPortrait)
- **Transparent status bar** for edge-to-edge display
- **Material 3 design** with adaptive platform density
- **Text scale factor locked** to 1.0 for consistent sizing
- **System UI overlay** optimized for iOS

### 3. iOS Configuration (`ios/Runner/Info.plist`)
- **Supported orientations**: Portrait and Portrait Upside Down only
- **Status bar style**: Default (dark icons on light background)
- **Launch screen**: Optimized for iPhone 16 Pro aspect ratio

## How to Use Responsive Sizing

### Example 1: Responsive Padding
```dart
import 'package:cleanbite/config/device_config.dart';

Container(
  padding: EdgeInsets.all(DeviceConfig.spacing16(context)),
  child: Text('Hello'),
)
```

### Example 2: Responsive Font Size
```dart
Text(
  'CleanBite',
  style: TextStyle(
    fontSize: DeviceConfig.fontSize24(context),
    fontWeight: FontWeight.bold,
  ),
)
```

### Example 3: Responsive Width/Height
```dart
Container(
  width: DeviceConfig.getResponsiveWidth(context, 300),
  height: DeviceConfig.getResponsiveHeight(context, 200),
  child: Image.asset('assets/images/logo.png'),
)
```

### Example 4: Check Device Type
```dart
if (DeviceConfig.isIPhone16ProSize(context)) {
  // Special handling for iPhone 16 Pro
  return OptimizedLayout();
}
```

## Screen Dimensions

### Physical Pixels vs Logical Pixels
- **Physical**: 2622 × 1206 pixels (actual hardware pixels)
- **Logical**: 393 × 852 points (Flutter uses these)
- **Scale Factor**: 3x (2622 ÷ 3 ≈ 874, but iOS uses 393 logical width)

### Safe Area Considerations
iPhone 16 Pro has:
- **Top notch/Dynamic Island**: ~59 points
- **Bottom home indicator**: ~34 points
- **Side margins**: Minimal (rounded corners)

Use `SafeArea` widget or `MediaQuery.of(context).padding` to handle these.

## Testing on iPhone 16 Pro

### iOS Simulator
```bash
# List available simulators
xcrun simctl list devices

# Boot iPhone 16 Pro simulator
open -a Simulator --args -CurrentDeviceUDID <iPhone-16-Pro-UDID>

# Run Flutter app
flutter run -d <device-id>
```

### Physical Device
```bash
# Connect iPhone 16 Pro via USB
flutter devices

# Run on connected device
flutter run -d <device-id>
```

## Optimization Tips

### 1. Use Responsive Sizing
Always use `DeviceConfig` helper methods instead of hardcoded values:
```dart
// ❌ Bad
padding: EdgeInsets.all(16)

// ✅ Good
padding: EdgeInsets.all(DeviceConfig.spacing16(context))
```

### 2. Handle Safe Areas
```dart
SafeArea(
  child: Scaffold(
    body: YourContent(),
  ),
)
```

### 3. Test Different Orientations
Although locked to portrait, test both:
- Portrait (normal)
- Portrait Upside Down

### 4. Optimize Images
For iPhone 16 Pro's high PPI (460):
- Use @3x image assets
- Provide high-resolution images (at least 1.5x the display size)
- Use vector graphics (SVG) when possible

### 5. Performance
- Enable Metal rendering (default on iOS)
- Use `const` constructors where possible
- Optimize image loading with `precacheImage()`

## Display Features

### Dynamic Island Support
The iPhone 16 Pro has a Dynamic Island. Ensure your UI doesn't overlap:
```dart
// Top padding accounts for Dynamic Island
final topPadding = MediaQuery.of(context).padding.top;
```

### ProMotion Display (120Hz)
- Automatically supported by Flutter
- Smooth animations up to 120fps
- No special configuration needed

### HDR Support
- Use appropriate color spaces
- Test with high-contrast content
- Consider dark mode optimization

## Troubleshooting

### Issue: UI looks too small/large
**Solution**: Adjust the scale factor in `DeviceConfig.getScaleFactor()`

### Issue: Text is cut off
**Solution**: Use `FittedBox` or adjust font sizes with responsive methods

### Issue: Images appear blurry
**Solution**: Provide @3x resolution images (3 × desired logical size)

### Issue: Layout breaks on other devices
**Solution**: Test on multiple screen sizes and use responsive sizing throughout

## Resources

- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [iPhone 16 Pro Specifications](https://www.apple.com/iphone-16-pro/specs/)
