import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:devpropertyhub/core/providers/rbac_provider.dart';
import 'package:devpropertyhub/core/providers/supabase_auth_provider.dart';
import 'package:devpropertyhub/core/models/user_model.dart';

// Generate mocks for the dependencies
@GenerateMocks([SupabaseAuthProvider])
import 'rbac_provider_test.mocks.dart';

void main() {
  late RBACProvider rbacProvider;
  late MockSupabaseAuthProvider mockAuthProvider;
  
  setUp(() {
    mockAuthProvider = MockSupabaseAuthProvider();
    rbacProvider = RBACProvider(mockAuthProvider);
  });
  
  group('RBAC Provider Tests', () {
    test('hasRole correctly identifies user roles', () {
      // Test developer role
      when(mockAuthProvider.isDeveloper).thenReturn(true);
      when(mockAuthProvider.isBuyer).thenReturn(false);
      when(mockAuthProvider.isAdmin).thenReturn(false);
      when(mockAuthProvider.isViewer).thenReturn(false);
      
      expect(rbacProvider.hasRole(UserRole.developer), true);
      expect(rbacProvider.hasRole(UserRole.buyer), false);
      expect(rbacProvider.hasRole(UserRole.admin), false);
      expect(rbacProvider.hasRole(UserRole.viewer), false);
      
      // Test buyer role
      when(mockAuthProvider.isDeveloper).thenReturn(false);
      when(mockAuthProvider.isBuyer).thenReturn(true);
      when(mockAuthProvider.isAdmin).thenReturn(false);
      when(mockAuthProvider.isViewer).thenReturn(false);
      
      expect(rbacProvider.hasRole(UserRole.developer), false);
      expect(rbacProvider.hasRole(UserRole.buyer), true);
      expect(rbacProvider.hasRole(UserRole.admin), false);
      expect(rbacProvider.hasRole(UserRole.viewer), false);
    });
    
    test('hasPermission delegates to auth provider', () async {
      when(mockAuthProvider.hasPermission('properties', 'create'))
          .thenAnswer((_) async => true);
      when(mockAuthProvider.hasPermission('leads', 'delete'))
          .thenAnswer((_) async => false);
      
      expect(await rbacProvider.hasPermission('properties', 'create'), true);
      expect(await rbacProvider.hasPermission('leads', 'delete'), false);
    });
    
    test('canCreate checks create permission', () async {
      when(mockAuthProvider.hasPermission('properties', 'create'))
          .thenAnswer((_) async => true);
      when(mockAuthProvider.hasPermission('leads', 'create'))
          .thenAnswer((_) async => false);
      
      expect(await rbacProvider.canCreate('properties'), true);
      expect(await rbacProvider.canCreate('leads'), false);
    });
    
    test('canRead checks read permission', () async {
      when(mockAuthProvider.hasPermission('properties', 'read'))
          .thenAnswer((_) async => true);
      when(mockAuthProvider.hasPermission('leads', 'read'))
          .thenAnswer((_) async => false);
      
      expect(await rbacProvider.canRead('properties'), true);
      expect(await rbacProvider.canRead('leads'), false);
    });
    
    test('canUpdate checks update permission and ownership', () async {
      // Case 1: User has general update permission
      when(mockAuthProvider.hasPermission('properties', 'update'))
          .thenAnswer((_) async => true);
      expect(await rbacProvider.canUpdate('properties', 'property-1'), true);
      
      // Case 2: User is developer and owns the resource
      when(mockAuthProvider.hasPermission('properties', 'update'))
          .thenAnswer((_) async => false);
      when(mockAuthProvider.isDeveloper).thenReturn(true);
      when(mockAuthProvider.isResourceOwner('properties', 'property-1'))
          .thenAnswer((_) async => true);
      
      expect(await rbacProvider.canUpdate('properties', 'property-1'), true);
      
      // Case 3: User is developer but doesn't own the resource
      when(mockAuthProvider.isResourceOwner('properties', 'property-2'))
          .thenAnswer((_) async => false);
      
      expect(await rbacProvider.canUpdate('properties', 'property-2'), false);
      
      // Case 4: User is not a developer and has no update permission
      when(mockAuthProvider.isDeveloper).thenReturn(false);
      
      expect(await rbacProvider.canUpdate('properties', 'property-1'), false);
    });
    
    test('canDelete checks delete permission and ownership', () async {
      // Case 1: User has general delete permission
      when(mockAuthProvider.hasPermission('properties', 'delete'))
          .thenAnswer((_) async => true);
      expect(await rbacProvider.canDelete('properties', 'property-1'), true);
      
      // Case 2: User is developer and owns the resource
      when(mockAuthProvider.hasPermission('properties', 'delete'))
          .thenAnswer((_) async => false);
      when(mockAuthProvider.isDeveloper).thenReturn(true);
      when(mockAuthProvider.isResourceOwner('properties', 'property-1'))
          .thenAnswer((_) async => true);
      
      expect(await rbacProvider.canDelete('properties', 'property-1'), true);
      
      // Case 3: User is developer but doesn't own the resource
      when(mockAuthProvider.isResourceOwner('properties', 'property-2'))
          .thenAnswer((_) async => false);
      
      expect(await rbacProvider.canDelete('properties', 'property-2'), false);
    });
  });
}
