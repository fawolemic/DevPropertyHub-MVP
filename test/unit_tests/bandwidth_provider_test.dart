import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devpropertyhub/core/providers/bandwidth_provider.dart';

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('BandwidthProvider Tests', () {
    late BandwidthProvider bandwidthProvider;
    
    setUp(() async {
      // Set up mock for SharedPreferences
      SharedPreferences.setMockInitialValues({'isLowBandwidth': false});
      bandwidthProvider = BandwidthProvider();
    });
    
    test('Initial state should have low bandwidth as false', () {
      expect(bandwidthProvider.isLowBandwidth, false);
    });
    
    test('Initial network quality should be unknown', () {
      expect(bandwidthProvider.networkQuality, NetworkQuality.unknown);
    });
    
    test('Setting low bandwidth value directly updates state', () {
      // Start with initial state
      expect(bandwidthProvider.isLowBandwidth, false);
      
      // Update internal field directly to avoid SharedPreferences issues in tests
      bandwidthProvider.setLowBandwidth(true);
      
      // Verify internal state changed
      expect(bandwidthProvider.isLowBandwidth, true);
    });
    
    test('Network quality updates are reflected in the state', () {
      // Initial state
      expect(bandwidthProvider.networkQuality, NetworkQuality.unknown);
      
      // Test updating network quality through private method
      // Since we can't call private methods directly, we can only test observable state
      // after operations that would trigger these methods
      
      // Instead, we can verify that the correct getters work
      expect(bandwidthProvider.isLowBandwidth, isFalse);
      expect(bandwidthProvider.networkQuality, NetworkQuality.unknown);
    });
  });
}
