import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../dashboard/widgets/modern_sidebar.dart';
import '../../dashboard/widgets/property_framework_card.dart';

class ModernDevelopmentsScreen extends StatefulWidget {
  const ModernDevelopmentsScreen({Key? key}) : super(key: key);

  @override
  State<ModernDevelopmentsScreen> createState() => _ModernDevelopmentsScreenState();
}

class _ModernDevelopmentsScreenState extends State<ModernDevelopmentsScreen> {
  bool _sidebarOpen = false;
  String _activeSection = 'properties';
  
  // Sample data for developments
  final List<Map<String, dynamic>> _developments = [
    {
      'name': 'Target Heights',
      'location': 'Downtown District',
      'units': 45,
      'sold': 23,
      'revenue': '\$1.2M',
      'status': 'Under Construction',
      'completion': '75%',
      'color': Colors.red,
    },
    {
      'name': 'Prop Developers',
      'location': 'Marina Bay',
      'units': 78,
      'sold': 56,
      'revenue': '\$2.8M',
      'status': 'Ready to Move',
      'completion': '100%',
      'color': Colors.blue,
    },
    {
      'name': 'Skyline Towers',
      'location': 'Business District',
      'units': 120,
      'sold': 42,
      'revenue': '\$3.5M',
      'status': 'Under Construction',
      'completion': '60%',
      'color': Colors.green,
    },
    {
      'name': 'Harbor View',
      'location': 'Waterfront Area',
      'units': 65,
      'sold': 38,
      'revenue': '\$2.1M',
      'status': 'Ready to Move',
      'completion': '100%',
      'color': Colors.purple,
    },
  ];
  
