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
    required String fullName,
    required UserRole role,
  }) async {
    try {
      // Create the user in Supabase Auth
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': UserModel.roleToString(role),
        },
      );

      if (response.user == null) {
        throw Exception('Failed to create user');
      }

      // Create a user record in the users table
      final userData = {
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'role': UserModel.roleToString(role),
        'is_email_verified': false,
        'created_at': DateTime.now().toIso8601String(),
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
    String? fullName,
    String? photoUrl,
    Map<String, dynamic>? metadata,
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
        'full_name': fullName ?? user.fullName,
        'photo_url': photoUrl ?? user.photoUrl,
        'metadata': metadata ?? user.metadata,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Update the user in the users table
      await _client
          .from('users')
          .update(updatedData)
          .eq('id', userId);

      // Return the updated user
      return user.copyWith(
        fullName: fullName,
        photoUrl: photoUrl,
        metadata: metadata,
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
}
