import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/bandwidth_provider.dart';
import '../../../../core/providers/registration_provider.dart';
import 'step1_basic_info.dart';
import 'step2_company_verification.dart';
import 'step3_subscription.dart';
import 'registration_complete.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Initialize the registration provider to step 1
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
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
    if (step <= 0 || step > 3) return;
    
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
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
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = Provider.of<RegistrationProvider>(context);
    
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
      return const RegistrationCompleteScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (registrationProvider.currentStep == 1) {
              GoRouter.of(context).go('/login');
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
            child: _buildStepIndicator(registrationProvider.currentStep, isLowBandwidth, theme),
          ),
          
          // Error message if any
          if (registrationProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  registrationProvider.errorMessage!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          
          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Step1BasicInfoScreen(),
                Step2CompanyVerificationScreen(),
                Step3SubscriptionScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int currentStep, bool isLowBandwidth, ThemeData theme) {
    return Row(
      children: List.generate(3, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;
        
        return Expanded(
          child: Column(
            children: [
              // Step number indicator
              Container(
                width: isLowBandwidth ? 32 : 40,
                height: isLowBandwidth ? 32 : 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : isActive
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive || isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.5),
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
                          stepNumber.toString(),
                          style: TextStyle(
                            color: isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Step label
              Text(
                _getStepLabel(stepNumber),
                style: TextStyle(
                  color: isActive || isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: isLowBandwidth ? 12 : 14,
                ),
                textAlign: TextAlign.center,
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
        return 'Basic Info';
      case 2:
        return 'Verification';
      case 3:
        return 'Subscription';
      default:
        return '';
    }
  }
}