  // Handle section changes with actual navigation
  void _handleSectionChange(String section) {
    setState(() {
      _activeSection = section;
    });
    
    // Map section to route using GoRouter
    switch (section) {
      case 'overview':
        context.go('/dashboard');
        break;
      case 'properties':
        context.go('/developments');
        break;
      case 'leads':
        context.go('/leads');
        break;
      case 'analytics':
        context.go('/dashboard');
        debugPrint('Analytics section selected - route not implemented yet');
        break;
      case 'documents':
        context.go('/dashboard');
        debugPrint('Documents section selected - route not implemented yet');
        break;
      case 'settings':
        context.go('/settings');
        break;
      default:
        context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);
    
    // Get user info
    final userName = authProvider.userName ?? 'Admin User';
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Row(
        children: [
          // Sidebar - only visible on desktop or when opened on mobile
          if (isDesktop || _sidebarOpen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 256,
              child: ModernSidebar(
                activeSection: _activeSection,
                onSectionChanged: _handleSectionChange,
                isMobile: !isDesktop,
                onClose: isDesktop ? null : () {
                  setState(() {
                    _sidebarOpen = false;
                  });
                },
              ),
            ),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // App bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Menu button (mobile only)
                      if (!isDesktop)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              _sidebarOpen = true;
                            });
                          },
                          color: Colors.grey.shade700,
                        ),
                      
                      // Page title
                      Expanded(
                        child: Text(
                          'Developments',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      
                      // Search bar
                      if (isDesktop)
                        Container(
                          width: 240,
                          height: 40,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search developments...',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      
                      // Notification bell
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {},
                            color: Colors.grey.shade700,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // User profile
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: theme.colorScheme.primary,
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout, size: 16),
                            onPressed: () {
                              // Logout action
                              authProvider.signOut();
                              context.go('/login');
                            },
                            color: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: ResponsiveUtils.getResponsivePadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with add button
                        ResponsiveUtils.isMobile(context)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'All Developments',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to add development screen
                                      context.go('/developments/add');
                                    },
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add Development'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Developments',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigate to add development screen
                                    context.go('/developments/add');
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Development'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        
                        const SizedBox(height: 24),
                        
                        // Filter and sort options
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context)),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveUtils.isMobile(context) ? 12 : 16),
                            child: ResponsiveUtils.isMobile(context)
                              ? Column(
                                  children: [
                                    // Status filter
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Status',
                                        border: const OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: ResponsiveUtils.isMobile(context) ? 4 : 8),
                                        isDense: ResponsiveUtils.isMobile(context),
                                      ),
                                      value: 'All',
                                      items: const [
                                        DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                                        DropdownMenuItem(value: 'Under Construction', child: Text('Under Construction')),
                                        DropdownMenuItem(value: 'Ready to Move', child: Text('Ready to Move')),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // Location filter
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Location',
                                        border: const OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: ResponsiveUtils.isMobile(context) ? 4 : 8),
                                        isDense: ResponsiveUtils.isMobile(context),
                                      ),
                                      value: 'All',
                                      items: const [
                                        DropdownMenuItem(value: 'All', child: Text('All Locations')),
                                        DropdownMenuItem(value: 'Downtown', child: Text('Downtown')),
                                        DropdownMenuItem(value: 'Marina', child: Text('Marina')),
                                        DropdownMenuItem(value: 'Business', child: Text('Business District')),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // Sort option
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Sort By',
                                        border: const OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: ResponsiveUtils.isMobile(context) ? 4 : 8),
                                        isDense: ResponsiveUtils.isMobile(context),
                                      ),
                                      value: 'Name',
                                      items: const [
                                        DropdownMenuItem(value: 'Name', child: Text('Name')),
                                        DropdownMenuItem(value: 'Units', child: Text('Units')),
                                        DropdownMenuItem(value: 'Revenue', child: Text('Revenue')),
                                        DropdownMenuItem(value: 'Completion', child: Text('Completion')),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    // Status filter
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          labelText: 'Status',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        value: 'All',
                                        items: const [
                                          DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                                          DropdownMenuItem(value: 'Under Construction', child: Text('Under Construction')),
                                          DropdownMenuItem(value: 'Ready to Move', child: Text('Ready to Move')),
                                        ],
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // Location filter
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          labelText: 'Location',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        value: 'All',
                                        items: const [
                                          DropdownMenuItem(value: 'All', child: Text('All Locations')),
                                          DropdownMenuItem(value: 'Downtown', child: Text('Downtown')),
                                          DropdownMenuItem(value: 'Marina', child: Text('Marina')),
                                          DropdownMenuItem(value: 'Business', child: Text('Business District')),
                                        ],
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // Sort option
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          labelText: 'Sort By',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        value: 'Name',
                                        items: const [
                                          DropdownMenuItem(value: 'Name', child: Text('Name')),
                                          DropdownMenuItem(value: 'Units', child: Text('Units')),
                                          DropdownMenuItem(value: 'Revenue', child: Text('Revenue')),
                                          DropdownMenuItem(value: 'Completion', child: Text('Completion')),
                                        ],
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Developments grid
                        ResponsiveUtils.isMobile(context)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _developments.length,
                              itemBuilder: (context, index) {
                                final development = _developments[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: PropertyFrameworkCard(
                                    name: development['name'],
                                    location: development['location'],
                                    units: development['units'],
                                    sold: development['sold'],
                                    revenue: development['revenue'],
                                    status: development['status'],
                                    completion: development['completion'],
                                    color: development['color'],
                                  ),
                                );
                              },
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: ResponsiveUtils.isDesktop(context) ? 2 : 1,
                                crossAxisSpacing: ResponsiveUtils.isDesktop(context) ? 24 : 16,
                                mainAxisSpacing: ResponsiveUtils.isDesktop(context) ? 24 : 16,
                                childAspectRatio: ResponsiveUtils.isDesktop(context) ? 2 : 1.5,
                              ),
                              itemCount: _developments.length,
                              itemBuilder: (context, index) {
                                final development = _developments[index];
                                return PropertyFrameworkCard(
                                  name: development['name'],
                                  location: development['location'],
                                  units: development['units'],
                                  sold: development['sold'],
                                  revenue: development['revenue'],
                                  status: development['status'],
                                  completion: development['completion'],
                                  color: development['color'],
                                );
                              },
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
}
