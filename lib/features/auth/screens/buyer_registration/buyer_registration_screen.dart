import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/bandwidth_provider.dart';
import '../../../../core/providers/buyer_registration_provider.dart';
import 'step1_personal_info.dart';
import 'step2_preferences.dart';
import 'buyer_registration_complete.dart';

/// Main screen for the buyer registration flow
/// Follows Material Design principles and is optimized for low-bandwidth scenarios
class BuyerRegistrationScreen extends StatefulWidget {
  const BuyerRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<BuyerRegistrationScreen> createState() =>
      _BuyerRegistrationScreenState();
}

class _BuyerRegistrationScreenState extends State<BuyerRegistrationScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Initialize the buyer registration provider to step 1
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registrationProvider =
          provider_package.Provider.of<BuyerRegistrationProvider>(context,
              listen: false);
      if (registrationProvider.currentStep != 1) {
        registrationProvider.resetRegistration();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step <= 0 || step > 2) return;

    final registrationProvider =
        provider_package.Provider.of<BuyerRegistrationProvider>(context,
            listen: false);
    if (registrationProvider.goToStep(step)) {
      _pageController.animateToPage(
        step - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider =
        provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider =
        provider_package.Provider.of<BuyerRegistrationProvider>(context);

    // Listen for changes to registration step
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        final currentPage = _pageController.page?.round() ?? 0;
        if (currentPage != registrationProvider.currentStep - 1) {
          _pageController.jumpToPage(registrationProvider.currentStep - 1);
        }
      }
    });

    // Check if registration is complete
    if (registrationProvider.registrationComplete) {
      return const BuyerRegistrationCompleteScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (registrationProvider.currentStep == 1) {
              // Navigate back to home page
              GoRouter.of(context).go('/');
            } else {
              _goToStep(registrationProvider.currentStep - 1);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Stepper indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildStepIndicator(
                registrationProvider.currentStep, isLowBandwidth, theme),
          ),

          // Error message if any
          if (registrationProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  registrationProvider.errorMessage!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Registration steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Step1PersonalInfoScreen(),
                Step2PreferencesScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
      int currentStep, bool isLowBandwidth, ThemeData theme) {
    return Row(
      children: List.generate(2, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        return Expanded(
          child: Row(
            children: [
              // Step circle
              Container(
                width: isLowBandwidth ? 32 : 40,
                height: isLowBandwidth ? 32 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                  border: Border.all(
                    color: isCompleted || isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          color: theme.colorScheme.onPrimary,
                          size: isLowBandwidth ? 16 : 20,
                        )
                      : Text(
                          '$stepNumber',
                          style: TextStyle(
                            color: isActive
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: isLowBandwidth ? 14 : 16,
                          ),
                        ),
                ),
              ),

              // Step label
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _getStepLabel(stepNumber),
                    style: TextStyle(
                      color: isActive || isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: isActive || isCompleted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: isLowBandwidth ? 12 : 14,
                    ),
                  ),
                ),
              ),

              // Connector line (except after the last step)
              if (stepNumber < 2)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 1:
        return 'Personal Information';
      case 2:
        return 'Preferences';
      default:
        return 'Step $step';
    }
  }
}
