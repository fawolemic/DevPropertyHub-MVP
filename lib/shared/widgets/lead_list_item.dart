import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeadListItem extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String development;
  final String status;
  final String date;
  final bool isLowBandwidth;
  final bool canEdit;

  const LeadListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.email,
    required this.development,
    required this.status,
    required this.date,
    required this.isLowBandwidth,
    required this.canEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => context.push('/leads/$id'),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: _getAvatarColor(name, theme),
              radius: 24,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Lead info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: theme.textTheme.bodySmall,
                  ),
                  if (!isLowBandwidth) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 14,
                          color: theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          development,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Status & Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status, theme).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status, theme),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (canEdit && !isLowBandwidth) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit action
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        splashRadius: 20,
                        tooltip: 'Edit',
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                      ),
                      
                      // Delete action (for Admin only)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        splashRadius: 20,
                        tooltip: 'Delete',
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper to get status color
  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'new lead':
        return Colors.orange;
      case 'contacted':
        return theme.colorScheme.primary;
      case 'interested':
        return theme.colorScheme.secondary;
      case 'converted':
        return Colors.purple;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
  
  // Generate a consistent avatar color based on name
  Color _getAvatarColor(String name, ThemeData theme) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      Colors.deepOrange,
      Colors.purple,
      Colors.teal,
    ];
    
    // Use the name to generate a consistent index
    final index = name.length % colors.length;
    return colors[index];
  }
}
