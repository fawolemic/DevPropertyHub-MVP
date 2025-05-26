import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // Directly navigate to email verification with parameters in extra
    // The next screen after verification will be determined by the userType
    switch (userType) {
      case UserTypes.developer:
        GoRouter.of(context).go('/email-verification', extra: {
          'email': email,
          'userType': userType,
        });
        break;
      case UserTypes.buyer:
        GoRouter.of(context).go('/email-verification', extra: {
          'email': email,
          'userType': userType,
        });
        break;
      case UserTypes.agent:
        GoRouter.of(context).go('/email-verification', extra: {
          'email': email,
          'userType': userType,
          'fullName': fullName ?? 'Agent',
        });
        break;
      default:
        GoRouter.of(context).go('/email-verification', extra: {
          'email': email,
          'userType': userType,
        });
    }
  }

  /// Helper method to navigate to email verification
  /// This method is no longer needed as we're using direct GoRouter navigation with extra parameters
  /// Keeping it for backward compatibility but marking as deprecated
  @deprecated
  static void _navigateToEmailVerification({
    required BuildContext context,
    required String email,
    required VoidCallback onVerificationComplete,
    bool replace = true,
  }) {
    // Use GoRouter to navigate directly to the email verification screen with extra parameters
    GoRouter.of(context).go('/email-verification', extra: {
      'email': email,
      'onVerificationComplete': onVerificationComplete,
    });
  }

  /// Navigate directly to the approval status screen for agents
  static void navigateToApprovalStatus({
    required BuildContext context,
    required String agentName,
  }) {
    // Use GoRouter for navigation
    GoRouter.of(context).go('/approval-status', extra: {'agentName': agentName});
  }

  /// Navigate directly to subscription selection for developers
  static void navigateToSubscriptionSelection({
    required BuildContext context,
  }) {
    // Use GoRouter for navigation
    GoRouter.of(context).go('/subscription-selection');
  }
}
