import 'package:flutter/material.dart';

// NOTE: This is a shared widget, not a dashboard screen. The legacy dashboard has been removed.
/// A modern quick action button widget for use in various screens.
/// 
/// Displays a large button with icon and label for common actions
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color hoverColor;
  final VoidCallback onPressed;

  const QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.hoverColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      hoverColor: hoverColor.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade200,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
