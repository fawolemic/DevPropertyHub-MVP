import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider_package;
import '../../../core/providers/unified_registration_provider.dart';

class RegistrationTestPage extends StatelessWidget {
  const RegistrationTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Testing Registration Navigation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Reset the provider to ensure we start at step 0
                final provider =
                    provider_package.Provider.of<UnifiedRegistrationProvider>(
                        context,
                        listen: false);
                provider.reset();

                // Navigate to the unified registration screen
                context.go('/unified-register');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Start Unified Registration'),
            ),
            const SizedBox(height: 16),
            // Direct step navigation for testing
            const Text(
              'Direct Step Navigation (For Testing):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildStepButton(context, 'Step 1: User Type', 0),
                _buildStepButton(context, 'Step 2: Basic Info', 1),
                _buildStepButton(context, 'Step 3: Role Details', 2),
                _buildStepButton(context, 'Step 4: Complete', 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepButton(BuildContext context, String label, int step) {
    return OutlinedButton(
      onPressed: () {
        final provider =
            provider_package.Provider.of<UnifiedRegistrationProvider>(context,
                listen: false);
        // Directly set the step for testing
        if (step == 0) {
          provider.reset();
        } else {
          // For other steps, we need to set up minimal data
          provider.reset();
          if (step >= 1) {
            provider.setUserType(UserType.developer);
            provider.nextStep({'userType': 'developer'});
          }
          if (step >= 2) {
            provider.nextStep({
              'fullName': 'Test User',
              'email': 'test@example.com',
              'phone': '08012345678',
              'password': 'password123',
              'confirmPassword': 'password123',
              'acceptTerms': true
            });
          }
          if (step >= 3) {
            provider.nextStep({
              'companyName': 'Test Company',
              'businessAddress': '123 Test Street',
              'rcNumber': 'RC123456',
              'yearsInBusiness': '5',
              'hasUploadedCertificate': true
            });
          }
        }
        // Navigate to unified registration
        context.go('/unified-register');
      },
      child: Text(label),
    );
  }
}
