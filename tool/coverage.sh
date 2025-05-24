#!/bin/bash

# Run tests with coverage
flutter test --coverage

# Generate HTML report from lcov data
if command -v genhtml &> /dev/null
then
    genhtml coverage/lcov.info -o coverage/html
    echo "HTML coverage report generated at coverage/html/index.html"
else
    echo "genhtml not found. Install lcov to generate HTML reports:"
    echo "  • macOS: brew install lcov"
    echo "  • Ubuntu: sudo apt-get install lcov"
fi

# Open report in browser (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html
fi
