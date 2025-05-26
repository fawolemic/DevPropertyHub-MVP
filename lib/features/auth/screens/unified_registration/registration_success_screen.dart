import 'package:flutter/material.dart';
import 'package:devpropertyhub/core/constants/user_types.dart';
import 'package:devpropertyhub/features/auth/services/registration_navigation_service.dart';

/// RegistrationSuccessScreen
/// 
/// A unified screen shown after successful registration that provides appropriate
/// next steps based on the user type (developer, buyer, or agent).
/// 
/// SEARCH TAGS: #registration #success #onboarding
class RegistrationSuccessScreen extends StatelessWidget {
  final String userType;
  final String email;
  final String fullName;
  final Map<String, dynamic>? additionalData;

  const RegistrationSuccessScreen({
    Key? key,
    required this.userType,
    required this.email,
    required this.fullName,
    this.additionalData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: theme.colorScheme.primary,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Success title
                Text(
                  _getSuccessTitle(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Success message
                Text(
                  'Welcome to DevPropertyHub, $fullName! Your account has been created successfully.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Next steps card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Steps',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // List of next steps
                        ..._buildNextSteps(context),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Primary action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handlePrimaryAction(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(_getPrimaryActionText()),
                  ),
                ),
                
                if (_getSecondaryActionText() != null) ...[
                  const SizedBox(height: 16),
                  // Secondary action button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleSecondaryAction(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_getSecondaryActionText()!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getSuccessTitle() {
    switch (userType) {
      case UserTypes.developer:
        return 'Developer Registration Complete';
      case UserTypes.buyer:
        return 'Buyer Registration Complete';
      case UserTypes.agent:
        return 'Agent Registration Complete';
      default:
        return 'Registration Complete';
    }
  }
  
  List<Widget> _buildNextSteps(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> steps = [];
    
    // Add steps based on user type
    if (userType == UserTypes.developer) {
      steps.addAll([
        {
          'title': 'Verification',
          'description': 'Verify your email address to activate your account.',
          'icon': Icons.mail_outline,
        },
        {
          'title': 'Choose a Subscription',
          'description': 'Select a subscription plan for your developer account.',
          'icon': Icons.card_membership,
        },
      ]);
    } else if (userType == UserTypes.buyer) {
      steps.addAll([
        {
          'title': 'Verification',
          'description': 'Verify your email address to activate your account.',
          'icon': Icons.mail_outline,
        },
        {
          'title': 'Browse Properties',
          'description': 'Start browsing available properties on the platform.',
          'icon': Icons.search,
        },
      ]);
    } else if (userType == UserTypes.agent) {
      steps.addAll([
        {
          'title': 'Verification',
          'description': 'Verify your email address to begin the approval process.',
          'icon': Icons.mail_outline,
        },
        {
          'title': 'Application Review',
          'description': 'Our team will review your application within 2-3 business days.',
          'icon': Icons.rate_review,
        },
      ]);
    }
    
    return steps.map((step) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                step['icon'] as IconData,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step['description'] as String,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
  
  String _getPrimaryActionText() {
    switch (userType) {
      case UserTypes.developer:
        return 'Verify Email';
      case UserTypes.buyer:
        return 'Verify Email';
      case UserTypes.agent:
        return 'Verify Email';
      default:
        return 'Continue';
    }
  }
  
  String? _getSecondaryActionText() {
    switch (userType) {
      case UserTypes.developer:
        return 'Choose a Subscription';
      case UserTypes.buyer:
        return 'Explore Dashboard';
      case UserTypes.agent:
        return 'Check Application Status';
      default:
        return null;
    }
  }
  
  void _handlePrimaryAction(BuildContext context) {
    // For all user types, primary action is email verification
    RegistrationNavigationService.navigateToPostRegistrationScreen(
      context: context,
      userType: userType,
      email: email,
      fullName: fullName,
    );
  }
  
  void _handleSecondaryAction(BuildContext context) {
    switch (userType) {
      case UserTypes.developer:
        // Navigate directly to subscription selection
        RegistrationNavigationService.navigateToSubscriptionSelection(
          context: context,
        );
        break;
      case UserTypes.buyer:
        // Navigate to home/dashboard
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/home', 
          (route) => false,
        );
        break;
      case UserTypes.agent:
        // Navigate to approval status screen
        RegistrationNavigationService.navigateToApprovalStatus(
          context: context,
          agentName: fullName,
        );
        break;
    }
  }
}
