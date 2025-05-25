#!/bin/bash
# Documentation Generator Script for DevPropertyHub
# This script generates HTML documentation from Dart code comments
#
# Prerequisites:
#   - dartdoc package installed (pub global activate dartdoc)
#
# Usage:
#   ./scripts/generate_docs.sh

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$PROJECT_ROOT/docs"

echo "📝 Generating documentation for DevPropertyHub..."
echo "------------------------------------------------"

# Check if dartdoc is installed
if ! command -v dartdoc &> /dev/null; then
    echo "❌ dartdoc not found. Installing..."
    dart pub global activate dartdoc
fi

# Clean previous docs
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Navigate to project root
cd "$PROJECT_ROOT"

# Generate documentation
echo "🔍 Analyzing code and generating documentation..."
dartdoc --output "$OUTPUT_DIR" --exclude 'dart:io,dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:math,dart:typed_data,dart:ui'

# Check if documentation was generated successfully
if [ -d "$OUTPUT_DIR/api" ]; then
    echo "✅ Documentation generated successfully!"
    echo "📂 Documentation is available at: $OUTPUT_DIR"
    echo ""
    echo "To view the documentation in a browser, run:"
    echo "open $OUTPUT_DIR/api/index.html"
else
    echo "❌ Failed to generate documentation."
    echo "Please check for errors above and ensure your code is properly documented."
fi
