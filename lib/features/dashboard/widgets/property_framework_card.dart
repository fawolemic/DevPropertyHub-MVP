import 'package:flutter/material.dart';

/// A modern property framework card widget for the dashboard
/// 
/// Displays property development information with completion status
class PropertyFrameworkCard extends StatelessWidget {
  final String name;
  final String location;
  final int units;
  final int sold;
  final String revenue;
  final String status;
  final String completion;
  final Color color;

  const PropertyFrameworkCard({
    Key? key,
    required this.name,
    required this.location,
    required this.units,
    required this.sold,
    required this.revenue,
    required this.status,
    required this.completion,
    required this.color,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Ready to Move' 
                        ? Colors.green.shade50 
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: status == 'Ready to Move' 
                          ? Colors.green.shade800 
                          : Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Stats grid
            Row(
              children: [
                _buildStatItem('Units', units.toString()),
                const SizedBox(width: 16),
                _buildStatItem('Sold', sold.toString()),
                const SizedBox(width: 16),
                _buildStatItem('Revenue', revenue),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            Row(
              children: [
                Text(
                  'Completion: $completion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _parseCompletion(completion),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  double _parseCompletion(String completion) {
    // Parse percentage string like "75%" to 0.75
    try {
      final percentValue = completion.replaceAll('%', '');
      return double.parse(percentValue) / 100;
    } catch (e) {
      return 0.0;
    }
  }
}
