import '../models/user_model.dart';
import '../providers/supabase_auth_provider.dart';

/// Service for handling Role-Based Access Control (RBAC)
class RBACService {
  final SupabaseAuthProvider _authProvider;

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
  Future<bool> hasPermission(String resource, String action) async {
    return _authProvider.hasPermission(resource, action);
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
  Future<bool> canUpdate(String resource, String resourceId) async {
    // First check if user has general update permission
    final hasUpdatePermission = await _authProvider.hasPermission(resource, 'update');
    
    // If not, check if they're the owner (developers can update their own resources)
    if (!hasUpdatePermission && _authProvider.isDeveloper) {
      return _authProvider.isResourceOwner(resource, resourceId);
    }
    
    return hasUpdatePermission;
  }

  /// Check if the current user can delete a resource
  Future<bool> canDelete(String resource, String resourceId) async {
    // First check if user has general delete permission
    final hasDeletePermission = await _authProvider.hasPermission(resource, 'delete');
    
    // If not, check if they're the owner (developers can delete their own resources)
    if (!hasDeletePermission && _authProvider.isDeveloper) {
      return _authProvider.isResourceOwner(resource, resourceId);
    }
    
    return hasDeletePermission;
  }
}
