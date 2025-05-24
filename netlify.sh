#!/bin/bash

# Download and install Flutter
git clone https://github.com/flutter/flutter.git --branch stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build web application
flutter build web --release

# Print success message
echo "Flutter web build completed successfully!"
