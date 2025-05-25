import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/unified_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';
import 'role_specific/developer_form.dart';
import 'role_specific/buyer_form.dart';
import 'role_specific/agent_form.dart';

class Step3RoleSpecificScreen extends StatelessWidget {
  const Step3RoleSpecificScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context);
    
    // Display appropriate form based on user type
    Widget formContent;
    String title;
    String subtitle;
    
    switch (registrationProvider.userType) {
      case UserType.developer:
        formContent = const DeveloperForm();
        title = 'Company Information';
        subtitle = 'Tell us about your development company';
        break;
      case UserType.buyer:
        formContent = const BuyerForm();
        title = 'Property Preferences';
        subtitle = 'Tell us what kind of properties you\'re interested in';
        break;
      case UserType.agent:
        formContent = const AgentForm();
        title = 'Agent Details';
        subtitle = 'Tell us about your professional experience';
        break;
      default:
        // Fallback if no user type is selected (shouldn't happen)
        formContent = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Please go back and select a user type',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  registrationProvider.previousStep();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        );
        title = 'Error';
        subtitle = 'No user type selected';
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: isLowBandwidth ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isLowBandwidth 
                  ? BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)) 
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dynamic form content based on user type
                  formContent,
                  
                  if (registrationProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      registrationProvider.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
