import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/user_model.dart';

/// Service for handling authentication with Supabase
class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;
  final GoTrueClient _auth = SupabaseConfig.auth;

  /// Sign up a new user
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    required UserRole role,
    String? phone,
    String? companyName,
  }) async {
    try {
      // Create the user in Supabase Auth
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'user_type': UserModel.roleToString(role),
        },
      );

      if (response.user == null) {
        throw Exception('Failed to create user');
      }

      // Create a user record in the users table
      final userData = {
        'id': response.user!.id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'company_name': companyName,
        'user_type': UserModel.roleToString(role),
        'is_verified': false,
        'last_login': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'preferences': {},
        'profile_data': {},
      };

      await _client.from('users').insert(userData);

      // Return the created user
      return UserModel.fromMap(userData);
    } catch (e) {
      debugPrint('Error signing up: $e');
      rethrow;
    }
  }

  /// Sign in a user with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to sign in');
      }

      // Get the user data from the users table
      final userData = await _client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromMap(userData);
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  /// Get the current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      // Get the user data from the users table
      final userData = await _client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromMap(userData);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Error resetting password: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? companyName,
    String? bio,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? profileData,
  }) async {
    try {
      // Get the current user data
      final userData = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final user = UserModel.fromMap(userData);

      // Update the user data
      final updatedData = {
        'first_name': firstName ?? user.firstName,
        'last_name': lastName ?? user.lastName,
        'phone': phone ?? user.phone,
        'avatar_url': avatarUrl ?? user.avatarUrl,
        'company_name': companyName ?? user.companyName,
        'bio': bio ?? user.bio,
        'preferences': preferences ?? user.preferences,
        'profile_data': profileData ?? user.profileData,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Update the user in the users table
      await _client
          .from('users')
          .update(updatedData)
          .eq('id', userId);

      // Return the updated user
      return user.copyWith(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        avatarUrl: avatarUrl,
        companyName: companyName,
        bio: bio,
        preferences: preferences,
        profileData: profileData,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
  
  /// Update user's last login time
  Future<void> updateLastLogin(String userId) async {
    try {
      await _client
          .from('users')
          .update({
            'last_login': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      debugPrint('Error updating last login: $e');
    }
  }
  
  /// Check if user has a specific role
  Future<bool> hasRole(String userId, UserRole role) async {
    try {
      final userData = await _client
          .from('users')
          .select('user_type')
          .eq('id', userId)
          .single();
      
      final userRole = UserModel.stringToRole(userData['user_type']);
      return userRole == role;
    } catch (e) {
      debugPrint('Error checking user role: $e');
      return false;
    }
  }
  
  /// Check if user has permission to access a resource
  Future<bool> hasPermission(String userId, String resource, String action) async {
    try {
      final userData = await _client
          .from('users')
          .select('user_type')
          .eq('id', userId)
          .single();
      
      final userRole = UserModel.stringToRole(userData['user_type']);
      
      // Define role-based permissions
      switch (resource) {
        case 'properties':
          switch (action) {
            case 'create':
            case 'update':
            case 'delete':
              return userRole == UserRole.developer || userRole == UserRole.admin;
            case 'read':
              return true; // All authenticated users can read properties
            default:
              return false;
          }
          
        case 'leads':
          switch (action) {
            case 'create':
            case 'read':
            case 'update':
            case 'delete':
              // Only developers who own the leads or admins can manage leads
              return userRole == UserRole.developer || userRole == UserRole.admin;
            default:
              return false;
          }
          
        case 'developments':
          switch (action) {
            case 'create':
            case 'update':
            case 'delete':
              return userRole == UserRole.developer || userRole == UserRole.admin;
            case 'read':
              return true; // All authenticated users can read developments
            default:
              return false;
          }
          
        case 'users':
          switch (action) {
            case 'read':
            case 'update':
              // Users can read and update their own profiles
              return true;
            case 'read_all':
            case 'update_all':
            case 'delete':
              // Only admins can manage all users
              return userRole == UserRole.admin;
            default:
              return false;
          }
          
        default:
          return false;
      }
    } catch (e) {
      debugPrint('Error checking user permission: $e');
      return false;
    }
  }
}
