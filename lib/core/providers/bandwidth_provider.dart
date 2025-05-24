import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NetworkQuality {
  unknown,
  poor,
  moderate,
  good
}

class BandwidthProvider with ChangeNotifier {
  bool _isLowBandwidth = false;
  NetworkQuality _networkQuality = NetworkQuality.unknown;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  bool get isLowBandwidth => _isLowBandwidth;
  NetworkQuality get networkQuality => _networkQuality;
  
  // Initialize bandwidth detection
  Future<void> init() async {
    // First, try to load saved preference
    final prefs = await SharedPreferences.getInstance();
    _isLowBandwidth = prefs.getBool('isLowBandwidth') ?? false;
    
    // If running on web, set up JavaScript interop for better detection
    if (kIsWeb) {
      _setupWebBandwidthDetection();
    }
    
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectivity);
    
    // Do initial check
    _checkConnectivity();
    
    notifyListeners();
  }
  
  // Set up JavaScript interop for web bandwidth detection
  void _setupWebBandwidthDetection() {
    if (kIsWeb) {
      // Platform channels only work on native platforms
      try {
        // This would use a JavaScript channel in a real implementation
        // For the MVP, we'll just simulate with a timer
        Timer.periodic(const Duration(seconds: 10), (_) {
          _simulateWebBandwidthCheck();
        });
      } catch (e) {
        print('Error setting up web bandwidth detection: $e');
      }
    }
  }
  
  // Simulate bandwidth check on web
  void _simulateWebBandwidthCheck() {
    // In a real app, this would use JavaScript to detect actual bandwidth
    // For the MVP, we'll randomly simulate different connection qualities
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    switch (random) {
      case 0:
        _updateNetworkQuality(NetworkQuality.good);
        break;
      case 1:
        _updateNetworkQuality(NetworkQuality.moderate);
        break;
      case 2:
        _updateNetworkQuality(NetworkQuality.poor);
        break;
    }
  }
  
  // Check current connectivity status
  Future<void> _checkConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      result = ConnectivityResult.none;
    }
    return _updateConnectivity(result);
  }
  
  // Update connectivity status
  Future<void> _updateConnectivity(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _updateNetworkQuality(NetworkQuality.poor);
    } else if (result == ConnectivityResult.mobile) {
      // Mobile connections might be slower, check further if possible
      _updateNetworkQuality(NetworkQuality.moderate);
    } else if (result == ConnectivityResult.wifi || 
               result == ConnectivityResult.ethernet) {
      _updateNetworkQuality(NetworkQuality.good);
    } else {
      _updateNetworkQuality(NetworkQuality.unknown);
    }
  }
  
  // Update network quality and low bandwidth flag
  void _updateNetworkQuality(NetworkQuality quality) async {
    _networkQuality = quality;
    
    // Update low bandwidth mode based on network quality
    final newLowBandwidthState = quality == NetworkQuality.poor;
    
    if (_isLowBandwidth != newLowBandwidthState) {
      _isLowBandwidth = newLowBandwidthState;
      
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLowBandwidth', _isLowBandwidth);
      
      notifyListeners();
    }
  }
  
  // Manually toggle low bandwidth mode (for testing or user preference)
  Future<void> toggleLowBandwidthMode() async {
    _isLowBandwidth = !_isLowBandwidth;
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLowBandwidth', _isLowBandwidth);
    
    notifyListeners();
  }
  
  // Force set low bandwidth mode
  Future<void> setLowBandwidthMode(bool value) async {
    if (_isLowBandwidth != value) {
      _isLowBandwidth = value;
      
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLowBandwidth', _isLowBandwidth);
      
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
