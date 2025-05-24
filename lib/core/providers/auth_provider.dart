import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserRole {
  admin,    // Full access, user management, company settings
  standard, // Manages assigned/created developments & leads
  viewer    // Read-only access to data
}

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  UserRole _userRole = UserRole.viewer;
  String? _userName;
  String? _userEmail;
  String? _authToken;
  
  final _storage = const FlutterSecureStorage();
  
  bool get isLoggedIn => _isLoggedIn;
  UserRole get userRole => _userRole;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get authToken => _authToken;
  
  // Role-based permission checks
  bool get isAdmin => _userRole == UserRole.admin;
  bool get isStandard => _userRole == UserRole.standard;
  bool get isViewer => _userRole == UserRole.viewer;
  
  // Check if user has edit permissions (Admin or Standard)
  bool get canEdit => _userRole == UserRole.admin || _userRole == UserRole.standard;
  
  // Check if user has admin-only permissions
  bool get hasAdminPermissions => _userRole == UserRole.admin;
  
  // Initialize auth state from storage
  Future<void> initAuth() async {
    try {
      final isLoggedInStr = await _storage.read(key: 'isLoggedIn');
      final roleStr = await _storage.read(key: 'userRole');
      final userName = await _storage.read(key: 'userName');
      final userEmail = await _storage.read(key: 'userEmail');
      final authToken = await _storage.read(key: 'authToken');
      
      _isLoggedIn = isLoggedInStr == 'true';
      _userName = userName;
      _userEmail = userEmail;
      _authToken = authToken;
      
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
    } catch (e) {
      // Reset auth state if there's an error
      _isLoggedIn = false;
      _userRole = UserRole.viewer;
    }
    
    notifyListeners();
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    // In a real app, this would validate credentials with a backend
    // For the demo, we'll simulate successful authentication
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Demo credentials for different roles
    if (email == 'admin@example.com' && password == 'password') {
      await _setUserData('Admin User', email, UserRole.admin, 'demo-token-admin');
      return true;
    } else if (email == 'user@example.com' && password == 'password') {
      await _setUserData('Standard User', email, UserRole.standard, 'demo-token-standard');
      return true;
    } else if (email == 'viewer@example.com' && password == 'password') {
      await _setUserData('Viewer User', email, UserRole.viewer, 'demo-token-viewer');
      return true;
    }
    
    return false;
  }
  
  // Set user data after successful authentication
  Future<void> _setUserData(String name, String email, UserRole role, String token) async {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _userRole = role;
    _authToken = token;
    
    // Store auth data securely
    await _storage.write(key: 'isLoggedIn', value: 'true');
    await _storage.write(key: 'userName', value: name);
    await _storage.write(key: 'userEmail', value: email);
    await _storage.write(key: 'userRole', value: role.toString().split('.').last);
    await _storage.write(key: 'authToken', value: token);
    
    notifyListeners();
  }
  
  // Sign out
  Future<void> signOut() async {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _authToken = null;
    _userRole = UserRole.viewer;
    
    // Clear secure storage
    await _storage.deleteAll();
    
    notifyListeners();
  }
}
