import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/user_model.dart';
import '../providers/supabase_auth_provider.dart';
import 'audit_service.dart';

/// Service for handling Role-Based Access Control (RBAC)
class RBACService {
  final SupabaseClient _client = SupabaseConfig.client;
  final AuditService _auditService = AuditService();
  final SupabaseAuthProvider _authProvider;

  // Cache for permissions to reduce database calls
  final Map<String, Map<String, bool>> _permissionsCache = {};
  final Duration _cacheDuration = const Duration(minutes: 15);
  final Map<String, DateTime> _cacheTimestamps = {};

  RBACService(this._authProvider);

  /// Check if the current user has a specific role
  bool hasRole(UserRole role) {
    switch (role) {
      case UserRole.developer:
        return _authProvider.isDeveloper;
      case UserRole.buyer:
        return _authProvider.isBuyer;
      case UserRole.admin:
        return _authProvider.isAdmin;
      case UserRole.viewer:
        return _authProvider.isViewer;
      default:
        return false;
    }
  }

  /// Check if the current user has permission to perform an action on a resource
  /// Uses caching to reduce database calls
  Future<bool> hasPermission(String resource, String action) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return false;

    final cacheKey = '$userId:$resource:$action';

    // Check cache first
    if (_permissionsCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheDuration) {
        return _permissionsCache[cacheKey]?[action] ?? false;
      }
    }

    // If not in cache or cache expired, check with auth provider
    final hasPermission = await _authProvider.hasPermission(resource, action);

    // Update cache
    _permissionsCache[cacheKey] = {action: hasPermission};
    _cacheTimestamps[cacheKey] = DateTime.now();

    return hasPermission;
  }

  /// Check if the current user is the owner of a resource
  Future<bool> isResourceOwner(String resourceType, String resourceId) async {
    return _authProvider.isResourceOwner(resourceType, resourceId);
  }

  /// Check if the current user can create a resource
  Future<bool> canCreate(String resource) async {
    return _authProvider.hasPermission(resource, 'create');
  }

  /// Check if the current user can read a resource
  Future<bool> canRead(String resource) async {
    return _authProvider.hasPermission(resource, 'read');
  }

  /// Check if the current user can update a resource
  /// Implements explicit deny rules and audit logging
  Future<bool> canUpdate(String resource, String resourceId) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return false;

    // Explicit deny for viewers - they can never update
    if (_authProvider.isViewer) {
      await _logDeniedAccess(userId, resource, resourceId, 'update',
          'Viewers cannot update resources');
      return false;
    }

    // Explicit deny for buyers - they can never update properties or developments
    if (_authProvider.isBuyer &&
        (resource == 'properties' || resource == 'developments')) {
      await _logDeniedAccess(userId, resource, resourceId, 'update',
          'Buyers cannot update properties or developments');
      return false;
    }

    // First check if user has general update permission
    final hasUpdatePermission =
        await _authProvider.hasPermission(resource, 'update');

    // If not, check if they're the owner (developers can update their own resources)
    if (!hasUpdatePermission && _authProvider.isDeveloper) {
      final isOwner = await _authProvider.isResourceOwner(resource, resourceId);

      // Log the access attempt
      if (isOwner) {
        await _logPermittedAccess(
            userId, resource, resourceId, 'update', 'Developer owns resource');
      } else {
        await _logDeniedAccess(userId, resource, resourceId, 'update',
            'Developer does not own resource');
      }

      return isOwner;
    }

    // Log the access attempt
    if (hasUpdatePermission) {
      await _logPermittedAccess(
          userId, resource, resourceId, 'update', 'User has update permission');
    } else {
      await _logDeniedAccess(userId, resource, resourceId, 'update',
          'User lacks update permission');
    }

    return hasUpdatePermission;
  }

  /// Check if the current user can delete a resource
  /// Implements explicit deny rules and audit logging
  Future<bool> canDelete(String resource, String resourceId) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return false;

    // Explicit deny for viewers - they can never delete
    if (_authProvider.isViewer) {
      await _logDeniedAccess(userId, resource, resourceId, 'delete',
          'Viewers cannot delete resources');
      return false;
    }

    // Explicit deny for buyers - they can never delete properties or developments
    if (_authProvider.isBuyer &&
        (resource == 'properties' || resource == 'developments')) {
      await _logDeniedAccess(userId, resource, resourceId, 'delete',
          'Buyers cannot delete properties or developments');
      return false;
    }

    // First check if user has general delete permission
    final hasDeletePermission =
        await _authProvider.hasPermission(resource, 'delete');

    // If not, check if they're the owner (developers can delete their own resources)
    if (!hasDeletePermission && _authProvider.isDeveloper) {
      final isOwner = await _authProvider.isResourceOwner(resource, resourceId);

      // Log the access attempt
      if (isOwner) {
        await _logPermittedAccess(
            userId, resource, resourceId, 'delete', 'Developer owns resource');
      } else {
        await _logDeniedAccess(userId, resource, resourceId, 'delete',
            'Developer does not own resource');
      }

      return isOwner;
    }

    // Log the access attempt
    if (hasDeletePermission) {
      await _logPermittedAccess(
          userId, resource, resourceId, 'delete', 'User has delete permission');
    } else {
      await _logDeniedAccess(userId, resource, resourceId, 'delete',
          'User lacks delete permission');
    }

    return hasDeletePermission;
  }

  /// Log permitted access to audit logs
  Future<void> _logPermittedAccess(String userId, String resource,
      String resourceId, String action, String reason) async {
    try {
      await _auditService.logAction(
        userId: userId,
        resource: resource,
        resourceId: resourceId,
        action: action,
        details: {
          'permitted': true,
          'reason': reason,
        },
      );
    } catch (e) {
      debugPrint('Error logging permitted access: $e');
    }
  }

  /// Log denied access to audit logs
  Future<void> _logDeniedAccess(String userId, String resource,
      String resourceId, String action, String reason) async {
    try {
      await _auditService.logAction(
        userId: userId,
        resource: resource,
        resourceId: resourceId,
        action: action,
        details: {
          'permitted': false,
          'reason': reason,
        },
      );
    } catch (e) {
      debugPrint('Error logging denied access: $e');
    }
  }
}
