import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/bandwidth_provider.dart';
import '../../../../core/providers/registration_provider.dart';

class RegistrationCompleteScreen extends StatelessWidget {
  const RegistrationCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    
    // Get some basic information from the registration
    final userData = registrationProvider.step1Data;
    final companyName = userData['companyName'] ?? 'your company';
    final contactName = userData['contactPerson'] ?? 'Developer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Complete'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon and animation
              if (!isLowBandwidth) ...[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ] else ...[
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Success message
              Text(
                'Registration Complete!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Thank you for registering $companyName',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Verification status card
              Card(
                elevation: isLowBandwidth ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isLowBandwidth 
                      ? BorderSide(color: theme.colorScheme.outline)
                      : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pending_outlined,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Verification Pending',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your account is currently pending verification. We\'ll review your application within 24-48 hours.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Next steps
                      Text(
                        'Next Steps',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildNextStepItem(
                        theme,
                        icon: Icons.phone_outlined,
                        title: 'Phone Verification',
                        description: 'We may contact you to verify your phone number.',
                      ),
                      
                      _buildNextStepItem(
                        theme,
                        icon: Icons.document_scanner_outlined,
                        title: 'Document Review',
                        description: 'Our team will verify your submitted documents.',
                      ),
                      
                      _buildNextStepItem(
                        theme,
                        icon: Icons.email_outlined,
                        title: 'Email Confirmation',
                        description: 'You\'ll receive an email once your account is approved.',
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      GoRouter.of(context).go('/login');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  OutlinedButton.icon(
                    onPressed: () {
                      // For a real app, this would send to a contact page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact support functionality would be here'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Contact Support'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextStepItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
