#!/bin/bash

# Test script for iPhone 16 Pro configuration
# This script helps verify the app is properly configured for iPhone 16 Pro

echo "🍎 CleanBite - iPhone 16 Pro Configuration Test"
echo "================================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter is installed"
flutter --version
echo ""

# Check for iOS development setup
echo "📱 Checking iOS development setup..."
if ! command -v xcodebuild &> /dev/null; then
    echo "⚠️  Xcode is not installed. iOS development requires Xcode."
else
    echo "✅ Xcode is installed"
    xcodebuild -version
fi
echo ""

# Check Flutter dependencies
echo "📦 Checking Flutter dependencies..."
flutter pub get
echo ""

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze
echo ""

# Check for iOS simulators
echo "📱 Available iOS Simulators:"
xcrun simctl list devices | grep "iPhone 16 Pro" || echo "⚠️  iPhone 16 Pro simulator not found"
echo ""

# Display device specifications
echo "📐 iPhone 16 Pro Specifications:"
echo "   Screen Resolution: 2622 × 1206 pixels"
echo "   Pixel Density: 460 PPI"
echo "   Screen Size: 6.3 inches"
echo "   Aspect Ratio: 19.5:9"
echo "   Logical Resolution: 393 × 852 points"
echo "   Scale Factor: 3x"
echo ""

# Check configuration files
echo "📄 Checking configuration files..."
if [ -f "lib/config/device_config.dart" ]; then
    echo "✅ Device config found: lib/config/device_config.dart"
else
    echo "❌ Device config not found"
fi

if [ -f "ios/Runner/Info.plist" ]; then
    echo "✅ iOS Info.plist found"
    echo "   Checking orientation settings..."
    if grep -q "UIInterfaceOrientationPortrait" ios/Runner/Info.plist; then
        echo "   ✅ Portrait orientation configured"
    fi
else
    echo "❌ iOS Info.plist not found"
fi

if [ -f "IPHONE_16_PRO_CONFIG.md" ]; then
    echo "✅ Configuration documentation found"
else
    echo "⚠️  Configuration documentation not found"
fi
echo ""

# Instructions
echo "🚀 Next Steps:"
echo "   1. Open iOS Simulator with iPhone 16 Pro:"
echo "      open -a Simulator"
echo ""
echo "   2. Run the app:"
echo "      flutter run -d <device-id>"
echo ""
echo "   3. Or run on physical iPhone 16 Pro:"
echo "      flutter devices"
echo "      flutter run -d <your-iphone-id>"
echo ""
echo "   4. Test responsive sizing:"
echo "      - Check logo size on splash screen"
echo "      - Verify text sizes are readable"
echo "      - Test all screens for proper layout"
echo "      - Rotate device (portrait only should work)"
echo ""

echo "✨ Configuration test complete!"
