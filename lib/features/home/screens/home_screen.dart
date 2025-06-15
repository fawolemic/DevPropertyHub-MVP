import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../models/featured_property.dart';
import '../models/user_role.dart';
import '../models/stat_item.dart';
import '../widgets/home_widgets.dart';

/// HomeScreen
///
/// The main landing page of the DevPropertyHub application.
/// Composed of multiple sections that are implemented as separate components.
///
/// SEARCH TAGS: #home #landing-page #main-screen

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
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;

    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const MobileNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with headline
            HomeHeroSection(isLowBandwidth: isLowBandwidth),

            // Search container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: HomeSearchContainer(searchController: _searchController),
            ),

            // User roles section
            UserRolesSection(userRoles: UserRole.getRoles()),

            // Stats section
            StatsSection(stats: StatItem.getStats()),

            // Featured properties section
            FeaturedPropertiesSection(
              properties: FeaturedProperty.getSampleData(),
              isLowBandwidth: isLowBandwidth,
            ),

            // Call-to-action section
            const CTASection(),

            // Footer section
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  // All widget building methods have been moved to separate component files
  // This makes the code more maintainable and easier to locate
}
