import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/unified_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';

class RegistrationCompleteScreen extends StatelessWidget {
  const RegistrationCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider =
        provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider =
        provider_package.Provider.of<UnifiedRegistrationProvider>(context);

    // User type specific content
    String title;
    String subtitle;
    List<Map<String, dynamic>> nextSteps = [];
    Widget? specialContent;

    switch (registrationProvider.userType) {
      case UserType.developer:
        title = 'Developer Registration Complete';
        subtitle = 'Thank you for registering as a property developer';
        nextSteps = [
          {
            'icon': Icons.verified_user,
            'title': 'Verification',
            'description':
                'Your account is pending verification. We\'ll review your details within 24-48 hours.',
          },
          {
            'icon': Icons.subscriptions,
            'title': 'Choose a Subscription',
            'description':
                'Select a subscription plan to start listing your properties and developments.',
          },
          {
            'icon': Icons.add_business,
            'title': 'Add Your First Development',
            'description':
                'Once verified, you can add your first property development.',
          },
        ];
        break;

      case UserType.buyer:
        title = 'Buyer Registration Complete';
        subtitle = 'Welcome to DevPropertyHub! Your account has been created';
        nextSteps = [
          {
            'icon': Icons.email,
            'title': 'Verify Your Email',
            'description':
                'We\'ve sent a verification link to your email. Please check your inbox and verify your account.',
          },
          {
            'icon': Icons.home_work,
            'title': 'Explore Properties',
            'description':
                'Start exploring available properties that match your preferences.',
          },
          {
            'icon': Icons.notifications,
            'title': 'Set Up Alerts',
            'description':
                'Configure alerts to get notified when new properties matching your criteria are listed.',
          },
        ];
        // Add special content for email verification
        specialContent = Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: theme.colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verification Email Sent',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Haven\'t received it? Check your spam folder or click below to resend.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            // Function to resend verification email
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Verification email resent!')),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Resend Verification Email'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;

      case UserType.agent:
        title = 'Agent Registration Complete';
        subtitle = 'Thank you for registering as a property agent';
        nextSteps = [
          {
            'icon': Icons.verified,
            'title': 'Pending Approval',
            'description':
                'Your account is under review. We\'ll verify your credentials and invitation code.',
          },
          {
            'icon': Icons.person_search,
            'title': 'Developer Connection',
            'description':
                'Once approved, you\'ll be connected with the developer who invited you.',
          },
          {
            'icon': Icons.apartment,
            'title': 'Property Access',
            'description':
                'You\'ll gain access to properties you can market and sell on behalf of developers.',
          },
        ];
        break;

      default:
        title = 'Registration Complete';
        subtitle = 'Thank you for registering with DevPropertyHub';
        nextSteps = [
          {
            'icon': Icons.check_circle,
            'title': 'Account Created',
            'description': 'Your account has been successfully created.',
          },
        ];
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
                  ? BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.5))
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Next steps
                  Text(
                    'Next Steps',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Next steps list
                  ...nextSteps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  theme.colorScheme.secondary.withOpacity(0.1),
                            ),
                            child: Icon(
                              step['icon'] as IconData,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          title: Text(
                            step['title'] as String,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              step['description'] as String,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )),

                  // Special content (like email verification for buyers)
                  if (specialContent != null) specialContent,

                  const SizedBox(height: 32),

                  // Action buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the appropriate main screen
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Go to Dashboard'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          // Log out and go back to login screen
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
