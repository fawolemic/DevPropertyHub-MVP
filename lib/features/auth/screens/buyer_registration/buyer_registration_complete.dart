import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/bandwidth_provider.dart';

class BuyerRegistrationCompleteScreen extends StatelessWidget {
  const BuyerRegistrationCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Success icon
                      Container(
                        width: isLowBandwidth ? 80 : 100,
                        height: isLowBandwidth ? 80 : 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                          size: isLowBandwidth ? 50 : 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Success title
                      Text(
                        'Registration Successful!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      
                      // Success message
                      Text(
                        'Your buyer account has been created successfully. You can now start exploring properties that match your preferences.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // What's next section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What\'s Next?',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            _buildNextStep(
                              context,
                              icon: Icons.search,
                              title: 'Browse Properties',
                              description: 'Explore properties that match your preferences',
                            ),
                            const SizedBox(height: 12),
                            
                            _buildNextStep(
                              context,
                              icon: Icons.star_border,
                              title: 'Save Favorites',
                              description: 'Keep track of properties you\'re interested in',
                            ),
                            const SizedBox(height: 12),
                            
                            _buildNextStep(
                              context,
                              icon: Icons.contact_page_outlined,
                              title: 'Connect with Developers',
                              description: 'Contact property developers directly through the platform',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      // Continue to dashboard button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to login screen
                            GoRouter.of(context).go('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Continue to Login'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Go home button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            GoRouter.of(context).go('/');
                          },
                          child: const Text('Return to Home'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNextStep(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
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
    );
  }
}
