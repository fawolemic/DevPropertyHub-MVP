import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserRole {
  admin,    // Full access, user management, company settings
  standard, // Manages assigned/created developments & leads
  viewer    // Read-only access to data
}

enum UserType {
  developer, // Property developers (primary users)
  buyer     // Property buyers/investors (secondary users)
}

// Simple user model for the current user
class User {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final UserType userType;
  final UserRole role;
  
  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    required this.userType,
    required this.role,
  });
  
  String get fullName => '$firstName $lastName';
}

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  UserRole _userRole = UserRole.viewer;
  UserType _userType = UserType.developer; // Default to developer for MVP
  String? _userName;
  String? _userEmail;
  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  String? _userId;
  String? _companyName;
  String? _companyId;
  String? _phone;
  String? _verificationStatus;
  List<String> _permissions = [];
  
  final _storage = const FlutterSecureStorage();
  
  // Basic auth getters
  bool get isLoggedIn => _isLoggedIn;
  UserRole get userRole => _userRole;
  UserType get userType => _userType;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get authToken => _authToken;
  String? get userId => _userId;
  String? get companyName => _companyName;
  String? get companyId => _companyId;
  String? get phone => _phone;
  String? get verificationStatus => _verificationStatus;
  List<String> get permissions => _permissions;
  bool get isTokenExpired => _tokenExpiry != null ? DateTime.now().isAfter(_tokenExpiry!) : true;
  
  // Current user getter
  User? get currentUser => _isLoggedIn && _userId != null ? User(
    id: _userId!,
    firstName: _userName?.split(' ').first,
    lastName: _userName != null && _userName!.split(' ').length > 1 ? _userName!.split(' ').last : null,
    email: _userEmail,
    userType: _userType,
    role: _userRole,
  ) : null;
  
  // Role-based permission checks
  bool get isAdmin => _userRole == UserRole.admin;
  bool get isStandard => _userRole == UserRole.standard;
  bool get isViewer => _userRole == UserRole.viewer;
  
  // User type checks
  bool get isDeveloper => _userType == UserType.developer;
  bool get isBuyer => _userType == UserType.buyer;
  
  // Permission checks
  bool get canEdit => _userRole == UserRole.admin || _userRole == UserRole.standard;
  bool get hasAdminPermissions => _userRole == UserRole.admin;
  bool get isVerified => _verificationStatus == 'verified';
  
  // Specific permission checks
  bool hasPermission(String permission) => _permissions.contains(permission);
  
  // Initialize auth state from storage
  Future<void> initAuth() async {
    try {
      final isLoggedInStr = await _storage.read(key: 'isLoggedIn');
      final roleStr = await _storage.read(key: 'userRole');
      final userTypeStr = await _storage.read(key: 'userType');
      final userName = await _storage.read(key: 'userName');
      final userEmail = await _storage.read(key: 'userEmail');
      final authToken = await _storage.read(key: 'authToken');
      final refreshToken = await _storage.read(key: 'refreshToken');
      final tokenExpiryStr = await _storage.read(key: 'tokenExpiry');
      final userId = await _storage.read(key: 'userId');
      final companyName = await _storage.read(key: 'companyName');
      final companyId = await _storage.read(key: 'companyId');
      final phone = await _storage.read(key: 'phone');
      final verificationStatus = await _storage.read(key: 'verificationStatus');
      final permissionsJson = await _storage.read(key: 'permissions');
      
      _isLoggedIn = isLoggedInStr == 'true';
      _userName = userName;
      _userEmail = userEmail;
      _authToken = authToken;
      _refreshToken = refreshToken;
      _userId = userId;
      _companyName = companyName;
      _companyId = companyId;
      _phone = phone;
      _verificationStatus = verificationStatus;
      
      // Parse token expiry
      if (tokenExpiryStr != null) {
        _tokenExpiry = DateTime.parse(tokenExpiryStr);
      }
      
      // Parse permissions
      if (permissionsJson != null) {
        final List<dynamic> permissionsList = jsonDecode(permissionsJson);
        _permissions = permissionsList.cast<String>();
      }
      
      // Set user type based on stored value
      if (userTypeStr != null) {
        _userType = userTypeStr == 'developer' ? UserType.developer : UserType.buyer;
      }
      
      // Set user role based on stored value
      if (roleStr != null) {
        switch (roleStr) {
          case 'admin':
            _userRole = UserRole.admin;
            break;
          case 'standard':
            _userRole = UserRole.standard;
            break;
          case 'viewer':
            _userRole = UserRole.viewer;
            break;
          default:
            _userRole = UserRole.viewer;
        }
      }
      
      // Check if token is expired and try to refresh
      if (_isLoggedIn && isTokenExpired && _refreshToken != null) {
        await refreshAuthToken();
      }
    } catch (e) {
      // Reset auth state if there's an error
      _resetAuthState();
    }
    
    notifyListeners();
  }
  
  void _resetAuthState() {
    _isLoggedIn = false;
    _userRole = UserRole.viewer;
    _userType = UserType.developer;
    _userName = null;
    _userEmail = null;
    _authToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _userId = null;
    _companyName = null;
    _companyId = null;
    _phone = null;
    _verificationStatus = null;
    _permissions = [];
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password, {String userType = 'developer'}) async {
    // In a real app, this would validate credentials with a backend and receive JWT
    // For the demo, we'll simulate successful authentication with JWT structure
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate a token expiration time (1 hour from now)
    final expiresAt = DateTime.now().add(const Duration(hours: 1));
    
    // Demo credentials for different roles with JWT structure
    if (email == 'admin@example.com' && password == 'password') {
      final jwt = {
        'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.admin',
        'refreshToken': 'refresh-token-admin',
        'expires': expiresAt.toIso8601String(),
        'user': {
          'id': 'dev_1234',
          'userType': 'developer',
          'companyName': 'Admin Developers Ltd',
          'companyId': 'comp_1234',
          'contactPerson': 'Admin User',
          'email': 'admin@example.com',
          'phone': '+234-803-123-4567',
          'verificationStatus': 'verified',
          'subscription': 'enterprise',
          'role': 'admin',
          'permissions': ['create_projects', 'manage_leads', 'analytics_access', 'user_management', 'admin_panel']
        }
      };
      await _setUserDataFromJwt(jwt);
      return true;
    } else if (email == 'user@example.com' && password == 'password') {
      final jwt = {
        'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.standard',
        'refreshToken': 'refresh-token-standard',
        'expires': expiresAt.toIso8601String(),
        'user': {
          'id': 'dev_5678',
          'userType': 'developer',
          'companyName': 'Standard Developers Ltd',
          'companyId': 'comp_5678',
          'contactPerson': 'Standard User',
          'email': 'user@example.com',
          'phone': '+234-803-456-7890',
          'verificationStatus': 'verified',
          'subscription': 'premium',
          'role': 'standard',
          'permissions': ['create_projects', 'manage_leads', 'analytics_access']
        }
      };
      await _setUserDataFromJwt(jwt);
      return true;
    } else if (email == 'viewer@example.com' && password == 'password') {
      final jwt = {
        'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.viewer',
        'refreshToken': 'refresh-token-viewer',
        'expires': expiresAt.toIso8601String(),
        'user': {
          'id': 'dev_9012',
          'userType': 'developer',
          'companyName': 'Viewer Company Ltd',
          'companyId': 'comp_9012',
          'contactPerson': 'Viewer User',
          'email': 'viewer@example.com',
          'phone': '+234-803-789-0123',
          'verificationStatus': 'verified',
          'subscription': 'basic',
          'role': 'viewer',
          'permissions': ['view_projects', 'view_leads']
        }
      };
      await _setUserDataFromJwt(jwt);
      return true;
    } else if (email == 'buyer@example.com' && password == 'password') {
      final jwt = {
        'accessToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.buyer',
        'refreshToken': 'refresh-token-buyer',
        'expires': expiresAt.toIso8601String(),
        'user': {
          'id': 'buyer_3456',
          'userType': 'buyer',
          'firstName': 'Ada',
          'lastName': 'Okafor',
          'email': 'buyer@example.com',
          'phone': '+234-901-234-5678',
          'role': 'standard',
          'permissions': ['view_projects', 'send_inquiries', 'save_projects']
        }
      };
      await _setUserDataFromJwt(jwt);
      return true;
    }
    
    return false;
  }
  
  // Set user data from JWT response
  Future<void> _setUserDataFromJwt(Map<String, dynamic> jwt) async {
    final user = jwt['user'];
    final String roleStr = user['role'];
    final String userTypeStr = user['userType'];
    
    // Set token data
    _authToken = jwt['accessToken'];
    _refreshToken = jwt['refreshToken'];
    _tokenExpiry = DateTime.parse(jwt['expires']);
    
    // Set user data
    _isLoggedIn = true;
    _userId = user['id'];
    _userEmail = user['email'];
    
    // Set user type
    _userType = userTypeStr == 'developer' ? UserType.developer : UserType.buyer;
    
    // Set user-type specific data
    if (_userType == UserType.developer) {
      _userName = user['contactPerson'];
      _companyName = user['companyName'];
      _companyId = user['companyId'];
    } else {
      _userName = '${user['firstName']} ${user['lastName']}';
    }
    
    _phone = user['phone'];
    _verificationStatus = user['verificationStatus'];
    
    // Set permissions
    if (user['permissions'] != null) {
      _permissions = List<String>.from(user['permissions']);
    }
    
    // Set user role
    switch (roleStr) {
      case 'admin':
        _userRole = UserRole.admin;
        break;
      case 'standard':
        _userRole = UserRole.standard;
        break;
      case 'viewer':
        _userRole = UserRole.viewer;
        break;
      default:
        _userRole = UserRole.viewer;
    }
    
    // Store auth data securely
    await _storage.write(key: 'isLoggedIn', value: 'true');
    await _storage.write(key: 'userId', value: _userId);
    await _storage.write(key: 'userName', value: _userName);
    await _storage.write(key: 'userEmail', value: _userEmail);
    await _storage.write(key: 'userRole', value: roleStr);
    await _storage.write(key: 'userType', value: userTypeStr);
    await _storage.write(key: 'authToken', value: _authToken);
    await _storage.write(key: 'refreshToken', value: _refreshToken);
    await _storage.write(key: 'tokenExpiry', value: _tokenExpiry!.toIso8601String());
    
    if (_phone != null) {
      await _storage.write(key: 'phone', value: _phone);
    }
    
    if (_verificationStatus != null) {
      await _storage.write(key: 'verificationStatus', value: _verificationStatus);
    }
    
    if (_companyName != null) {
      await _storage.write(key: 'companyName', value: _companyName);
    }
    
    if (_companyId != null) {
      await _storage.write(key: 'companyId', value: _companyId);
    }
    
    if (_permissions.isNotEmpty) {
      await _storage.write(key: 'permissions', value: jsonEncode(_permissions));
    }
    
    notifyListeners();
  }
  
  // Token refresh mechanism
  Future<bool> refreshAuthToken() async {
    try {
      // In a real app, this would call an API endpoint with the refresh token
      // For demo purposes, we'll simulate a successful refresh
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_refreshToken == null) return false;
      
      // Generate new token expiration time (1 hour from now)
      final expiresAt = DateTime.now().add(const Duration(hours: 1));
      
      // Simulate refreshed token
      _authToken = 'refreshed-${_authToken?.split('-').last ?? 'token'}';
      _tokenExpiry = expiresAt;
      
      // Update storage
      await _storage.write(key: 'authToken', value: _authToken);
      await _storage.write(key: 'tokenExpiry', value: _tokenExpiry!.toIso8601String());
      
      notifyListeners();
      return true;
    } catch (e) {
      // If refresh fails, sign out the user
      await signOut();
      return false;
    }
  }

  // Check if the token needs to be refreshed before making an API call
  Future<String?> getValidToken() async {
    if (!_isLoggedIn) return null;
    
    // Check if token is expired or about to expire (within 5 minutes)
    final isAboutToExpire = _tokenExpiry != null && 
        DateTime.now().isAfter(_tokenExpiry!.subtract(const Duration(minutes: 5)));
    
    if (isAboutToExpire) {
      final refreshed = await refreshAuthToken();
      if (!refreshed) return null;
    }
    
    return _authToken;
  }
  
  // Sign out
  Future<void> signOut() async {
    // In a real app, this would also invalidate the refresh token on the server
    _resetAuthState();
    
    // Clear secure storage
    await _storage.deleteAll();
    
    notifyListeners();
  }
}
