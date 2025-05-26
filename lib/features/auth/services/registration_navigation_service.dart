import 'package:flutter/material.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/common/email_verification_screen.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/developer/subscription_selection.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/agent/approval_status_screen.dart';
import 'package:devpropertyhub/core/constants/user_types.dart';

/// RegistrationNavigationService
///
/// Handles navigation logic for the registration flow, directing users to
/// the appropriate screens after registration completion based on their user type.
///
/// SEARCH TAGS: #registration #navigation #user_flow
class RegistrationNavigationService {
  /// Navigates to the appropriate post-registration screen based on user type
  ///
  /// [context] - Current build context
  /// [userType] - Type of user (developer, buyer, agent)
  /// [email] - User's email address (needed for verification)
  /// [fullName] - User's full name (needed for some screens)
  /// [replace] - Whether to replace the current route or push a new one
  static void navigateToPostRegistrationScreen({
    required BuildContext context,
    required String userType,
    required String email,
    String? fullName,
    bool replace = true,
  }) {
    switch (userType) {
      case UserTypes.developer:
        _navigateToEmailVerification(
          context: context,
          email: email,
          onVerificationComplete: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscriptionSelectionScreen(),
              ),
            );
          },
          replace: replace,
        );
        break;
      case UserTypes.buyer:
        _navigateToEmailVerification(
          context: context,
          email: email,
          onVerificationComplete: () {
            // Navigate to home or buyer dashboard
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home', 
              (route) => false,
            );
          },
          replace: replace,
        );
        break;
      case UserTypes.agent:
        _navigateToEmailVerification(
          context: context,
          email: email,
          onVerificationComplete: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovalStatusScreen(
                  agentName: fullName ?? 'Agent',
                ),
              ),
            );
          },
          replace: replace,
        );
        break;
      default:
        // Default fallback - just go to email verification
        _navigateToEmailVerification(
          context: context,
          email: email,
          onVerificationComplete: () {
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home', 
              (route) => false,
            );
          },
          replace: replace,
        );
    }
  }

  /// Helper method to navigate to email verification
  static void _navigateToEmailVerification({
    required BuildContext context,
    required String email,
    required VoidCallback onVerificationComplete,
    bool replace = true,
  }) {
    final route = MaterialPageRoute(
      builder: (context) => EmailVerificationScreen(
        email: email,
        onVerificationComplete: onVerificationComplete,
      ),
    );

    if (replace) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  /// Navigate directly to the approval status screen for agents
  static void navigateToApprovalStatus({
    required BuildContext context,
    required String agentName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalStatusScreen(
          agentName: agentName,
        ),
      ),
    );
  }

  /// Navigate directly to subscription selection for developers
  static void navigateToSubscriptionSelection({
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubscriptionSelectionScreen(),
      ),
    );
  }
}
