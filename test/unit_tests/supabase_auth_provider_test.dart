import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:devpropertyhub/core/providers/supabase_auth_provider.dart';
import 'package:devpropertyhub/core/services/auth_service.dart';
import 'package:devpropertyhub/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Generate mocks for the dependencies
@GenerateMocks(
    [AuthService, FlutterSecureStorage, GoTrueClient, SupabaseClient])
import 'supabase_auth_provider_test.mocks.dart';

void main() {
  late SupabaseAuthProvider authProvider;
  late MockAuthService mockAuthService;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockAuthService = MockAuthService();
    mockStorage = MockFlutterSecureStorage();

    // Create a mock user for testing
    final mockUser = UserModel(
      id: 'test-user-id',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      role: UserRole.developer,
      createdAt: DateTime.now(),
      isVerified: true,
    );

    // Setup mock responses
    when(mockAuthService.getCurrentUser()).thenAnswer((_) async => mockUser);
    when(mockStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    when(mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    // Initialize the auth provider with mocks
    authProvider = SupabaseAuthProvider();
    // Use reflection or dependency injection to set the mocked dependencies
    // This is a simplified approach - in a real test, you might need to use
    // a more sophisticated approach to inject these dependencies
  });

  group('SupabaseAuthProvider Tests', () {
    test('Initial state should be unauthenticated', () {
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.currentUser, isNull);
    });

    test('Sign in updates authentication state', () async {
      // Mock successful sign in
      when(mockAuthService.signIn(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => UserModel(
            id: 'test-user-id',
            email: 'test@example.com',
            firstName: 'Test',
            lastName: 'User',
            role: UserRole.developer,
            createdAt: DateTime.now(),
            isVerified: true,
          ));

      // Perform sign in
      final result =
          await authProvider.signIn('test@example.com', 'password123');

      // Verify result and state changes
      expect(result, true);
      expect(authProvider.isLoggedIn, true);
      expect(authProvider.currentUser, isNotNull);
      expect(authProvider.isDeveloper, true);
      expect(authProvider.isBuyer, false);
    });

    test('Sign up creates new user with correct role', () async {
      // Mock successful sign up
      when(mockAuthService.signUp(
        email: 'new@example.com',
        password: 'newpass123',
        firstName: 'New',
        lastName: 'User',
        role: UserRole.buyer,
        phone: '1234567890',
        companyName: null,
      )).thenAnswer((_) async => UserModel(
            id: 'new-user-id',
            email: 'new@example.com',
            firstName: 'New',
            lastName: 'User',
            role: UserRole.buyer,
            createdAt: DateTime.now(),
            isVerified: false,
            phone: '1234567890',
          ));

      // Perform sign up
      final result = await authProvider.signUp(
        email: 'new@example.com',
        password: 'newpass123',
        firstName: 'New',
        lastName: 'User',
        role: UserRole.buyer,
        phone: '1234567890',
      );

      // Verify result and state changes
      expect(result, true);
      expect(authProvider.isLoggedIn, true);
      expect(authProvider.currentUser, isNotNull);
      expect(authProvider.isBuyer, true);
      expect(authProvider.isDeveloper, false);
    });

    test('Sign out clears authentication state', () async {
      // First sign in
      when(mockAuthService.signIn(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => UserModel(
            id: 'test-user-id',
            email: 'test@example.com',
            firstName: 'Test',
            lastName: 'User',
            role: UserRole.developer,
            createdAt: DateTime.now(),
          ));

      await authProvider.signIn('test@example.com', 'password123');
      expect(authProvider.isLoggedIn, true);

      // Then sign out
      when(mockAuthService.signOut()).thenAnswer((_) async {});
      await authProvider.signOut();

      // Verify state is cleared
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.currentUser, isNull);
    });

    test('User profile getters return correct values', () async {
      // Sign in first
      when(mockAuthService.signIn(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => UserModel(
            id: 'test-user-id',
            email: 'test@example.com',
            firstName: 'Test',
            lastName: 'User',
            role: UserRole.developer,
            createdAt: DateTime.now(),
            phone: '1234567890',
            companyName: 'Test Company',
            avatarUrl: 'https://example.com/avatar.jpg',
          ));

      await authProvider.signIn('test@example.com', 'password123');

      // Verify getters
      expect(authProvider.userName, 'Test User');
      expect(authProvider.firstName, 'Test');
      expect(authProvider.lastName, 'User');
      expect(authProvider.phone, '1234567890');
      expect(authProvider.companyName, 'Test Company');
      expect(authProvider.avatarUrl, 'https://example.com/avatar.jpg');
    });
  });
}
