import 'package:flutter/material.dart';

/// HomeHeroSection
/// 
/// The main hero banner displayed at the top of the home page.
/// Contains: Main headline, subtitle, and primary content.
/// 
/// SEARCH TAGS: #home #hero #banner #headline #property
class HomeHeroSection extends StatelessWidget {
  final bool isLowBandwidth;

  const HomeHeroSection({
    Key? key,
    required this.isLowBandwidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.secondary,
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          // Title and subtitle
          Center(
            child: Column(
              children: [
                Text(
                  'Your Gateway to Premium',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Property Development',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect developers, buyers, and investors in one comprehensive marketplace',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Intentionally removed registration buttons
                // Only using a spacer as per requirements
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
