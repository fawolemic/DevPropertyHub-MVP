import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Provider for Supabase authentication
class SupabaseAuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  UserModel? _currentUser;
  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  final _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get currentUser => _currentUser;
  String? get authToken => _authToken;
  String? get userId => _currentUser?.id;
  String? get userEmail => _currentUser?.email;
  String? get userName => _currentUser != null
      ? '${_currentUser!.firstName ?? ''} ${_currentUser!.lastName ?? ''}'
          .trim()
      : null;

  // Role-based checks
  bool get isDeveloper => _currentUser?.role == UserRole.developer;
  bool get isBuyer => _currentUser?.role == UserRole.buyer;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isViewer => _currentUser?.role == UserRole.viewer;

  // User profile getters
  String? get firstName => _currentUser?.firstName;
  String? get lastName => _currentUser?.lastName;
  String? get phone => _currentUser?.phone;
  String? get avatarUrl => _currentUser?.avatarUrl;
  String? get companyName => _currentUser?.companyName;
  String? get bio => _currentUser?.bio;
  bool get isVerified => _currentUser?.isVerified ?? false;
  DateTime? get lastLogin => _currentUser?.lastLogin;

  // Initialize auth state from storage and Supabase
  Future<void> initAuth() async {
    try {
      // First check if there's a session in Supabase
      final session = SupabaseConfig.auth.currentSession;

      if (session != null) {
        // We have a valid session
        _authToken = session.accessToken;
        _refreshToken = session.refreshToken;
        _tokenExpiry = session.expiresAt != null
            ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
            : null;

        // Get user data from database
        final user = await _authService.getCurrentUser();
        if (user != null) {
          _currentUser = user;
          _isLoggedIn = true;

          // Save to secure storage
          await _saveAuthData();
        }
      } else {
        // Try to restore from secure storage
        await _restoreAuthData();
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      _resetAuthState();
    }

    notifyListeners();
  }

  // Restore auth data from secure storage
  Future<void> _restoreAuthData() async {
    try {
      final isLoggedInStr = await _storage.read(key: 'isLoggedIn');
      final userJson = await _storage.read(key: 'currentUser');
      final authToken = await _storage.read(key: 'authToken');
      final refreshToken = await _storage.read(key: 'refreshToken');
      final tokenExpiryStr = await _storage.read(key: 'tokenExpiry');

      _isLoggedIn = isLoggedInStr == 'true';
      _authToken = authToken;
      _refreshToken = refreshToken;

      // Parse token expiry
      if (tokenExpiryStr != null) {
        _tokenExpiry = DateTime.parse(tokenExpiryStr);
      }

      // Parse user data
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        _currentUser = UserModel.fromMap(userData);
      }

      // Check if token is expired and try to refresh
      if (_isLoggedIn && _isTokenExpired && _refreshToken != null) {
        await _refreshAuthToken();
      }
    } catch (e) {
      debugPrint('Error restoring auth data: $e');
      _resetAuthState();
    }
  }

  // Save auth data to secure storage
  Future<void> _saveAuthData() async {
    await _storage.write(key: 'isLoggedIn', value: _isLoggedIn.toString());

    if (_currentUser != null) {
      await _storage.write(
          key: 'currentUser', value: jsonEncode(_currentUser!.toMap()));
    }

    if (_authToken != null) {
      await _storage.write(key: 'authToken', value: _authToken);
    }

    if (_refreshToken != null) {
      await _storage.write(key: 'refreshToken', value: _refreshToken);
    }

    if (_tokenExpiry != null) {
      await _storage.write(
          key: 'tokenExpiry', value: _tokenExpiry!.toIso8601String());
    }
  }

  // Reset auth state
  void _resetAuthState() {
    _isLoggedIn = false;
    _currentUser = null;
    _authToken = null;
    _refreshToken = null;
    _tokenExpiry = null;

    // Clear secure storage
    _storage.deleteAll();
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;

        // Get the session
        final session = SupabaseConfig.auth.currentSession;
        if (session != null) {
          _authToken = session.accessToken;
          _refreshToken = session.refreshToken;
          _tokenExpiry = session.expiresAt != null
              ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
              : null;
        }

        // Update last login time
        await _authService.updateLastLogin(user.id);

        await _saveAuthData();
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return false;
    }
  }

  // Check if user has permission to access a resource
  Future<bool> hasPermission(String resource, String action) async {
    if (!_isLoggedIn || _currentUser == null) {
      return false;
    }

    return _authService.hasPermission(_currentUser!.id, resource, action);
  }

  // Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    required UserRole role,
    String? phone,
    String? companyName,
  }) async {
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        phone: phone,
        companyName: companyName,
      );

      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;

        // Get the session
        final session = SupabaseConfig.auth.currentSession;
        if (session != null) {
          _authToken = session.accessToken;
          _refreshToken = session.refreshToken;
          _tokenExpiry = session.expiresAt != null
              ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
              : null;
        }

        // Update last login time
        await _authService.updateLastLogin(user.id);

        await _saveAuthData();
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error signing up: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _resetAuthState();
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // Check if user is the owner of a resource
  Future<bool> isResourceOwner(String resourceType, String resourceId) async {
    if (!_isLoggedIn || _currentUser == null) {
      return false;
    }

    try {
      final client = SupabaseConfig.client;
      final data = await client
          .from(resourceType)
          .select('developer_id')
          .eq('id', resourceId)
          .single();

      return data['developer_id'] == _currentUser!.id;
    } catch (e) {
      debugPrint('Error checking resource ownership: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? companyName,
    String? bio,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? profileData,
  }) async {
    if (!_isLoggedIn || _currentUser == null) {
      return false;
    }

    try {
      final updatedUser = await _authService.updateUserProfile(
        userId: _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        avatarUrl: avatarUrl,
        companyName: companyName,
        bio: bio,
        preferences: preferences,
        profileData: profileData,
      );

      _currentUser = updatedUser;
      await _saveAuthData();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // Refresh auth token
  Future<bool> _refreshAuthToken() async {
    try {
      // Supabase handles token refresh automatically, but we can force it
      final response = await SupabaseConfig.auth.refreshSession();

      if (response.session != null) {
        _authToken = response.session!.accessToken;
        _refreshToken = response.session!.refreshToken;
        _tokenExpiry = response.session!.expiresAt != null
            ? DateTime.fromMillisecondsSinceEpoch(
                response.session!.expiresAt! * 1000)
            : null;

        await _saveAuthData();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      _resetAuthState();
      notifyListeners();
      return false;
    }
  }

  // Check if token is expired
  bool get _isTokenExpired {
    if (_tokenExpiry == null) return true;
    return DateTime.now().isAfter(_tokenExpiry!);
  }

  // Get a valid token (refresh if needed)
  Future<String?> getValidToken() async {
    if (_isTokenExpired && _refreshToken != null) {
      final success = await _refreshAuthToken();
      if (!success) return null;
    }

    return _authToken;
  }

  // Update user profile with simplified parameters
  Future<bool> updateProfileSimple({String? fullName, String? photoUrl}) async {
    if (_currentUser == null) return false;

    try {
      // Check what parameters the service accepts
      final updatedUser = await _authService.updateUserProfile(
        userId: _currentUser!.id,
        firstName: fullName != null ? fullName.split(' ').first : null,
        lastName: fullName != null && fullName.split(' ').length > 1
            ? fullName.split(' ').last
            : null,
        // Remove photoUrl parameter if it's not accepted
      );

      _currentUser = updatedUser;
      await _saveAuthData();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      debugPrint('Error resetting password: $e');
      return false;
    }
  }
}
