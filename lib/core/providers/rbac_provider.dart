import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../services/rbac_service.dart';
import 'supabase_auth_provider.dart';

/// Provider for Role-Based Access Control (RBAC)
class RBACProvider with ChangeNotifier {
  final RBACService _rbacService;

  RBACProvider(SupabaseAuthProvider authProvider)
      : _rbacService = RBACService(authProvider);

  /// Check if the current user has a specific role
  bool hasRole(UserRole role) {
    return _rbacService.hasRole(role);
  }

  /// Check if the current user has permission to perform an action on a resource
  Future<bool> hasPermission(String resource, String action) async {
    return _rbacService.hasPermission(resource, action);
  }

  /// Check if the current user is the owner of a resource
  Future<bool> isResourceOwner(String resourceType, String resourceId) async {
    return _rbacService.isResourceOwner(resourceType, resourceId);
  }

  /// Check if the current user can create a resource
  Future<bool> canCreate(String resource) async {
    return _rbacService.canCreate(resource);
  }

  /// Check if the current user can read a resource
  Future<bool> canRead(String resource) async {
    return _rbacService.canRead(resource);
  }

  /// Check if the current user can update a resource
  Future<bool> canUpdate(String resource, String resourceId) async {
    return _rbacService.canUpdate(resource, resourceId);
  }

  /// Check if the current user can delete a resource
  Future<bool> canDelete(String resource, String resourceId) async {
    return _rbacService.canDelete(resource, resourceId);
  }

  /// Static method to get the RBAC provider from the context
  static RBACProvider of(BuildContext context) {
    return Provider.of<RBACProvider>(context, listen: false);
  }
}
