#!/bin/bash
# Component Finder Script for DevPropertyHub
# Usage: ./scripts/find_component.sh "button"
#
# This script helps developers locate components by keyword.
# It searches through Dart files for specific keywords, tags, or component names.
# 
# Examples:
#   ./scripts/find_component.sh "button"       - Find all button-related components
#   ./scripts/find_component.sh "#hero"        - Find components tagged with #hero
#   ./scripts/find_component.sh "SEARCH TAGS"  - Find all components with search tags

# Check if search term is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a search term"
  echo "Usage: ./scripts/find_component.sh \"search term\""
  exit 1
fi

SEARCH_TERM="$1"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔍 Searching for components matching: $SEARCH_TERM"
echo "----------------------------------------"

# First search for search tags with the term
echo "🏷️  Components with matching tags:"
grep -r --include="*.dart" "SEARCH TAGS:.*$SEARCH_TERM" "$PROJECT_ROOT/lib" | while read -r line; do
  file=$(echo "$line" | cut -d':' -f1)
  class=$(grep -A 1 "class" "$file" | head -n 1 | sed 's/class //g' | cut -d' ' -f1)
  echo "📄 $class: $file"
done

echo ""

# Then search for class names matching the term
echo "🧩 Component classes matching the term:"
grep -r --include="*.dart" "class.*$SEARCH_TERM.*extends" "$PROJECT_ROOT/lib" | while read -r line; do
  file=$(echo "$line" | cut -d':' -f1)
  class=$(echo "$line" | sed 's/class //g' | cut -d' ' -f1)
  echo "📄 $class: $file"
done

echo ""

# Finally search for the term in comments and code
echo "💻 Files containing the term in code or comments:"
grep -r --include="*.dart" "$SEARCH_TERM" "$PROJECT_ROOT/lib" | grep -v "SEARCH TAGS" | while read -r line; do
  file=$(echo "$line" | cut -d':' -f1)
  content=$(echo "$line" | cut -d':' -f2-)
  echo "📄 $file: $content"
done

echo ""
echo "----------------------------------------"
echo "✅ Search complete!"
