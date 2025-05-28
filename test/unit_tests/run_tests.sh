#!/bin/bash

# Generate mock files
echo "Generating mock files..."
flutter pub run build_runner build --delete-conflicting-outputs

# Run all tests
echo "Running tests..."
flutter test test/unit_tests/
