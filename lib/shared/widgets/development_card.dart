import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevelopmentCard extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String status;
  final int units;
  final double progress;
  final String imageUrl;
  final bool isLowBandwidth;

  const DevelopmentCard({
    Key? key,
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.units,
    required this.progress,
    required this.imageUrl,
    required this.isLowBandwidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isLowBandwidth ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isLowBandwidth ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/developments/$id'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Development Image
            Stack(
              children: [
                if (isLowBandwidth)
                  Container(
                    height: 100,
                    color: _getColorForName(name),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.business,
                      size: 48,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )
                else
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: _getColorForName(name),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      ),
                    ),
                  ),
                
                // Status badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status, theme),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Development details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Units info
                  Row(
                    children: [
                      Icon(
                        Icons.apartment,
                        size: 16,
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$units Units',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper to get status color
  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'active':
        return theme.colorScheme.secondary;
      case 'scheduled':
        return theme.colorScheme.primary;
      case 'completed':
        return Colors.grey;
      case 'on hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  // Generate a consistent color based on development name
  Color _getColorForName(String name) {
    final colors = [
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFF57C00), // Orange
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFD32F2F), // Red
    ];
    
    // Use the name to generate a consistent index
    final index = name.length % colors.length;
    return colors[index];
  }
}
