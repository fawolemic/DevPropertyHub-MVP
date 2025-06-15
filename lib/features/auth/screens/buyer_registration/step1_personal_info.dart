import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;
import 'package:go_router/go_router.dart';

import '../../../../core/providers/buyer_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';

class Step1PersonalInfoScreen extends StatefulWidget {
  const Step1PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<Step1PersonalInfoScreen> createState() =>
      _Step1PersonalInfoScreenState();
}

class _Step1PersonalInfoScreenState extends State<Step1PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadSavedData() {
    final registrationProvider =
        provider_package.Provider.of<BuyerRegistrationProvider>(context,
            listen: false);
    final savedData = registrationProvider.step1Data;

    if (savedData.isNotEmpty) {
      _fullNameController.text = savedData['fullName'] ?? '';
      _emailController.text = savedData['email'] ?? '';
      _passwordController.text = savedData['password'] ?? '';
      _confirmPasswordController.text = savedData['password'] ?? '';
      _phoneController.text = savedData['phone'] ?? '';
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

      final data = {
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'phone': _phoneController.text.trim(),
      };

      final registrationProvider =
          provider_package.Provider.of<BuyerRegistrationProvider>(context,
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
        provider_package.Provider.of<BuyerRegistrationProvider>(context);

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
                      'Personal Information',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your buyer account to find your dream property',
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
                        labelText: 'Email',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
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

                    const Divider(),
                    const SizedBox(height: 24),

                    // Privacy policy acceptance
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'By continuing, you agree to our Terms of Service and Privacy Policy',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            registrationProvider.isLoading ? null : _submitStep,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: registrationProvider.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Next: Preferences'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          registrationProvider.resetRegistration();
                          GoRouter.of(context).go('/login');
                        },
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ),
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
