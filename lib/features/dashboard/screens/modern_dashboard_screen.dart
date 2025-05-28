import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/responsive_utils.dart';
import '../widgets/stats_card.dart';
import '../widgets/property_framework_card.dart';
import '../widgets/lead_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/modern_sidebar.dart';

class ModernDashboardScreen extends StatefulWidget {
  const ModernDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen> {
  bool _sidebarOpen = false;
  String _activeSection = 'overview';

  // Sample data for the dashboard
  final List<Map<String, dynamic>> _statsCards = [
    {
      'title': 'Total Properties',
      'value': '5',
      'subtitle': 'Active Developments',
      'trend': '+12%',
      'trendUp': true,
      'color': Colors.blue,
      'icon': Icons.business,
    },
    {
      'title': 'Enquiries',
      'value': '43',
      'subtitle': 'This Month',
      'trend': '+28%',
      'trendUp': true,
      'color': Colors.orange,
      'icon': Icons.people,
    },
    {
      'title': 'Revenue',
      'value': '\$2.4M',
      'subtitle': 'Total Sales',
      'trend': '+15%',
      'trendUp': true,
      'color': Colors.green,
      'icon': Icons.attach_money,
    },
  ];

  final List<Map<String, dynamic>> _activeFrameworks = [
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
  ];

  final List<Map<String, dynamic>> _recentLeads = [
    {
      'id': 1,
      'name': 'John Smith',
      'email': 'john.smith@email.com',
      'property': 'Target Heights - Unit 2A',
      'budget': '\$850K',
      'status': 'Hot Lead',
      'time': '2 hours ago',
      'priority': 'high',
    },
    {
      'id': 2,
      'name': 'Sarah Johnson',
      'email': 'sarah.j@email.com',
      'property': 'Prop Developers - Unit 5B',
      'budget': '\$1.2M',
      'status': 'Interested',
      'time': '5 hours ago',
      'priority': 'medium',
    },
    {
      'id': 3,
      'name': 'Mike Thompson',
      'email': 'mike.t@email.com',
      'property': 'Target Heights - Unit 1C',
      'budget': '\$750K',
      'status': 'Viewing Scheduled',
      'time': '1 day ago',
      'priority': 'low',
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
        // If you don't have these routes yet, you can keep them local or create placeholder screens
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
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width >= 1024;
    
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
                onSectionChanged: _handleSectionChange, // Use the new navigation handler
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
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              setState(() {
                                _sidebarOpen = true;
                              });
                            },
                            color: Colors.grey.shade700,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      
                      const SizedBox(width: 4), // Small spacing
                      
                      // Welcome message
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // Abbreviate greeting on very small screens
                              MediaQuery.of(context).size.width < 360 
                                ? 'Welcome!' 
                                : 'Welcome, $userName',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                                fontSize: isDesktop ? 20 : 18, // Smaller on mobile
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            if (isDesktop) // Only show subtitle on desktop
                              Text(
                                "Here's what's happening with your properties today",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8), // Push trailing widgets to the right
                      
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
                              hintText: 'Search...',
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
                
                // Dashboard content
                Expanded(
                  child: SingleChildScrollView(
                    padding: ResponsiveUtils.getResponsivePadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats cards
                        GridView.count(
                          crossAxisCount: ResponsiveUtils.getResponsiveGridCount(context),
                          crossAxisSpacing: ResponsiveUtils.isMobile(context) ? 12 : 24,
                          mainAxisSpacing: ResponsiveUtils.isMobile(context) ? 12 : 24,
                          shrinkWrap: true,
                          childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.2 : 1.0,
                          physics: const NeverScrollableScrollPhysics(),
                          children: _statsCards.map((card) {
                            return StatsCard(
                              title: card['title'],
                              value: card['value'],
                              subtitle: card['subtitle'],
                              trend: card['trend'],
                              trendUp: card['trendUp'],
                              color: card['color'],
                              icon: card['icon'],
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Active Frameworks and Quick Actions
                        if (ResponsiveUtils.isDesktop(context))
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Active Frameworks
                              Expanded(
                                child: _buildActiveFrameworks(),
                              ),
                              
                              SizedBox(width: ResponsiveUtils.isMobile(context) ? 12 : 24),
                              
                              // Quick Actions
                              Expanded(
                                child: _buildQuickActions(),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildActiveFrameworks(),
                              SizedBox(height: ResponsiveUtils.isMobile(context) ? 16 : 24),
                              _buildQuickActions(),
                            ],
                          ),
                        
                        const SizedBox(height: 32),
                        
                        // Recent Leads
                        _buildRecentLeads(context),
                        
                        const SizedBox(height: 32),
                        
                        // Authentication Testing Section
                        _buildAuthTestingSection(),
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
  
  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onViewAll}) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 16 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        if (onViewAll != null)
          TextButton.icon(
            onPressed: onViewAll,
            icon: Text('View All', style: TextStyle(fontSize: isMobile ? 12 : 14)),
            label: Icon(
              Icons.chevron_right,
              size: isMobile ? 14 : 16,
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 14,
              ),
              padding: isMobile ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4) : null,
            ),
          ),
      ],
    );
  }
  
