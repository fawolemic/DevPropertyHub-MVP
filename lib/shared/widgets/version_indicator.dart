import 'package:flutter/material.dart';

/// A widget that displays the current version of the application
/// with a timestamp to help verify deployment updates.
class VersionIndicator extends StatelessWidget {
  const VersionIndicator({super.key});

  // This string will be different each time you deploy
  static const String deployTimestamp = '2025-05-25T17:05:00';
  static const String versionLabel = 'v1.0.0-unified-registration';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$versionLabel ($deployTimestamp)',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
