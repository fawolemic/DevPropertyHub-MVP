import 'package:flutter_test/flutter_test.dart';

// Import all unit test files
import 'unit_tests/auth_provider_test.dart' as auth_provider_test;
import 'unit_tests/bandwidth_provider_test.dart' as bandwidth_provider_test;
import 'unit_tests/app_theme_test.dart' as app_theme_test;
import 'unit_tests/app_router_test.dart' as app_router_test;

// Import all widget test files
import 'widget_tests/login_screen_test.dart' as login_screen_test;
import 'widget_tests/development_card_test.dart' as development_card_test;

// Import all integration test files
import 'integration_tests/auth_flow_test.dart' as auth_flow_test;

void main() {
  group('All Unit Tests', () {
    auth_provider_test.main();
    bandwidth_provider_test.main();
    app_theme_test.main();
    app_router_test.main();
  });

  group('All Widget Tests', () {
    login_screen_test.main();
    development_card_test.main();
  });

  group('All Integration Tests', () {
    auth_flow_test.main();
  });
}
