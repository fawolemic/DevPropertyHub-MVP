import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:devpropertyhub/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Complete Registration Flow', () {
    testWidgets('should complete developer registration journey', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to registration
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();
      
      // Step 1: Select Developer role
      final developerRoleCard = find.text('Developer');
      expect(developerRoleCard, findsOneWidget);
      await tester.tap(developerRoleCard);
      await tester.pumpAndSettle();
      
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Step 2: Fill basic information
      final fullNameField = find.widgetWithText(TextFormField, 'Full Name');
      expect(fullNameField, findsOneWidget);
      await tester.enterText(fullNameField, 'Test Developer');
      
      final emailField = find.widgetWithText(TextFormField, 'Email Address');
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'developer@test.com');
      
      final phoneField = find.widgetWithText(TextFormField, 'Phone Number');
      expect(phoneField, findsOneWidget);
      await tester.enterText(phoneField, '08012345678');
      
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'Password123!');
      
      final confirmPasswordField = find.widgetWithText(TextFormField, 'Confirm Password');
      expect(confirmPasswordField, findsOneWidget);
      await tester.enterText(confirmPasswordField, 'Password123!');
      
      // Accept terms
      final termsCheckbox = find.byType(Checkbox);
      expect(termsCheckbox, findsOneWidget);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();
      
      // Continue to next step
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Step 3: Fill developer-specific information
      final companyNameField = find.widgetWithText(TextFormField, 'Company Name');
      expect(companyNameField, findsOneWidget);
      await tester.enterText(companyNameField, 'Test Company Ltd');
      
      final businessAddressField = find.widgetWithText(TextFormField, 'Business Address');
      expect(businessAddressField, findsOneWidget);
      await tester.enterText(businessAddressField, '123 Test Street, Lagos');
      
      final rcNumberField = find.widgetWithText(TextFormField, 'RC Number');
      expect(rcNumberField, findsOneWidget);
      await tester.enterText(rcNumberField, 'RC123456');
      
      final yearsInBusinessField = find.widgetWithText(TextFormField, 'Years in Business');
      expect(yearsInBusinessField, findsOneWidget);
      await tester.enterText(yearsInBusinessField, '5');
      
      // Upload document
      final uploadButton = find.text('Upload CAC Certificate');
      expect(uploadButton, findsOneWidget);
      await tester.tap(uploadButton);
      await tester.pumpAndSettle(const Duration(seconds: 3)); // Wait for mock upload
      
      // Continue to final step
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Verify success screen
      expect(find.text('Developer Registration Complete'), findsOneWidget);
      
      // Verify next steps are shown
      expect(find.text('Verification'), findsOneWidget);
      expect(find.text('Choose a Subscription'), findsOneWidget);
      
      // Test subscription selection navigation
      final subscriptionButton = find.text('Choose a Subscription');
      expect(subscriptionButton, findsOneWidget);
      await tester.tap(subscriptionButton);
      await tester.pumpAndSettle();
      
      // Verify we're on the subscription page
      expect(find.text('Select Subscription Plan'), findsOneWidget);
      
      // Select Basic plan
      final basicPlanCard = find.text('Basic');
      expect(basicPlanCard, findsOneWidget);
      await tester.tap(basicPlanCard);
      await tester.pumpAndSettle();
      
      // Continue to payment
      final paymentButton = find.text('Continue to Payment');
      expect(paymentButton, findsOneWidget);
      await tester.tap(paymentButton);
      await tester.pumpAndSettle();
      
      // Check for payment confirmation message
      expect(find.textContaining('Proceeding to payment'), findsOneWidget);
    });
    
    testWidgets('should complete buyer registration journey', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to registration
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();
      
      // Step 1: Select Buyer role
      final buyerRoleCard = find.text('Buyer');
      expect(buyerRoleCard, findsOneWidget);
      await tester.tap(buyerRoleCard);
      await tester.pumpAndSettle();
      
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Step 2: Fill basic information
      final fullNameField = find.widgetWithText(TextFormField, 'Full Name');
      expect(fullNameField, findsOneWidget);
      await tester.enterText(fullNameField, 'Test Buyer');
      
      final emailField = find.widgetWithText(TextFormField, 'Email Address');
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'buyer@test.com');
      
      final phoneField = find.widgetWithText(TextFormField, 'Phone Number');
      expect(phoneField, findsOneWidget);
      await tester.enterText(phoneField, '08012345679');
      
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'Password123!');
      
      final confirmPasswordField = find.widgetWithText(TextFormField, 'Confirm Password');
      expect(confirmPasswordField, findsOneWidget);
      await tester.enterText(confirmPasswordField, 'Password123!');
      
      // Accept terms
      final termsCheckbox = find.byType(Checkbox);
      expect(termsCheckbox, findsOneWidget);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();
      
      // Continue to next step
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Step 3: Fill buyer preferences
      // Select property types
      final apartmentChip = find.text('Apartment');
      expect(apartmentChip, findsOneWidget);
      await tester.tap(apartmentChip);
      await tester.pumpAndSettle();
      
      // Select locations using the enhanced component
      final locationSearchField = find.widgetWithText(TextField, 'Search locations');
      expect(locationSearchField, findsOneWidget);
      await tester.enterText(locationSearchField, 'Lagos');
      await tester.pumpAndSettle();
      
      final lagosMainlandItem = find.text('Lagos - Mainland');
      expect(lagosMainlandItem, findsOneWidget);
      await tester.tap(lagosMainlandItem);
      await tester.pumpAndSettle();
      
      // Select budget range
      final budgetDropdown = find.text('NGN 10M - 30M');
      expect(budgetDropdown, findsOneWidget);
      await tester.tap(budgetDropdown);
      await tester.pumpAndSettle();
      
      final budgetOption = find.text('NGN 30M - 50M').last;
      await tester.tap(budgetOption);
      await tester.pumpAndSettle();
      
      // Continue to final step
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Verify success screen
      expect(find.text('Buyer Registration Complete'), findsOneWidget);
      
      // Verify email verification is suggested
      final verifyEmailButton = find.text('Verify Email');
      expect(verifyEmailButton, findsOneWidget);
      await tester.tap(verifyEmailButton);
      await tester.pumpAndSettle();
      
      // Verify we're on the email verification page
      expect(find.text('Verify Your Email'), findsOneWidget);
      
      // Enter verification code
      final codeFields = find.byType(TextField);
      expect(codeFields, findsNWidgets(6));
      
      // Enter code 123456
      await tester.enterText(codeFields.at(0), '1');
      await tester.enterText(codeFields.at(1), '2');
      await tester.enterText(codeFields.at(2), '3');
      await tester.enterText(codeFields.at(3), '4');
      await tester.enterText(codeFields.at(4), '5');
      await tester.enterText(codeFields.at(5), '6');
      await tester.pumpAndSettle();
      
      // Tap verify button
      final verifyButton = find.text('Verify Email');
      expect(verifyButton, findsOneWidget);
      await tester.tap(verifyButton);
      await tester.pumpAndSettle();
      
      // Verification should be successful
      expect(find.text('Email verified successfully'), findsOneWidget);
    });
    
    testWidgets('should complete agent registration journey', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to registration
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();
      
      // Step 1: Select Agent role
      final agentRoleCard = find.text('Agent');
      expect(agentRoleCard, findsOneWidget);
      await tester.tap(agentRoleCard);
      await tester.pumpAndSettle();
      
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Step 2: Fill basic information
      final fullNameField = find.widgetWithText(TextFormField, 'Full Name');
      expect(fullNameField, findsOneWidget);
      await tester.enterText(fullNameField, 'Test Agent');
      
      final emailField = find.widgetWithText(TextFormField, 'Email Address');
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'agent@test.com');
      
      final phoneField = find.widgetWithText(TextFormField, 'Phone Number');
      expect(phoneField, findsOneWidget);
      await tester.enterText(phoneField, '08012345680');
      
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, 'Password123!');
      
      final confirmPasswordField = find.widgetWithText(TextFormField, 'Confirm Password');
      expect(confirmPasswordField, findsOneWidget);
      await tester.enterText(confirmPasswordField, 'Password123!');
      
      // Accept terms
      final termsCheckbox = find.byType(Checkbox);
      expect(termsCheckbox, findsOneWidget);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();
      
      // Continue to next step
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Step 3: Fill agent information
      final licenseNumberField = find.widgetWithText(TextFormField, 'License Number');
      expect(licenseNumberField, findsOneWidget);
      await tester.enterText(licenseNumberField, 'LIC12345');
      
      final yearsExperienceField = find.widgetWithText(TextFormField, 'Years of Experience');
      expect(yearsExperienceField, findsOneWidget);
      await tester.enterText(yearsExperienceField, '7');
      
      // Select specializations
      final residentialChip = find.text('Residential');
      expect(residentialChip, findsOneWidget);
      await tester.tap(residentialChip);
      await tester.pumpAndSettle();
      
      final commercialChip = find.text('Commercial');
      expect(commercialChip, findsOneWidget);
      await tester.tap(commercialChip);
      await tester.pumpAndSettle();
      
      // Continue to final step
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
      
      // Verify success screen
      expect(find.text('Agent Registration Complete'), findsOneWidget);
      
      // Check application status
      final checkStatusButton = find.text('Check Application Status');
      expect(checkStatusButton, findsOneWidget);
      await tester.tap(checkStatusButton);
      await tester.pumpAndSettle();
      
      // Verify we're on the approval status page
      expect(find.text('Application Status'), findsOneWidget);
      expect(find.text('Approval Timeline'), findsOneWidget);
      
      // Verify timeline elements
      expect(find.text('Application Submitted'), findsOneWidget);
      expect(find.text('Document Review'), findsOneWidget);
      expect(find.text('Background Verification'), findsOneWidget);
      expect(find.text('Approval Decision'), findsOneWidget);
      
      // Test contact support
      final contactSupportButton = find.text('Contact Support');
      expect(contactSupportButton, findsOneWidget);
      await tester.tap(contactSupportButton);
      await tester.pumpAndSettle();
      
      // Verify dialog is shown
      expect(find.text('Our support team is available to help you with any questions about your agent application.'), findsOneWidget);
      
      // Close dialog
      final closeButton = find.text('Close');
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();
    });
  });
}
