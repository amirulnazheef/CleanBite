cat > vercel_install.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Install Flutter SDK into the build environment
FLUTTER_VERSION="3.24.5"   # you can change later if needed
FLUTTER_DIR="$HOME/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  echo "Installing Flutter $FLUTTER_VERSION..."
  curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o flutter.tar.xz
  tar xf flutter.tar.xz -C "$HOME"
  rm flutter.tar.xz
else
  echo "Flutter already installed in cache."
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --no-analytics
flutter precache --web

# Get deps and build
flutter pub get
flutter build web --release
EOF

