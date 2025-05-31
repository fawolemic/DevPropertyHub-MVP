import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import 'add_project/add_project_wizard.dart';

class ModernDevelopmentsScreen extends StatefulWidget {
  const ModernDevelopmentsScreen({Key? key}) : super(key: key);

  @override
  State<ModernDevelopmentsScreen> createState() => _ModernDevelopmentsScreenState();
}

class _ModernDevelopmentsScreenState extends State<ModernDevelopmentsScreen> {
  bool _sidebarOpen = false;
  String _currentSection = 'all';

  // Sample data for developments
  final List<Map<String, dynamic>> _developments = [
    {
      'id': 'd1',
      'name': 'Target Heights',
      'location': 'Downtown District',
      'status': 'Under Construction',
      'units': 45,
      'sold': 23,
      'revenue': '\$1.2M',
      'completion': 0.75,
      'progressColor': Colors.red,
    },
    {
      'id': 'd2',
      'name': 'Prop Developers',
      'location': 'Marina Bay',
      'status': 'Ready to Move',
      'units': 78,
      'sold': 56,
      'revenue': '\$2.8M',
      'completion': 1.0,
      'progressColor': Colors.green,
    },
    {
      'id': 'd3',
      'name': 'Skyline Towers',
      'location': 'Business District',
      'status': 'Planning',
      'units': 120,
      'sold': 0,
      'revenue': '\$0',
      'completion': 0.1,
      'progressColor': Colors.blue,
    },
    {
      'id': 'd4',
      'name': 'Riverside Apartments',
      'location': 'Riverside',
      'status': 'Under Construction',
      'units': 64,
      'sold': 32,
      'revenue': '\$1.6M',
      'completion': 0.5,
      'progressColor': Colors.orange,
    },
  ];

  void _handleSectionChange(String section) {
    setState(() {
      _currentSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.firstName ?? 'User';
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: !isDesktop && _sidebarOpen
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                    ),
                    child: const Text(
                      'DevPropertyHub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Developments'),
                    selected: true,
                    onTap: () {
                      Navigator.pop(context);
                      // Stay on developments screen
                      // No navigation needed as we're already on the developments screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Developments'),
                    selected: true,
                    selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/developments');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Leads'),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/leads');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/settings');
                    },
                  ),
                ],
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar for desktop
          if (isDesktop)
            Container(
              width: 250,
              color: Colors.white,
              child: Column(
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 64,
                    child: Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DevPropertyHub',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Navigation items
                  _buildNavItem(context, 'Developments', Icons.business, '/developments', isActive: true),
                  _buildNavItem(context, 'Leads', Icons.people, '/leads'),
                  _buildNavItem(context, 'Settings', Icons.settings, '/settings'),
                ],
              ),
            ),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar with robust layout
                Container(
                  height: 64,
                  padding: EdgeInsets.symmetric(
                    // Use smaller padding on mobile
                    horizontal: isDesktop ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine screen size categories
                      final screenWidth = constraints.maxWidth;
                      final isVerySmallScreen = screenWidth < 320;
                      final isSmallScreen = screenWidth < 375;
                      
                      // Choose appropriate title based on available width
                      final String title = isVerySmallScreen ? 'Devs' : 
                                          isSmallScreen ? 'Devs' : 'Developments';
                      
                      // Calculate trailing widget width based on screen size
                      final double trailingWidth = isVerySmallScreen ? 40.0 : 
                                           isSmallScreen ? 70.0 : 100.0;
                      
                      return Row(
                        children: [
                          // Menu button (mobile only) - fixed width
                          if (!isDesktop)
                            SizedBox(
                              width: 32, // Even smaller fixed width
                              child: IconButton(
                                icon: const Icon(Icons.menu, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _sidebarOpen = true;
                                  });
                                },
                                color: Colors.grey.shade700,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            )
                          else
                            const SizedBox(width: 4),
                          
                          const SizedBox(width: 4), // Small spacing
                          
                          // Title - use Flexible with tight fit
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                                fontSize: isDesktop ? 20 : 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          
                          const SizedBox(width: 4), // Small spacing
                          
                          // Trailing widgets in fixed-width container
                          SizedBox(
                            width: trailingWidth, // Fixed width for trailing widgets
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // On very small screens, just show user icon
                                if (!isVerySmallScreen && !isSmallScreen) ...[                                  
                                  // Search icon - only on medium+ screens
                                  IconButton(
                                    icon: const Icon(Icons.search, size: 18),
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                
                                // Always show user icon
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                // Main content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top section with filters and add button
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'All Developments',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isDesktop)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add Development'),
                                onPressed: () {
                                  // Use GoRouter for navigation - better for web
                                  context.go('/developments/add');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              )
                            else
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  // Use GoRouter for navigation - better for web
                                  context.go('/developments/add');
                                },
                                color: theme.colorScheme.primary,
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Filters
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            // Status filter
                            Container(
                              width: isDesktop ? 200 : double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'All Statuses',
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items: [
                                    'All Statuses',
                                    'Under Construction',
                                    'Ready to Move',
                                    'Planning',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {},
                                ),
                              ),
                            ),
                            
                            // Location filter
                            Container(
                              width: isDesktop ? 200 : double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'All Locations',
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items: [
                                    'All Locations',
                                    'Downtown District',
                                    'Marina Bay',
                                    'Business District',
                                    'Riverside',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {},
                                ),
                              ),
                            ),
                            
                            // Sort by
                            Container(
                              width: isDesktop ? 200 : double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'Name',
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items: [
                                    'Name',
                                    'Status',
                                    'Location',
                                    'Units',
                                    'Revenue',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Developments list
                        Expanded(
                          child: isDesktop
                              ? GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.5,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: _developments.length,
                                  itemBuilder: (context, index) {
                                    final development = _developments[index];
                                    return _buildDevelopmentCard(context, development);
                                  },
                                )
                              : ListView.builder(
                                  itemCount: _developments.length,
                                  itemBuilder: (context, index) {
                                    final development = _developments[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: _buildDevelopmentCard(context, development),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route, {bool isActive = false}) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        context.go(route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isActive ? theme.colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? theme.colorScheme.primary : Colors.grey.shade700,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isActive ? theme.colorScheme.primary : Colors.grey.shade700,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentCard(BuildContext context, Map<String, dynamic> development) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.go('/developments/${development['id']}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    development['name'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: development['status'] == 'Under Construction'
                          ? Colors.blue.shade50
                          : development['status'] == 'Ready to Move'
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      development['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: development['status'] == 'Under Construction'
                            ? Colors.blue.shade700
                            : development['status'] == 'Ready to Move'
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    development['location'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat('Units', development['units'].toString()),
                  _buildStat('Sold', development['sold'].toString()),
                  _buildStat('Revenue', development['revenue']),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Completion: ${(development['completion'] * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: development['completion'],
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(development['progressColor']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
