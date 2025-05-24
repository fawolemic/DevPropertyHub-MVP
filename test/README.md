# DevPropertyHub Testing Structure

This directory contains the test suite for the DevPropertyHub application. The tests are organized into three main categories:

## Directory Structure

```
test/
├── unit_tests/      # Tests for individual functions, classes, and business logic
├── widget_tests/    # Tests for UI components and widgets
├── integration_tests/ # Tests for combined functionality across multiple components
├── all_tests.dart   # Runner for all tests
└── README.md        # This file
```

## Test Categories

### Unit Tests
Located in `unit_tests/`, these tests verify individual units of code in isolation, such as:
- Provider classes (auth_provider_test.dart, bandwidth_provider_test.dart)
- Theme configuration (app_theme_test.dart)
- Utility functions

### Widget Tests
Located in `widget_tests/`, these tests verify UI components render correctly and respond to interactions:
- Screens (login_screen_test.dart)
- Reusable widgets (development_card_test.dart)

### Integration Tests
Located in `integration_tests/`, these tests verify combined functionality across multiple components:
- User flows (login flow, development creation flow)
- Navigation and state management

## Running Tests

To run all tests:

```bash
flutter test
```

To run a specific test:

```bash
flutter test test/unit_tests/auth_provider_test.dart
```

To run tests with coverage:

```bash
flutter test --coverage
```

## Mock Objects

We use Mockito to create mock objects for testing. These mocks are defined manually in each test file to avoid dependencies on code generation tools.

## Test Coverage

Our goal is to maintain high test coverage for critical components:
- Auth and user management: 90%+
- Core business logic: 80%+
- UI components: 70%+

## Adding New Tests

When adding new features or fixing bugs:
1. Add corresponding unit tests for any new business logic
2. Add widget tests for any new UI components
3. Update integration tests if the feature affects user flows
