import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/unified_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';
import '../../widgets/components/validation/password_validator.dart';
import '../../widgets/components/validation/password_strength_indicator.dart';
import '../../widgets/components/terms_and_conditions.dart';

class Step2BasicInfoScreen extends StatefulWidget {
  const Step2BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<Step2BasicInfoScreen> createState() => _Step2BasicInfoScreenState();
}

class _Step2BasicInfoScreenState extends State<Step2BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _loadSavedData() {
    final registrationProvider =
        provider_package.Provider.of<UnifiedRegistrationProvider>(context,
            listen: false);
    final savedData = registrationProvider.step2Data;

    if (savedData.isNotEmpty) {
      _fullNameController.text = savedData['fullName'] ?? '';
      _emailController.text = savedData['email'] ?? '';
      _phoneController.text = savedData['phone'] ?? '';
      _passwordController.text = savedData['password'] ?? '';
      _confirmPasswordController.text = savedData['confirmPassword'] ?? '';
      setState(() {
        _acceptTerms = savedData['acceptTerms'] ?? false;
      });
    }
  }

  void _submitStep() {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      // Check if terms are accepted
      if (!_acceptTerms) {
        setState(() {}); // Refresh to show error text in terms checkbox
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must accept the terms and conditions')),
        );
        return;
      }

      // Check password strength as a final validation
      final passwordStrength =
          PasswordValidator.calculateStrength(_passwordController.text);
      if (passwordStrength < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please create a stronger password')),
        );
        return;
      }

      final data = {
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
        'acceptTerms': _acceptTerms,
      };

      final registrationProvider =
          provider_package.Provider.of<UnifiedRegistrationProvider>(context,
              listen: false);
      registrationProvider.nextStep(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider =
        provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider =
        provider_package.Provider.of<UnifiedRegistrationProvider>(context);

    String userTypeLabel = '';
    switch (registrationProvider.userType) {
      case UserType.developer:
        userTypeLabel = 'Developer';
        break;
      case UserType.buyer:
        userTypeLabel = 'Buyer';
        break;
      case UserType.agent:
        userTypeLabel = 'Agent';
        break;
      default:
        userTypeLabel = '';
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userTypeLabel.isNotEmpty
                          ? 'Complete your $userTypeLabel account details'
                          : 'Complete your account details',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        // Simple Nigerian phone number validation
                        if (!RegExp(r'^(\+234|0)[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Create a password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        // Trigger rebuild for password strength indicator
                        setState(() {});
                      },
                      validator: (value) {
                        return PasswordValidator.validate(value);
                      },
                    ),
                    // Password strength indicator
                    if (_passwordController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 12.0, right: 12.0),
                        child: PasswordStrengthIndicator(
                          password: _passwordController.text,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Terms and conditions checkbox
                    TermsAndConditionsCheckbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      errorText: !_acceptTerms
                          ? 'You must accept the terms and conditions to continue'
                          : null,
                    ),
                    const SizedBox(height: 32),

                    // Navigation buttons
                    Row(
                      children: [
                        // Back button
                        OutlinedButton(
                          onPressed: registrationProvider.isLoading
                              ? null
                              : () {
                                  registrationProvider.previousStep();
                                },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          child: const Text('Back'),
                        ),
                        const SizedBox(width: 16),

                        // Continue button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: registrationProvider.isLoading
                                ? null
                                : _submitStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: registrationProvider.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text('Continue'),
                          ),
                        ),
                      ],
                    ),

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
      ),
    );
  }
}
