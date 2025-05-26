import 'package:flutter/material.dart';
import 'package:devpropertyhub/features/auth/widgets/components/validation/password_validator.dart';

/// PasswordStrengthIndicator
/// 
/// Visual component that displays password strength.
/// Shows a progress bar and text description of strength level.
/// 
/// SEARCH TAGS: #auth #validation #password #security #indicator
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strength = PasswordValidator.calculateStrength(password);
    final color = PasswordValidator.getStrengthColor(strength);
    final text = PasswordValidator.getStrengthText(strength);
    
    // Don't show for empty passwords
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Progress indicator
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (strength + 1) / 5,
            backgroundColor: theme.colorScheme.surfaceVariant,
            color: color,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        // Strength text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength: $text',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (strength < 3)
              Text(
                'Make it stronger',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
          ],
        ),
        if (strength < 3) ...[
          const SizedBox(height: 8),
          // Password tips
          _buildPasswordTips(theme),
        ],
      ],
    );
  }
  
  Widget _buildPasswordTips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips for a strong password:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          _buildTipItem(theme, 'Use at least 8 characters', !password.isEmpty && password.length >= 8),
          _buildTipItem(theme, 'Include uppercase letters (A-Z)', _containsUppercase(password)),
          _buildTipItem(theme, 'Include numbers (0-9)', _containsDigit(password)),
          _buildTipItem(theme, 'Include special characters (!@#\$)', _containsSpecialChar(password)),
        ],
      ),
    );
  }
  
  Widget _buildTipItem(ThemeData theme, String text, bool isSatisfied) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            isSatisfied ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isSatisfied ? Colors.green : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods to check password requirements
  bool _containsUppercase(String value) => 
      value.contains(RegExp(r'[A-Z]'));
  
  bool _containsDigit(String value) => 
      value.contains(RegExp(r'[0-9]'));
  
  bool _containsSpecialChar(String value) => 
      value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}
