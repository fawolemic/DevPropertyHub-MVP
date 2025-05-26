import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/unified_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';
import 'step1_user_type.dart';
import 'step2_basic_info.dart';
import 'step3_role_specific.dart';
import 'registration_completion_wrapper.dart';

class UnifiedRegistrationScreen extends StatefulWidget {
  const UnifiedRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedRegistrationScreen> createState() => _UnifiedRegistrationScreenState();
}

class _UnifiedRegistrationScreenState extends State<UnifiedRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context);
    
    // Handle back button press
    return WillPopScope(
      onWillPop: () async {
        // If on first step, allow normal back button behavior
        if (registrationProvider.currentStep == 0) {
          return true;
        }
        
        // Otherwise, go to previous step and prevent default back behavior
        if (!registrationProvider.isLoading) {
          registrationProvider.previousStep();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          leading: registrationProvider.currentStep > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (!registrationProvider.isLoading) {
                      registrationProvider.previousStep();
                    }
                  },
                )
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
            // Progress indicator
            if (registrationProvider.currentStep < 3) ...[
              LinearProgressIndicator(
                value: (registrationProvider.currentStep + 1) / 4,
                backgroundColor: theme.colorScheme.surfaceVariant,
                color: theme.colorScheme.primary,
              ),
              // Step indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${registrationProvider.currentStep + 1} of 4',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      _getStepTitle(registrationProvider.currentStep),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Step content
            Expanded(
              child: _buildCurrentStep(registrationProvider.currentStep),
            ),
          ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentStep(int step) {
    switch (step) {
      case 0:
        return const Step1UserTypeScreen();
      case 1:
        return const Step2BasicInfoScreen();
      case 2:
        return const Step3RoleSpecificScreen();
      case 3:
        return const RegistrationCompletionWrapper();
      default:
        return const Center(
          child: Text('Invalid step'),
        );
    }
  }
  
  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'User Type';
      case 1:
        return 'Basic Information';
      case 2:
        return 'Role-Specific Details';
      case 3:
        return 'Complete';
      default:
        return 'Registration';
    }
  }
}
