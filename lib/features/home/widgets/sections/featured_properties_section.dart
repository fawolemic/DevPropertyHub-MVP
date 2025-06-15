import 'package:flutter/material.dart';
import '../../models/featured_property.dart';

/// FeaturedPropertiesSection
///
/// Displays a carousel of featured properties and developments.
/// Contains: Property cards with images, titles, and key details.
/// Supports low-bandwidth mode for optimized performance.
///
/// SEARCH TAGS: #featured #properties #carousel #property-listings
class FeaturedPropertiesSection extends StatelessWidget {
  final List<FeaturedProperty> properties;
  final bool isLowBandwidth;

  const FeaturedPropertiesSection({
    Key? key,
    required this.properties,
    required this.isLowBandwidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Properties',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exclusive development opportunities',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all properties
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return Container(
                  width: screenWidth > 600 ? 300 : screenWidth * 0.8,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property image with optimized loading for bandwidth
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: isLowBandwidth
                              ? Container(
                                  color: theme.colorScheme.surfaceVariant,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 48,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  property.image,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: theme.colorScheme.surfaceVariant,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                property.location,
                                style: theme.textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onBackground
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      Text(
                                        property.price,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Returns',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onBackground
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      Text(
                                        '${property.rating}/5',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to property details
                                  },
                                  child: const Text('View Details'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
