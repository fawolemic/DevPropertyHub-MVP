import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/lead_service.dart';
import '../services/property_service.dart';
import '../services/development_service.dart';
import '../services/database_service.dart';

/// Provider for Supabase services
class SupabaseProvider extends ChangeNotifier {
  // Services
  final AuthService _authService = AuthService();
  final LeadService _leadService = LeadService();
  final PropertyService _propertyService = PropertyService();
  final DevelopmentService _developmentService = DevelopmentService();
  final DatabaseService _databaseService = DatabaseService();
  
  // User state
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  // Service getters
  AuthService get authService => _authService;
  LeadService get leadService => _leadService;
  PropertyService get propertyService => _propertyService;
  DevelopmentService get developmentService => _developmentService;
  DatabaseService get databaseService => _databaseService;
  
  /// Initialize the provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Initialize database if needed
      await _databaseService.initializeDatabase();
      
      // Get current user if authenticated
      await _loadCurrentUser();
      
      // Listen for auth state changes
      SupabaseConfig.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        
        if (event == AuthChangeEvent.signedIn) {
          _loadCurrentUser();
        } else if (event == AuthChangeEvent.signedOut) {
          _currentUser = null;
          notifyListeners();
        }
      });
    } catch (e) {
      _setError('Failed to initialize: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Load the current user from Supabase
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user: $e');
    }
  }
  
  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );
      
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign in: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Sign up a new user
  Future<bool> signUp(String email, String password, String fullName, UserRole role) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
      
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign up: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to sign out: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Update user profile
  Future<bool> updateProfile({String? fullName, String? photoUrl}) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final updatedUser = await _authService.updateUserProfile(
        userId: _currentUser!.id,
        fullName: fullName,
        photoUrl: photoUrl,
      );
      
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError('Failed to reset password: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
