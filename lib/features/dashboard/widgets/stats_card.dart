import 'package:flutter/material.dart';

// NOTE: This is a shared widget, not a dashboard screen. The legacy dashboard has been removed.
/// A modern stats card widget for use in developments and analytics screens.
///
/// Displays a key metric with title, value, subtitle, and trend indicator
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String trend;
  final bool trendUp;
  final Color color;
  final IconData icon;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.trend,
    required this.trendUp,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                // Trend indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendUp ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: trendUp
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: trendUp
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Value
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
