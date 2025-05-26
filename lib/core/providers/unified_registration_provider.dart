import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum UserType {
  developer,
  buyer,
  agent,
}

class UnifiedRegistrationProvider with ChangeNotifier {
  // Current step in the registration process
  int _currentStep = 0;
  int get currentStep => _currentStep;
  
  // Maximum number of steps in the registration process
  final int _totalSteps = 3;
  int get totalSteps => _totalSteps;

  // Selected user type
  UserType? _userType;
  UserType? get userType => _userType;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Registration data for each step
  final Map<String, dynamic> _step1Data = {}; // User Type Selection
  final Map<String, dynamic> _step2Data = {}; // Basic Information
  final Map<String, dynamic> _step3Data = {}; // Role-Specific Information
  
  // Getters for step data
  Map<String, dynamic> get step1Data => Map.unmodifiable(_step1Data);
  Map<String, dynamic> get step2Data => Map.unmodifiable(_step2Data);
  Map<String, dynamic> get step3Data => Map.unmodifiable(_step3Data);

  // Set user type
  void setUserType(UserType type) {
    _userType = type;
    _step1Data['userType'] = type.toString().split('.').last;
    notifyListeners();
  }

  // Move to next step, returning true if successful and can proceed
  bool nextStep(Map<String, dynamic> currentStepData) {
    _errorMessage = null;
    
    // Validate current step data
    bool isValid = false;
    switch (_currentStep) {
      case 0: // User type selection
        _step1Data.clear();
        _step1Data.addAll(currentStepData);
        isValid = validateStep1Data();
        break;
      case 1: // Basic information
        _step2Data.clear();
        _step2Data.addAll(currentStepData);
        isValid = validateStep2Data();
        break;
      case 2: // Role-specific information
        _step3Data.clear();
        _step3Data.addAll(currentStepData);
        isValid = validateStep3Data();
        break;
    }

    if (isValid) {
      // Move to next step
      _currentStep++;
      notifyListeners();
      return true;
    } else {
      notifyListeners(); // Notify to display error message
      return false;
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void reset() {
    _currentStep = 0;
    _userType = null;
    _isLoading = false;
    _errorMessage = null;
    _step1Data.clear();
    _step2Data.clear();
    _step3Data.clear();
    notifyListeners();
  }
  
  // Validation methods
  bool validateStep1Data() {
    // Check if user type is selected
    if (_userType == null) {
      _errorMessage = 'Please select a user type';
      return false;
    }
    
    // For agent, validate invitation code
    if (_userType == UserType.agent && 
        (!_step1Data.containsKey('invitationCode') ||
         _step1Data['invitationCode'].toString().trim().isEmpty)) {
      _errorMessage = 'Please enter a valid invitation code';
      return false;
    }
    
    return true;
  }
  
  bool validateStep2Data() {
    // Check required fields
    final requiredFields = ['fullName', 'email', 'phone', 'password', 'confirmPassword'];
    
    for (final field in requiredFields) {
      if (!_step2Data.containsKey(field) || _step2Data[field].toString().trim().isEmpty) {
        _errorMessage = 'Please fill in all required fields';
        return false;
      }
    }
    
    // Check passwords match
    if (_step2Data['password'] != _step2Data['confirmPassword']) {
      _errorMessage = 'Passwords do not match';
      return false;
    }
    
    // Check terms accepted
    if (!_step2Data.containsKey('acceptTerms') || _step2Data['acceptTerms'] != true) {
      _errorMessage = 'You must accept the terms and conditions';
      return false;
    }
    
    return true;
  }
  
  bool validateStep3Data() {
    // Different validation based on user type
    switch (_userType) {
      case UserType.developer:
        return validateDeveloperData();
      case UserType.buyer:
        return validateBuyerData();
      case UserType.agent:
        return validateAgentData();
      default:
        _errorMessage = 'Invalid user type';
        return false;
    }
  }
  
  bool validateDeveloperData() {
    // Check required fields for developers
    final requiredFields = ['companyName', 'businessAddress', 'rcNumber', 'yearsInBusiness'];
    
    for (final field in requiredFields) {
      if (!_step3Data.containsKey(field) || _step3Data[field].toString().trim().isEmpty) {
        _errorMessage = 'Please fill in all required fields';
        return false;
      }
    }
    
    // Check CAC certificate upload - check both possible flags for maximum compatibility
    bool hasUploadedCertificate = _step3Data['hasUploadedCertificate'] == true;
    bool hasCacPath = _step3Data.containsKey('cacCertificatePath') && 
                     _step3Data['cacCertificatePath'] != null && 
                     _step3Data['cacCertificatePath'].toString().isNotEmpty;
    
    if (!hasUploadedCertificate && !hasCacPath) {
      _errorMessage = 'Please upload your CAC certificate';
      debugPrint('CAC certificate validation failed: hasUploadedCertificate=$hasUploadedCertificate, hasCacPath=$hasCacPath');
      debugPrint('Current step3Data: $_step3Data');
      return false;
    }
    
    return true;
  }
  
  bool validateBuyerData() {
    // Check required fields for buyers
    if (!_step3Data.containsKey('propertyTypes') || 
        (_step3Data['propertyTypes'] as List<dynamic>).isEmpty) {
      _errorMessage = 'Please select at least one property type';
      return false;
    }
    
    if (!_step3Data.containsKey('preferredLocations') || 
        (_step3Data['preferredLocations'] as List<dynamic>).isEmpty) {
      _errorMessage = 'Please select at least one preferred location';
      return false;
    }
    
    if (!_step3Data.containsKey('budgetRange') || 
        _step3Data['budgetRange'].toString().trim().isEmpty) {
      _errorMessage = 'Please select a budget range';
      return false;
    }
    
    return true;
  }
  
  bool validateAgentData() {
    // Check required fields for agents
    final requiredFields = ['invitationCode', 'licenseNumber', 'yearsOfExperience'];
    
    for (final field in requiredFields) {
      if (!_step3Data.containsKey(field) || _step3Data[field].toString().trim().isEmpty) {
        _errorMessage = 'Please fill in all required fields';
        return false;
      }
    }
    
    // Check specializations
    if (!_step3Data.containsKey('specializations') || 
        (_step3Data['specializations'] as List<dynamic>).isEmpty) {
      _errorMessage = 'Please select at least one specialization area';
      return false;
    }
    
    // Check license document upload - check both possible flags for maximum compatibility
    bool hasUploadedLicense = _step3Data['hasUploadedLicenseDocument'] == true;
    bool hasLicensePath = _step3Data.containsKey('licenseDocumentPath') && 
                        _step3Data['licenseDocumentPath'] != null && 
                        _step3Data['licenseDocumentPath'].toString().isNotEmpty;
    
    if (!hasUploadedLicense && !hasLicensePath) {
      _errorMessage = 'Please upload your license document';
      debugPrint('License document validation failed: hasUploadedLicense=$hasUploadedLicense, hasLicensePath=$hasLicensePath');
      debugPrint('Current step3Data: $_step3Data');
      return false;
    }
    
    return true;
  }

  // Method to set CAC certificate upload state
  void setCacCertificateUploaded(String? filePath) {
    _step3Data['cacCertificatePath'] = filePath;
    _step3Data['hasUploadedCertificate'] = filePath != null && filePath.isNotEmpty;
    notifyListeners();
  }

  // Method to set license document upload state for agents
  void setLicenseDocumentUploaded(String? filePath) {
    _step3Data['licenseDocumentPath'] = filePath;
    _step3Data['hasUploadedLicenseDocument'] = filePath != null && filePath.isNotEmpty;
    notifyListeners();
  }
  
  // Submit registration to backend
  Future<void> submitRegistration() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // In MVP, we'll simulate API call
      // TODO: Replace with actual API integration
      await Future.delayed(const Duration(seconds: 2));

      // Prepare consolidated data
      final Map<String, dynamic> registrationData = {
        'userType': _userType.toString().split('.').last,
        ..._step1Data,
        ..._step2Data,
        ..._step3Data,
      };
      
      // Log data (for development purposes)
      debugPrint('Registration data: $registrationData');
      
      // In actual implementation, send data to backend:
      // final response = await http.post(
      //   Uri.parse('https://api.devpropertyhub.com/register'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(registrationData),
      // );
      // 
      // if (response.statusCode != 200) {
      //   throw Exception('Failed to register: ${response.body}');
      // }

      // Registration successful - move to final step
      _currentStep = 3;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // This reset method is already defined earlier, removing duplicate
}
