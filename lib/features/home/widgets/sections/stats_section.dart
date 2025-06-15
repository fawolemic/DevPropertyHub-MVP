import 'package:flutter/material.dart';
import '../../models/stat_item.dart';

/// StatsSection
///
/// Displays key statistics and metrics about the platform.
/// Contains: Animated counters with labels in a responsive grid layout.
///
/// SEARCH TAGS: #stats #metrics #counters #platform-statistics
class StatsSection extends StatelessWidget {
  final List<StatItem> stats;

  const StatsSection({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive layout adjustments
    final int crossAxisCount =
        screenWidth > 1100 ? 4 : (screenWidth > 700 ? 2 : 1);

    return Container(
      color: theme.colorScheme.primaryContainer.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Text(
            'Our Platform in Numbers',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Card(
                elevation: 0,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat.value,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
