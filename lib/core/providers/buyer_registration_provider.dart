import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Buyer registration provider for managing the buyer registration process
/// Optimized for low-bandwidth scenarios in African markets
class BuyerRegistrationProvider with ChangeNotifier {
  // Current step in the registration process
  int _currentStep = 1;
  int get currentStep => _currentStep;
  
  // Maximum number of steps in the buyer registration process (simpler than developer)
  final int _totalSteps = 2;
  int get totalSteps => _totalSteps;

  // Registration data for each step
  final Map<String, dynamic> _step1Data = {}; // Personal Information
  final Map<String, dynamic> _step2Data = {}; // Preferences & Interests

  // Getters for step data
  Map<String, dynamic> get step1Data => Map.unmodifiable(_step1Data);
  Map<String, dynamic> get step2Data => Map.unmodifiable(_step2Data);
  
  // Status tracking
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _registrationComplete = false;
  bool get registrationComplete => _registrationComplete;

  // Step 1 validation: Personal Information
  bool validateStep1Data(Map<String, dynamic> data) {
    // Reset error message
    _errorMessage = null;

    // Check required fields
    if (data['email'] == null || data['email'].isEmpty) {
      _errorMessage = 'Email is required';
      return false;
    }

    if (data['password'] == null || data['password'].isEmpty) {
      _errorMessage = 'Password is required';
      return false;
    }

    if (data['fullName'] == null || data['fullName'].isEmpty) {
      _errorMessage = 'Full name is required';
      return false;
    }

    if (data['phone'] == null || data['phone'].isEmpty) {
      _errorMessage = 'Phone number is required';
      return false;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegex.hasMatch(data['email'])) {
      _errorMessage = 'Please enter a valid email address';
      return false;
    }

    // Validate password complexity - slightly simplified for buyers
    if (data['password'].length < 8) {
      _errorMessage = 'Password must be at least 8 characters long';
      return false;
    }

    // Phone number validation (simple Nigerian format check)
    final phoneRegex = RegExp(r'^(\+234|0)[0-9]{10}$');
    if (!phoneRegex.hasMatch(data['phone'])) {
      _errorMessage = 'Please enter a valid Nigerian phone number (e.g., +2348012345678 or 08012345678)';
      return false;
    }

    return true;
  }

  // Step 2 validation: Preferences & Interests
  bool validateStep2Data(Map<String, dynamic> data) {
    // Reset error message
    _errorMessage = null;

    // Validate property preferences
    if (data['propertyTypes'] == null || (data['propertyTypes'] is List && data['propertyTypes'].isEmpty)) {
      _errorMessage = 'Please select at least one property type';
      return false;
    }

    // Validate location preferences
    if (data['preferredLocations'] == null || (data['preferredLocations'] is List && data['preferredLocations'].isEmpty)) {
      _errorMessage = 'Please select at least one preferred location';
      return false;
    }

    // Validate budget range
    if (data['budgetRange'] == null || data['budgetRange'].isEmpty) {
      _errorMessage = 'Please specify your budget range';
      return false;
    }

    return true;
  }

  // Save data for each step
  void saveStep1Data(Map<String, dynamic> data) {
    _step1Data.clear();
    _step1Data.addAll(data);
    notifyListeners();
  }

  void saveStep2Data(Map<String, dynamic> data) {
    _step2Data.clear();
    _step2Data.addAll(data);
    notifyListeners();
  }

  // Advance to next step if validation passes
  bool nextStep(Map<String, dynamic> currentStepData) {
    bool isValid = false;
    
    // Validate based on current step
    if (_currentStep == 1) {
      isValid = validateStep1Data(currentStepData);
      if (isValid) {
        saveStep1Data(currentStepData);
      }
    } else if (_currentStep == 2) {
      isValid = validateStep2Data(currentStepData);
      if (isValid) {
        saveStep2Data(currentStepData);
      }
    }
    
    // If validation passed, move to next step
    if (isValid && _currentStep < _totalSteps) {
      _currentStep++;
      notifyListeners();
      return true;
    } else if (isValid && _currentStep == _totalSteps) {
      // Last step completed successfully
      return true;
    }
    
    return false;
  }

  // Go to a specific step if allowed
  bool goToStep(int step) {
    if (step < 1 || step > _totalSteps) return false;
    
    // Can freely go back to previous steps
    if (step < _currentStep) {
      _currentStep = step;
      notifyListeners();
      return true;
    }
    
    // Can only advance to next step if current step is valid
    if (step == _currentStep + 1) {
      // This should be handled by nextStep() method instead
      return false;
    }
    
    return false;
  }

  // Submit registration
  Future<bool> submitRegistration() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // For MVP, we're just simulating the API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Replace with actual API call
      final response = {
        'success': true,
        'message': 'Registration successful'
      };
      
      if (response['success'] == true) {
        _registrationComplete = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during registration: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset registration state
  void resetRegistration() {
    _currentStep = 1;
    _step1Data.clear();
    _step2Data.clear();
    _isLoading = false;
    _errorMessage = null;
    _registrationComplete = false;
    notifyListeners();
  }
  
  // Get combined registration data
  Map<String, dynamic> get allRegistrationData {
    final combinedData = <String, dynamic>{};
    combinedData.addAll(_step1Data);
    combinedData.addAll(_step2Data);
    combinedData['userType'] = 'buyer'; // Explicitly set user type
    return combinedData;
  }

  // Get registration data as JSON
  String get registrationDataJson {
    return jsonEncode(allRegistrationData);
  }
}
