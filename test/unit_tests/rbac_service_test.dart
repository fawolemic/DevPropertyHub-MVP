import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:devpropertyhub/core/services/rbac_service.dart';
import 'package:devpropertyhub/core/providers/supabase_auth_provider.dart';
import 'package:devpropertyhub/core/models/user_model.dart';

// Generate mocks for the dependencies
@GenerateMocks([SupabaseAuthProvider])
import 'rbac_service_test.mocks.dart';

void main() {
  late RBACService rbacService;
  late MockSupabaseAuthProvider mockAuthProvider;
  
  setUp(() {
    mockAuthProvider = MockSupabaseAuthProvider();
    rbacService = RBACService(mockAuthProvider);
  });
  
  group('RBAC Service Tests', () {
    test('hasRole returns correct values based on user role', () {
      // Test admin role
      when(mockAuthProvider.isAdmin).thenReturn(true);
      when(mockAuthProvider.isDeveloper).thenReturn(false);
      when(mockAuthProvider.isBuyer).thenReturn(false);
      when(mockAuthProvider.isViewer).thenReturn(false);
      
      expect(rbacService.hasRole(UserRole.admin), true);
      expect(rbacService.hasRole(UserRole.developer), false);
      expect(rbacService.hasRole(UserRole.buyer), false);
      expect(rbacService.hasRole(UserRole.viewer), false);
      
      // Test developer role
      when(mockAuthProvider.isAdmin).thenReturn(false);
      when(mockAuthProvider.isDeveloper).thenReturn(true);
      when(mockAuthProvider.isBuyer).thenReturn(false);
      when(mockAuthProvider.isViewer).thenReturn(false);
      
      expect(rbacService.hasRole(UserRole.admin), false);
      expect(rbacService.hasRole(UserRole.developer), true);
      expect(rbacService.hasRole(UserRole.buyer), false);
      expect(rbacService.hasRole(UserRole.viewer), false);
    });
    
    test('hasPermission uses caching correctly', () async {
      final testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        role: UserRole.developer,
      );
      
      when(mockAuthProvider.currentUser).thenReturn(testUser);
      when(mockAuthProvider.hasPermission('properties', 'read')).thenAnswer((_) async => true);
      
      // First call should hit the database
      final firstResult = await rbacService.hasPermission('properties', 'read');
      expect(firstResult, true);
      verify(mockAuthProvider.hasPermission('properties', 'read')).called(1);
      
      // Second call should use cache
      final secondResult = await rbacService.hasPermission('properties', 'read');
      expect(secondResult, true);
      verifyNever(mockAuthProvider.hasPermission('properties', 'read')); // Should not be called again
    });
    
    test('canUpdate enforces explicit deny rules for viewers', () async {
      final testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        role: UserRole.viewer,
      );
      
      when(mockAuthProvider.currentUser).thenReturn(testUser);
      when(mockAuthProvider.isViewer).thenReturn(true);
      
      // Viewer should never be able to update
      final result = await rbacService.canUpdate('properties', 'prop-123');
      expect(result, false);
      
      // Verify that we didn't even check permissions
      verifyNever(mockAuthProvider.hasPermission(any, any));
    });
    
    test('canUpdate enforces explicit deny rules for buyers on properties', () async {
      final testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        role: UserRole.buyer,
      );
      
      when(mockAuthProvider.currentUser).thenReturn(testUser);
      when(mockAuthProvider.isViewer).thenReturn(false);
      when(mockAuthProvider.isBuyer).thenReturn(true);
      
      // Buyer should never be able to update properties
      final result = await rbacService.canUpdate('properties', 'prop-123');
      expect(result, false);
      
      // Verify that we didn't even check permissions
      verifyNever(mockAuthProvider.hasPermission(any, any));
    });
    
    test('canUpdate allows developers to update their own resources', () async {
      final testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        role: UserRole.developer,
      );
      
      when(mockAuthProvider.currentUser).thenReturn(testUser);
      when(mockAuthProvider.isViewer).thenReturn(false);
      when(mockAuthProvider.isBuyer).thenReturn(false);
      when(mockAuthProvider.isDeveloper).thenReturn(true);
      when(mockAuthProvider.hasPermission('properties', 'update')).thenAnswer((_) async => false);
      when(mockAuthProvider.isResourceOwner('properties', 'prop-123')).thenAnswer((_) async => true);
      
      // Developer should be able to update their own properties
      final result = await rbacService.canUpdate('properties', 'prop-123');
      expect(result, true);
      
      // Verify that we checked ownership
      verify(mockAuthProvider.isResourceOwner('properties', 'prop-123')).called(1);
    });
    
    test('canDelete enforces explicit deny rules for viewers', () async {
      final testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        role: UserRole.viewer,
      );
      
      when(mockAuthProvider.currentUser).thenReturn(testUser);
      when(mockAuthProvider.isViewer).thenReturn(true);
      
      // Viewer should never be able to delete
      final result = await rbacService.canDelete('properties', 'prop-123');
      expect(result, false);
      
      // Verify that we didn't even check permissions
      verifyNever(mockAuthProvider.hasPermission(any, any));
    });
    
    test('canDelete allows admins to delete any resource', () async {
      final testUser = UserModel(
        id: 'test-user-id',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        role: UserRole.admin,
      );
      
      when(mockAuthProvider.currentUser).thenReturn(testUser);
      when(mockAuthProvider.isViewer).thenReturn(false);
      when(mockAuthProvider.isBuyer).thenReturn(false);
      when(mockAuthProvider.isDeveloper).thenReturn(false);
      when(mockAuthProvider.isAdmin).thenReturn(true);
      when(mockAuthProvider.hasPermission('properties', 'delete')).thenAnswer((_) async => true);
      
      // Admin should be able to delete any property
      final result = await rbacService.canDelete('properties', 'prop-123');
      expect(result, true);
      
      // Verify that we checked permissions but not ownership
      verify(mockAuthProvider.hasPermission('properties', 'delete')).called(1);
      verifyNever(mockAuthProvider.isResourceOwner(any, any));
    });
    
    test('isResourceOwner delegates to auth provider', () async {
      when(mockAuthProvider.isResourceOwner('properties', 'prop-123')).thenAnswer((_) async => true);
      
      final result = await rbacService.isResourceOwner('properties', 'prop-123');
      expect(result, true);
      
      verify(mockAuthProvider.isResourceOwner('properties', 'prop-123')).called(1);
    });
  });
}
