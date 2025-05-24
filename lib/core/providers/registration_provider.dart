import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Registration provider for managing multi-step registration
class RegistrationProvider with ChangeNotifier {
  // Current step in the registration process
  int _currentStep = 1;
  int get currentStep => _currentStep;
  
  // Maximum number of steps in the registration process
  final int _totalSteps = 3;
  int get totalSteps => _totalSteps;

  // Registration data for each step
  final Map<String, dynamic> _step1Data = {};
  final Map<String, dynamic> _step2Data = {};
  final Map<String, dynamic> _step3Data = {};

  // Getters for step data
  Map<String, dynamic> get step1Data => Map.unmodifiable(_step1Data);
  Map<String, dynamic> get step2Data => Map.unmodifiable(_step2Data);
  Map<String, dynamic> get step3Data => Map.unmodifiable(_step3Data);
  
  // Status tracking
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _registrationComplete = false;
  bool get registrationComplete => _registrationComplete;

  // Step 1 validation: Basic Information
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

    if (data['companyName'] == null || data['companyName'].isEmpty) {
      _errorMessage = 'Company name is required';
      return false;
    }

    if (data['contactPerson'] == null || data['contactPerson'].isEmpty) {
      _errorMessage = 'Contact person name is required';
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

    // Validate password complexity
    if (data['password'].length < 8) {
      _errorMessage = 'Password must be at least 8 characters long';
      return false;
    }

    if (!data['password'].contains(RegExp(r'[A-Z]'))) {
      _errorMessage = 'Password must contain at least one uppercase letter';
      return false;
    }

    if (!data['password'].contains(RegExp(r'[0-9]'))) {
      _errorMessage = 'Password must contain at least one number';
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

  // Step 2 validation: Company Verification
  bool validateStep2Data(Map<String, dynamic> data) {
    // Reset error message
    _errorMessage = null;

    // Check required fields
    if (data['rcNumber'] == null || data['rcNumber'].isEmpty) {
      _errorMessage = 'RC Number is required';
      return false;
    }

    if (data['cacCertificate'] == null) {
      _errorMessage = 'CAC Certificate is required';
      return false;
    }

    if (data['businessAddress'] == null || data['businessAddress'].isEmpty) {
      _errorMessage = 'Business address is required';
      return false;
    }

    // Validate RC Number format (simple validation)
    final rcRegex = RegExp(r'^RC[0-9]{4,}$');
    if (!rcRegex.hasMatch(data['rcNumber'])) {
      _errorMessage = 'Please enter a valid RC number (e.g., RC12345)';
      return false;
    }

    // The CAC Certificate file validation would be handled in the UI
    // when selecting the file, checking for proper file types

    return true;
  }

  // Step 3 validation: Subscription Plan
  bool validateStep3Data(Map<String, dynamic> data) {
    // Reset error message
    _errorMessage = null;

    // Check subscription plan is selected
    if (data['subscriptionPlan'] == null || data['subscriptionPlan'].isEmpty) {
      _errorMessage = 'Please select a subscription plan';
      return false;
    }

    // Check payment method is selected
    if (data['paymentMethod'] == null || data['paymentMethod'].isEmpty) {
      _errorMessage = 'Please select a payment method';
      return false;
    }

    return true;
  }

  // Submit data for Step 1
  Future<bool> submitStep1(Map<String, dynamic> data) async {
    if (!validateStep1Data(data)) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, we would validate with an API
      // For the demo, we'll simulate a successful API call
      await Future.delayed(const Duration(seconds: 1));

      // Store the data
      _step1Data.clear();
      _step1Data.addAll(data);

      // Move to the next step
      _currentStep = 2;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Submit data for Step 2
  Future<bool> submitStep2(Map<String, dynamic> data) async {
    if (!validateStep2Data(data)) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, we would validate with an API and upload files
      // For the demo, we'll simulate a successful API call
      await Future.delayed(const Duration(seconds: 1));

      // Store the data
      _step2Data.clear();
      _step2Data.addAll(data);

      // Move to the next step
      _currentStep = 3;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Submit data for Step 3
  Future<bool> submitStep3(Map<String, dynamic> data) async {
    if (!validateStep3Data(data)) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, we would submit to an API and process payment
      // For the demo, we'll simulate a successful API call
      await Future.delayed(const Duration(seconds: 2));

      // Store the data
      _step3Data.clear();
      _step3Data.addAll(data);

      // Prepare complete registration data
      final registrationData = {
        ..._step1Data,
        ..._step2Data,
        ..._step3Data,
        'userType': 'developer',
        'verificationStatus': 'pending',
      };

      // In a real app, we would submit this to the API
      // For demo, we'll just mark registration as complete
      _registrationComplete = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Reset the registration process
  void resetRegistration() {
    _currentStep = 1;
    _step1Data.clear();
    _step2Data.clear();
    _step3Data.clear();
    _errorMessage = null;
    _isLoading = false;
    _registrationComplete = false;
    notifyListeners();
  }

  // Go to a specific step (only if we've already reached that step)
  bool goToStep(int step) {
    if (step <= 0 || step > _totalSteps) {
      return false;
    }

    // Can only go to steps we've already completed or the current step
    if (step > _currentStep) {
      return false;
    }

    _currentStep = step;
    notifyListeners();
    return true;
  }
}
