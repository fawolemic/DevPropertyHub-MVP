import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/auth_provider.dart';

/// LoginForm
///
/// A form component for user authentication.
/// Contains email and password fields, validation, error handling,
/// and login button with loading state.
///
/// SEARCH TAGS: #auth #login #form #authentication #signin
class LoginForm extends StatefulWidget {
  final Function(String userType)? onUserTypeChanged;
  final bool showDemoOptions;

  const LoginForm({
    Key? key,
    this.onUserTypeChanged,
    this.showDemoOptions = false,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
        userType: _userType,
      );

      if (success) {
        if (mounted) {
          context.go('/developments');
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
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User type selection
          _buildUserTypeSelector(theme),

          const SizedBox(height: 24),

          // Email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
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
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 8),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: const Text('Forgot Password?'),
            ),
          ),

          const SizedBox(height: 8),

          // Error message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),

          // Login button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sign In'),
          ),

          const SizedBox(height: 16),

          // Register link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  context.go('/unified-register');
                },
                child: const Text('Register'),
              ),
            ],
          ),

          // Demo options
          if (widget.showDemoOptions) _buildDemoOptions(theme),
        ],
      ),
    );
  }

  Widget _buildUserTypeSelector(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I am a:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildUserTypeOption(
                    'Developer',
                    'developer',
                    Icons.business,
                    theme,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUserTypeOption(
                    'Buyer',
                    'buyer',
                    Icons.person,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeOption(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    final isSelected = _userType == value;

    return InkWell(
      onTap: () {
        setState(() {
          _userType = value;
        });
        if (widget.onUserTypeChanged != null) {
          widget.onUserTypeChanged!(value);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoOptions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Demo Accounts:',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDemoButton('Admin', 'admin', theme),
            _buildDemoButton('Developer', 'standard', theme),
            _buildDemoButton('Viewer', 'viewer', theme),
            _buildDemoButton('Buyer', 'buyer', theme),
          ],
        ),
      ],
    );
  }

  Widget _buildDemoButton(String label, String role, ThemeData theme) {
    return ElevatedButton(
      onPressed: () => _setDemoCredentials(role),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceVariant,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
      ),
      child: Text(label),
    );
  }
}
