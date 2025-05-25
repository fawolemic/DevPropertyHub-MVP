import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:devpropertyhub/core/providers/unified_registration_provider.dart';

void main() {
  late UnifiedRegistrationProvider registrationProvider;

  setUp(() {
    registrationProvider = UnifiedRegistrationProvider();
  });

  group('UnifiedRegistrationProvider tests', () {
    test('initial state is correct', () {
      expect(registrationProvider.currentStep, 0);
      expect(registrationProvider.userType, null);
      expect(registrationProvider.isLoading, false);
      expect(registrationProvider.errorMessage, null);
      expect(registrationProvider.step1Data, isEmpty);
      expect(registrationProvider.step2Data, isEmpty);
      expect(registrationProvider.step3Data, isEmpty);
    });

    test('setUserType updates user type correctly', () {
      registrationProvider.setUserType(UserType.developer);
      expect(registrationProvider.userType, UserType.developer);
      expect(registrationProvider.step1Data['userType'], 'developer');

      registrationProvider.setUserType(UserType.buyer);
      expect(registrationProvider.userType, UserType.buyer);
      expect(registrationProvider.step1Data['userType'], 'buyer');

      registrationProvider.setUserType(UserType.agent);
      expect(registrationProvider.userType, UserType.agent);
      expect(registrationProvider.step1Data['userType'], 'agent');
    });

    test('reset clears all data', () {
      // Set some data first
      registrationProvider.setUserType(UserType.developer);
      registrationProvider.nextStep({'userType': 'developer'});
      
      // Reset
      registrationProvider.reset();
      
      // Verify state is reset
      expect(registrationProvider.currentStep, 0);
      expect(registrationProvider.userType, null);
      expect(registrationProvider.isLoading, false);
      expect(registrationProvider.errorMessage, null);
      expect(registrationProvider.step1Data, isEmpty);
      expect(registrationProvider.step2Data, isEmpty);
      expect(registrationProvider.step3Data, isEmpty);
    });

    group('Step 1 validation', () {
      test('fails when user type is not selected', () {
        // Don't set user type
        final result = registrationProvider.nextStep({});
        expect(result, false);
        expect(registrationProvider.errorMessage, 'Please select a user type');
        expect(registrationProvider.currentStep, 0);
      });

      test('fails when agent has no invitation code', () {
        registrationProvider.setUserType(UserType.agent);
        final result = registrationProvider.nextStep({'userType': 'agent'});
        expect(result, false);
        expect(registrationProvider.errorMessage, 'Please enter a valid invitation code');
        expect(registrationProvider.currentStep, 0);
      });

      test('succeeds with valid developer data', () {
        registrationProvider.setUserType(UserType.developer);
        final result = registrationProvider.nextStep({'userType': 'developer'});
        expect(result, true);
        expect(registrationProvider.errorMessage, null);
        expect(registrationProvider.currentStep, 1);
      });

      test('succeeds with valid buyer data', () {
        registrationProvider.setUserType(UserType.buyer);
        final result = registrationProvider.nextStep({'userType': 'buyer'});
        expect(result, true);
        expect(registrationProvider.errorMessage, null);
        expect(registrationProvider.currentStep, 1);
      });

      test('succeeds with valid agent data', () {
        registrationProvider.setUserType(UserType.agent);
        final result = registrationProvider.nextStep({
          'userType': 'agent',
          'invitationCode': 'ABC123'
        });
        expect(result, true);
        expect(registrationProvider.errorMessage, null);
        expect(registrationProvider.currentStep, 1);
      });
    });

    group('Step 2 validation', () {
      setUp(() {
        // Set up for step 2 tests
        registrationProvider.setUserType(UserType.developer);
        registrationProvider.nextStep({'userType': 'developer'});
      });

      test('fails with missing required fields', () {
        final result = registrationProvider.nextStep({});
        expect(result, false);
        expect(registrationProvider.errorMessage, 'Please fill in all required fields');
        expect(registrationProvider.currentStep, 1);
      });

      test('fails when passwords do not match', () {
        final result = registrationProvider.nextStep({
          'fullName': 'Test User',
          'email': 'test@example.com',
          'phone': '08012345678',
          'password': 'password123',
          'confirmPassword': 'password456',
          'acceptTerms': true
        });
        expect(result, false);
        expect(registrationProvider.errorMessage, 'Passwords do not match');
        expect(registrationProvider.currentStep, 1);
      });

      test('fails when terms are not accepted', () {
        final result = registrationProvider.nextStep({
          'fullName': 'Test User',
          'email': 'test@example.com',
          'phone': '08012345678',
          'password': 'password123',
          'confirmPassword': 'password123',
          'acceptTerms': false
        });
        expect(result, false);
        expect(registrationProvider.errorMessage, 'You must accept the terms and conditions');
        expect(registrationProvider.currentStep, 1);
      });

      test('succeeds with valid data', () {
        final result = registrationProvider.nextStep({
          'fullName': 'Test User',
          'email': 'test@example.com',
          'phone': '08012345678',
          'password': 'password123',
          'confirmPassword': 'password123',
          'acceptTerms': true
        });
        expect(result, true);
        expect(registrationProvider.errorMessage, null);
        expect(registrationProvider.currentStep, 2);
      });
    });
    
    group('Step 3 validation', () {
      group('Developer validation', () {
        setUp(() {
          // Setup for developer step 3 tests
          registrationProvider.setUserType(UserType.developer);
          registrationProvider.nextStep({'userType': 'developer'});
          registrationProvider.nextStep({
            'fullName': 'Test User',
            'email': 'test@example.com',
            'phone': '08012345678',
            'password': 'password123',
            'confirmPassword': 'password123',
            'acceptTerms': true
          });
        });

        test('fails with missing required fields', () {
          final result = registrationProvider.nextStep({});
          expect(result, false);
          expect(registrationProvider.errorMessage, 'Please fill in all required fields');
          expect(registrationProvider.currentStep, 2);
        });

        test('fails when CAC certificate not uploaded', () {
          final result = registrationProvider.nextStep({
            'companyName': 'Test Company',
            'businessAddress': '123 Test Street',
            'rcNumber': 'RC123456',
            'yearsInBusiness': '5',
            'hasUploadedCertificate': false
          });
          expect(result, false);
          expect(registrationProvider.errorMessage, 'Please upload your CAC certificate');
          expect(registrationProvider.currentStep, 2);
        });

        test('succeeds with valid data', () {
          final result = registrationProvider.nextStep({
            'companyName': 'Test Company',
            'businessAddress': '123 Test Street',
            'rcNumber': 'RC123456',
            'yearsInBusiness': '5',
            'hasUploadedCertificate': true
          });
          expect(result, true);
          expect(registrationProvider.errorMessage, null);
          expect(registrationProvider.currentStep, 3);
        });
      });

      group('Buyer validation', () {
        setUp(() {
          // Setup for buyer step 3 tests
          registrationProvider.setUserType(UserType.buyer);
          registrationProvider.nextStep({'userType': 'buyer'});
          registrationProvider.nextStep({
            'fullName': 'Test User',
            'email': 'test@example.com',
            'phone': '08012345678',
            'password': 'password123',
            'confirmPassword': 'password123',
            'acceptTerms': true
          });
        });

        test('fails with missing property types', () {
          final result = registrationProvider.nextStep({
            'preferredLocations': ['Lagos - Island'],
            'budgetRange': 'NGN 10M - 30M'
          });
          expect(result, false);
          expect(registrationProvider.errorMessage, 'Please select at least one property type');
          expect(registrationProvider.currentStep, 2);
        });

        test('fails with missing preferred locations', () {
          final result = registrationProvider.nextStep({
            'propertyTypes': ['Apartment'],
            'budgetRange': 'NGN 10M - 30M'
          });
          expect(result, false);
          expect(registrationProvider.errorMessage, 'Please select at least one preferred location');
          expect(registrationProvider.currentStep, 2);
        });

        test('succeeds with valid data', () {
          final result = registrationProvider.nextStep({
            'propertyTypes': ['Apartment', 'House'],
            'preferredLocations': ['Lagos - Island', 'Abuja - Central'],
            'budgetRange': 'NGN 10M - 30M',
            'interestedInMortgage': true,
            'interestedInInvestmentProperties': false
          });
          expect(result, true);
          expect(registrationProvider.errorMessage, null);
          expect(registrationProvider.currentStep, 3);
        });
      });

      group('Agent validation', () {
        setUp(() {
          // Setup for agent step 3 tests
          registrationProvider.setUserType(UserType.agent);
          registrationProvider.nextStep({
            'userType': 'agent',
            'invitationCode': 'ABC123'
          });
          registrationProvider.nextStep({
            'fullName': 'Test User',
            'email': 'test@example.com',
            'phone': '08012345678',
            'password': 'password123',
            'confirmPassword': 'password123',
            'acceptTerms': true
          });
        });

        test('fails with missing required fields', () {
          final result = registrationProvider.nextStep({});
          expect(result, false);
          expect(registrationProvider.errorMessage, 'Please fill in all required fields');
          expect(registrationProvider.currentStep, 2);
        });

        test('fails with missing specializations', () {
          final result = registrationProvider.nextStep({
            'invitationCode': 'ABC123',
            'licenseNumber': 'LIC12345',
            'yearsOfExperience': '3'
          });
          expect(result, false);
          expect(registrationProvider.errorMessage, 'Please select at least one specialization area');
          expect(registrationProvider.currentStep, 2);
        });

        test('succeeds with valid data', () {
          final result = registrationProvider.nextStep({
            'invitationCode': 'ABC123',
            'licenseNumber': 'LIC12345',
            'yearsOfExperience': '3',
            'specializations': ['Residential', 'Commercial'],
            'bio': 'Experienced agent with focus on high-end properties'
          });
          expect(result, true);
          expect(registrationProvider.errorMessage, null);
          expect(registrationProvider.currentStep, 3);
        });
      });
    });

    test('previousStep decrements step counter', () {
      // First go to step 1
      registrationProvider.setUserType(UserType.developer);
      registrationProvider.nextStep({'userType': 'developer'});
      expect(registrationProvider.currentStep, 1);
      
      // Then go back to step 0
      registrationProvider.previousStep();
      expect(registrationProvider.currentStep, 0);
    });

    test('previousStep does not go below 0', () {
      expect(registrationProvider.currentStep, 0);
      registrationProvider.previousStep();
      expect(registrationProvider.currentStep, 0);
    });
  });
}
