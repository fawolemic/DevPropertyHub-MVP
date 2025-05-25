import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../models/featured_property.dart';
import '../models/user_role.dart';
import '../models/stat_item.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/mobile_navigation_drawer.dart';
import '../../../shared/widgets/version_indicator.dart';

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
    
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(theme, isLowBandwidth),
            _buildUserRolesSection(theme, UserRole.getRoles()),
            _buildStatsSection(theme, StatItem.getStats()),
            _buildFeaturedPropertiesSection(theme, FeaturedProperty.getFeaturedProperties(), isLowBandwidth),
            _buildCtaSection(theme),
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Removed registration buttons - replaced with spacer
                const SizedBox(height: 16),
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
                  // Removed registration options - replaced with empty spacer
                  const SizedBox(height: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rest of the class implementation...
  // Add placeholder methods for the other sections mentioned in build()
  Widget _buildUserRolesSection(ThemeData theme, List<UserRole> userRoles) {
    // Implementation details...
    return Container(); // Simplified for this example
  }
  
  Widget _buildStatsSection(ThemeData theme, List<StatItem> stats) {
    // Implementation details...
    return Container(); // Simplified for this example
  }
  
  Widget _buildFeaturedPropertiesSection(ThemeData theme, List<FeaturedProperty> properties, bool isLowBandwidth) {
    // Implementation details...
    return Container(); // Simplified for this example
  }
  
  Widget _buildCtaSection(ThemeData theme) {
    // Implementation details...
    return Container(); // Simplified for this example
  }
  
  Widget _buildFooterSection(ThemeData theme) {
    // Implementation details...
    return Container(); // Simplified for this example
  }
}
