import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/bandwidth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  String _userType = 'developer'; // Default user type

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = provider_package.Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
        userType: _userType,
      );

      if (success) {
        if (mounted) {
          context.go('/dashboard');
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setDemoCredentials(String roleOrType) {
    setState(() {
      switch (roleOrType) {
        case 'admin':
          _emailController.text = 'admin@example.com';
          _passwordController.text = 'password';
          _userType = 'developer';
          break;
        case 'standard':
          _emailController.text = 'user@example.com';
          _passwordController.text = 'password';
          _userType = 'developer';
          break;
        case 'viewer':
          _emailController.text = 'viewer@example.com';
          _passwordController.text = 'password';
          _userType = 'developer';
          break;
        case 'buyer':
          _emailController.text = 'buyer@example.com';
          _passwordController.text = 'password';
          _userType = 'buyer';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and title
                if (!isLowBandwidth) ...[
                  Icon(
                    Icons.apartment,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  Icon(
                    Icons.apartment,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'DevPropertyHub',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Property Developer Portal',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),

                // Login form
                Card(
                  elevation: isLowBandwidth ? 0 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: isLowBandwidth
                        ? BorderSide(color: Colors.grey.shade300)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Sign In',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          // Registration link
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              child: const Text('New Developer? Register here'),
                            ),
                          ),
                          // User type selection
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Developer'),
                                  value: 'developer',
                                  groupValue: _userType,
                                  onChanged: (value) {
                                    setState(() {
                                      _userType = value!;
                                    });
                                  },
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Buyer'),
                                  value: 'buyer',
                                  groupValue: _userType,
                                  onChanged: (value) {
                                    setState(() {
                                      _userType = value!;
                                    });
                                  },
                                  dense: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Error message
                          if (_errorMessage != null) ...[                          
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Login button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Sign In'),
                          ),
                          
                          // Registration link
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              child: const Text('New Developer? Register here'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Demo credentials section
                const SizedBox(height: 24),
                Card(
                  elevation: isLowBandwidth ? 0 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: isLowBandwidth
                        ? BorderSide(color: Colors.grey.shade300)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo Access',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use these credentials to explore different user roles:',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),

                        // Role selection buttons
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildRoleButton(
                              context,
                              'Admin',
                              Colors.purple,
                              () => _setDemoCredentials('admin'),
                              Icons.admin_panel_settings,
                            ),
                            _buildRoleButton(
                              context,
                              'Standard',
                              Colors.blue,
                              () => _setDemoCredentials('standard'),
                              Icons.person,
                            ),
                            _buildRoleButton(
                              context,
                              'Viewer',
                              Colors.teal,
                              () => _setDemoCredentials('viewer'),
                              Icons.visibility,
                            ),
                            _buildRoleButton(
                              context,
                              'Buyer',
                              Colors.orange,
                              () => _setDemoCredentials('buyer'),
                              Icons.shopping_bag,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bandwidth toggle for testing
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    icon: Icon(
                      bandwidthProvider.isLowBandwidth
                          ? Icons.signal_cellular_alt_1_bar
                          : Icons.signal_cellular_alt,
                    ),
                    label: Text(
                      bandwidthProvider.isLowBandwidth
                          ? 'Switch to High Bandwidth'
                          : 'Switch to Low Bandwidth',
                    ),
                    onPressed: () {
                      bandwidthProvider.toggleLowBandwidthMode();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        size: 16,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
