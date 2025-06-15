import 'package:flutter/material.dart';

// NOTE: This is a shared widget, not a dashboard screen. The legacy dashboard has been removed.
/// A modern lead card widget for use in developments and leads screens.
///
/// Displays information about a lead with priority indicators
class LeadCard extends StatelessWidget {
  final int id;
  final String name;
  final String email;
  final String property;
  final String budget;
  final String status;
  final String time;
  final String priority;

  const LeadCard({
    Key? key,
    required this.id,
    required this.name,
    required this.email,
    required this.property,
    required this.budget,
    required this.status,
    required this.time,
    required this.priority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar with initials
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  _getInitials(name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Lead information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Budget and time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  budget,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(priority),
                ),
              ),
            ),

            // More options button
            IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 16,
                color: Colors.grey.shade400,
              ),
              onPressed: () {
                // Show options menu
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade800;
      case 'medium':
        return Colors.orange.shade800;
      case 'low':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
}
