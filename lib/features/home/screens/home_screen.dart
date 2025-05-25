import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;
import 'package:go_router/go_router.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../models/featured_property.dart';
import '../models/user_role.dart';
import '../models/stat_item.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/mobile_navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    
    // Data
    final featuredProperties = FeaturedProperty.getSampleData();
    final userRoles = UserRole.getRoles();
    final stats = StatItem.getStats();

    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(theme, isLowBandwidth),
            
            // User Roles Section
            _buildUserRolesSection(theme, userRoles),
            
            // Stats Section
            _buildStatsSection(theme, stats),
            
            // Featured Properties
            _buildFeaturedPropertiesSection(theme, featuredProperties, isLowBandwidth),
            
            // CTA Section
            _buildCtaSection(theme),
            
            // Footer
            _buildFooterSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, bool isLowBandwidth) {
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Search bar
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by location, developer, or project name...',
                      prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.colorScheme.outline),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle search
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Search'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Registration options
                  Row(
                    children: [
                      // Buyer registration button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to buyer registration
                            GoRouter.of(context).go('/buyer-register');
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Register as Buyer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Developer registration button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to developer registration
                            GoRouter.of(context).go('/register');
                          },
                          icon: const Icon(Icons.business),
                          label: const Text('Register as Developer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRolesSection(ThemeData theme, List<UserRole> userRoles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Text(
            'Tailored for Every User',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Whether you\'re developing, buying, or exploring, we have the right tools for you',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // User roles cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                // Tablet and desktop: show in a row
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: userRoles.map((role) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildUserRoleCard(theme, role),
                    ),
                  )).toList(),
                );
              } else {
                // Mobile: show in a column
                return Column(
                  children: userRoles.map((role) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildUserRoleCard(theme, role),
                  )).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserRoleCard(ThemeData theme, UserRole role) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: role.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                role.icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            
            // Role type
            Text(
              role.type,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Text(
              role.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            
            // Features
            ...role.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )).toList(),
            
            const SizedBox(height: 16),
            
            // Get started button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (role.type == "Developer") {
                    GoRouter.of(context).go('/register');
                  } else if (role.type == "Buyer") {
                    GoRouter.of(context).go('/buyer-register');
                  } else {
                    GoRouter.of(context).go('/login');
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Get Started as ${role.type}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, List<StatItem> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      color: theme.colorScheme.secondary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            // Tablet and desktop: show in a row
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats.map((stat) => _buildStatItem(theme, stat)).toList(),
            );
          } else {
            // Mobile: show in a grid
            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 16,
              runSpacing: 24,
              children: stats.map((stat) => SizedBox(
                width: constraints.maxWidth / 2 - 24,
                child: _buildStatItem(theme, stat),
              )).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, StatItem stat) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            stat.icon,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          stat.value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedPropertiesSection(ThemeData theme, List<FeaturedProperty> properties, bool isLowBandwidth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Projects',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover premium properties from top developers',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  // View all properties
                },
                icon: const Text('View All'),
                label: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Properties grid
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                // Desktop: show 3 in a row
                return _buildPropertiesGrid(theme, properties, 3, isLowBandwidth);
              } else if (constraints.maxWidth > 600) {
                // Tablet: show 2 in a row
                return _buildPropertiesGrid(theme, properties, 2, isLowBandwidth);
              } else {
                // Mobile: show 1 in a row
                return _buildPropertiesGrid(theme, properties, 1, isLowBandwidth);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesGrid(ThemeData theme, List<FeaturedProperty> properties, int crossAxisCount, bool isLowBandwidth) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(theme, property, isLowBandwidth);
      },
    );
  }

  Widget _buildPropertyCard(ThemeData theme, FeaturedProperty property, bool isLowBandwidth) {
    Color statusColor;
    if (property.status == 'Ready to Move') {
      statusColor = Colors.green;
    } else if (property.status == 'Under Construction') {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.orange;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: isLowBandwidth
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        color: theme.colorScheme.surfaceVariant,
                        child: const Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.white54,
                        ),
                      )
                    : Image.network(
                        property.image,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 150,
                          width: double.infinity,
                          color: theme.colorScheme.surfaceVariant,
                          child: const Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.white54,
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    property.status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        property.rating.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Property details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'by ${property.developer}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.price,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${property.units} units',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Completion',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          property.completion,
                          style: theme.textTheme.bodyMedium?.copyWith(
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
                      // View property details
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Start Your Property Journey?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join thousands of developers, buyers, and investors who trust DevPropertyHub',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              // For buyers
              ElevatedButton.icon(
                onPressed: () {
                  GoRouter.of(context).go('/buyer-register');
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Register as Buyer'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
              // For developers
              OutlinedButton.icon(
                onPressed: () {
                  GoRouter.of(context).go('/register');
                },
                icon: const Icon(Icons.business),
                label: const Text('Register as Developer'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      color: Colors.grey.shade900,
      child: Column(
        children: [
          // Footer content in columns
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                // Tablet and desktop: show in a row
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildFooterColumn1(theme)),
                    Expanded(child: _buildFooterColumn2(theme)),
                    Expanded(child: _buildFooterColumn3(theme)),
                    Expanded(child: _buildFooterColumn4(theme)),
                  ],
                );
              } else {
                // Mobile: show in a column
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterColumn1(theme),
                    const SizedBox(height: 32),
                    _buildFooterColumn2(theme),
                    const SizedBox(height: 32),
                    _buildFooterColumn3(theme),
                    const SizedBox(height: 32),
                    _buildFooterColumn4(theme),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 48),
          
          // Copyright
          Divider(color: Colors.grey.shade800),
          const SizedBox(height: 24),
          Text(
            '© 2025 DevPropertyHub. All rights reserved. | Privacy Policy | Terms of Service',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn1(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DevPropertyHub',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your trusted partner in property development and investment.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.facebook, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.telegram, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.link, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterColumn2(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'For Developers',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink(theme, 'List Your Project'),
        _buildFooterLink(theme, 'Marketing Tools'),
        _buildFooterLink(theme, 'Analytics'),
        _buildFooterLink(theme, 'Support'),
      ],
    );
  }

  Widget _buildFooterColumn3(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'For Buyers',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink(theme, 'Browse Properties'),
        _buildFooterLink(theme, 'Financing Options'),
        _buildFooterLink(theme, 'Property Calculator'),
        _buildFooterLink(theme, 'Buyer Guide'),
      ],
    );
  }

  Widget _buildFooterColumn4(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(theme, Icons.phone, '+1 (555) 123-4567'),
        _buildContactItem(theme, Icons.email, 'hello@devpropertyhub.com'),
        _buildContactItem(theme, Icons.location_on, '123 Business District, City'),
      ],
    );
  }

  Widget _buildFooterLink(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
