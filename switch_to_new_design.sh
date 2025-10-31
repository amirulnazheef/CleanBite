#!/bin/bash

# CleanBite - Switch to New Flat Design Script
# This script backs up old files and activates the new design

echo "🎨 CleanBite - Switching to Flat Design with Liquid Glass"
echo "=========================================================="
echo ""

# Create backup directory
echo "📦 Creating backup of old files..."
mkdir -p backup_old_design
mkdir -p backup_old_design/screens
mkdir -p backup_old_design/widgets
mkdir -p backup_old_design/config

# Backup old files
echo "💾 Backing up old design files..."
cp lib/main.dart backup_old_design/ 2>/dev/null || true
cp lib/config/app_theme.dart backup_old_design/config/ 2>/dev/null || true
cp lib/config/device_config.dart backup_old_design/config/ 2>/dev/null || true
cp lib/screens/splash_screen.dart backup_old_design/screens/ 2>/dev/null || true
cp lib/screens/login_screen.dart backup_old_design/screens/ 2>/dev/null || true
cp lib/screens/home_screen.dart backup_old_design/screens/ 2>/dev/null || true
cp lib/screens/scan_screen.dart backup_old_design/screens/ 2>/dev/null || true
cp lib/screens/profile_screen.dart backup_old_design/screens/ 2>/dev/null || true
cp lib/widgets/category_chip.dart backup_old_design/widgets/ 2>/dev/null || true
cp lib/widgets/recipe_card.dart backup_old_design/widgets/ 2>/dev/null || true

echo "✅ Backup complete in backup_old_design/"
echo ""

# Activate new design
echo "🚀 Activating new Flat Design..."
cp lib/main_new.dart lib/main.dart

echo "✅ New design activated!"
echo ""

# Run flutter commands
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🔍 Running analysis..."
flutter analyze

echo ""
echo "=========================================================="
echo "✨ Flat Design with Liquid Glass is now active!"
echo ""
echo "To run the app:"
echo "  flutter run"
echo ""
echo "To revert to old design:"
echo "  cp backup_old_design/main.dart lib/main.dart"
echo ""
echo "New screens available:"
echo "  ✅ Splash Screen (with animations)"
echo "  ✅ Onboarding (3 pages)"
echo "  ✅ Login Screen (Google + Email/Password)"
echo "  ✅ Signup Screen"
echo "  ✅ Main Menu (Bottom Tab Bar: Home, Scan, Profile)"
echo ""
echo "📖 See FLAT_DESIGN_IMPLEMENTATION_GUIDE.md for details"
echo "=========================================================="
