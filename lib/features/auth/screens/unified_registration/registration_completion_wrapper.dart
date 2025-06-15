import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devpropertyhub/core/constants/user_types.dart';
import 'package:devpropertyhub/core/providers/unified_registration_provider.dart';
import 'package:devpropertyhub/features/auth/screens/unified_registration/registration_success_screen.dart';

/// RegistrationCompletionWrapper
///
/// A wrapper widget that displays when registration is complete.
/// It extracts user data from the registration provider and passes it to the success screen.
///
/// SEARCH TAGS: #registration #completion #success
class RegistrationCompletionWrapper extends StatelessWidget {
  const RegistrationCompletionWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationProvider =
        Provider.of<UnifiedRegistrationProvider>(context);

    // Extract user data from registration provider
    final userTypeEnum = registrationProvider.userType;
    final String userType = userTypeEnum == UserType.developer
        ? UserTypes.developer
        : (userTypeEnum == UserType.buyer ? UserTypes.buyer : UserTypes.agent);

    final String email = registrationProvider.step2Data['email'] ?? '';
    final String fullName = registrationProvider.step2Data['fullName'] ?? '';

    // Collect any additional data that might be needed for specific user types
    Map<String, dynamic> additionalData = {};

    switch (userTypeEnum) {
      case UserType.developer:
        additionalData['companyName'] =
            registrationProvider.step3Data['companyName'];
        break;
      case UserType.buyer:
        additionalData['preferredLocations'] =
            registrationProvider.step3Data['preferredLocations'];
        break;
      case UserType.agent:
        additionalData['licenseNumber'] =
            registrationProvider.step3Data['licenseNumber'];
        break;
      default:
        break;
    }

    return RegistrationSuccessScreen(
      userType: userType,
      email: email,
      fullName: fullName,
      additionalData: additionalData,
    );
  }
}