  Widget _buildActiveFrameworks() {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              'Active Frameworks',
              onViewAll: () => context.push('/developments'),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            if (isMobile)
              // For mobile, use horizontal scrolling list
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activeFrameworks.length,
                  itemBuilder: (context, index) {
                    final framework = _activeFrameworks[index];
                    return Container(
                      width: ResponsiveUtils.getResponsiveCardWidth(context),
                      margin: const EdgeInsets.only(right: 12),
                      child: PropertyFrameworkCard(
                        name: framework['name'],
                        location: framework['location'],
                        units: framework['units'],
                        sold: framework['sold'],
                        revenue: framework['revenue'],
                        status: framework['status'],
                        completion: framework['completion'],
                        color: framework['color'],
                      ),
                    );
                  },
                ),
              )
            else
              // For desktop/tablet, use vertical list
              ...List.generate(_activeFrameworks.length, (index) {
                final framework = _activeFrameworks[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index < _activeFrameworks.length - 1 ? 16 : 0),
                  child: PropertyFrameworkCard(
                    name: framework['name'],
                    location: framework['location'],
                    units: framework['units'],
                    sold: framework['sold'],
                    revenue: framework['revenue'],
                    status: framework['status'],
                    completion: framework['completion'],
                    color: framework['color'],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActions() {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Quick Actions'),
            SizedBox(height: isMobile ? 16 : 24),
            GridView.count(
              crossAxisCount: isMobile ? 2 : 2,
              crossAxisSpacing: isMobile ? 8 : 16,
              mainAxisSpacing: isMobile ? 8 : 16,
              shrinkWrap: true,
              childAspectRatio: isMobile ? 0.8 : 1.0, // Taller buttons on mobile
              physics: const NeverScrollableScrollPhysics(),
              children: [
                QuickActionButton(
                  icon: Icons.add,
                  label: 'Add Property',
                  hoverColor: Colors.blue,
                  onPressed: () => context.go('/developments/add'),
                ),
                QuickActionButton(
                  icon: Icons.download,
                  label: 'Export Report',
                  hoverColor: Colors.green,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting report...')),
                    );
                  },
                ),
                QuickActionButton(
                  icon: Icons.bar_chart,
                  label: 'View Analytics',
                  hoverColor: Colors.purple,
                  onPressed: () => _handleSectionChange('analytics'),
                ),
                QuickActionButton(
                  icon: Icons.refresh,
                  label: 'Sync Data',
                  hoverColor: Colors.orange,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Syncing data...')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentLeads(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildSectionHeader(
                    context,
                    'Recent Leads',
                    onViewAll: () => context.push('/leads'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                  color: Colors.grey.shade500,
                  iconSize: isMobile ? 18 : 20,
                  padding: isMobile ? EdgeInsets.zero : null,
                  constraints: isMobile ? const BoxConstraints(minWidth: 36, minHeight: 36) : null,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 16 : 24),
            if (isMobile)
              // For mobile, use a more compact lead card layout
              ...List.generate(_recentLeads.length, (index) {
                final lead = _recentLeads[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        _getInitials(lead['name']),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text(
                      lead['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lead['property'], style: const TextStyle(fontSize: 12)),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(lead['priority']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                lead['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getPriorityColor(lead['priority']),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              lead['budget'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => context.push('/leads'),
                  ),
                );
              })
            else
              // For desktop/tablet, use the full lead card
              ...List.generate(_recentLeads.length, (index) {
                final lead = _recentLeads[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index < _recentLeads.length - 1 ? 16 : 0),
                  child: LeadCard(
                    id: lead['id'],
                    name: lead['name'],
                    email: lead['email'],
                    property: lead['property'],
                    budget: lead['budget'],
                    status: lead['status'],
                    time: lead['time'],
                    priority: lead['priority'],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
  
  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return '';
  }
  
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red.shade800;
      case 'medium':
        return Colors.orange.shade800;
      case 'low':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
  }
  
  Widget _buildAuthTestingSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Authentication Testing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Test your API authentication and view system logs',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Run auth test
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Run Auth Test',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    // View system logs
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View System Logs',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
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
