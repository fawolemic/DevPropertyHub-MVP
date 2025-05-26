import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
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
                onSectionChanged: (section) {
                  setState(() {
                    _activeSection = section;
                  });
                },
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
                      
                      // Welcome message
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, $userName',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            Text(
                              "Here's what's happening with your properties today",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats cards
                        GridView.count(
                          crossAxisCount: isDesktop ? 3 : (mediaQuery.size.width > 600 ? 2 : 1),
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          shrinkWrap: true,
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
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Active Frameworks
                              Expanded(
                                child: _buildActiveFrameworks(),
                              ),
                              
                              const SizedBox(width: 24),
                              
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
                              const SizedBox(height: 24),
                              _buildQuickActions(),
                            ],
                          ),
                        
                        const SizedBox(height: 32),
                        
                        // Recent Leads
                        _buildRecentLeads(),
                        
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
  
  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        if (onViewAll != null)
          TextButton.icon(
            onPressed: onViewAll,
            icon: const Text('View All'),
            label: const Icon(
              Icons.chevron_right,
              size: 16,
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildActiveFrameworks() {
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
            _buildSectionHeader(
              'Active Frameworks',
              onViewAll: () => context.push('/developments'),
            ),
            const SizedBox(height: 24),
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
            _buildSectionHeader('Quick Actions'),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                QuickActionButton(
                  icon: Icons.add,
                  label: 'Add Property',
                  hoverColor: Colors.blue,
                  onPressed: () => context.push('/add-property'),
                ),
                QuickActionButton(
                  icon: Icons.download,
                  label: 'Export Report',
                  hoverColor: Colors.green,
                  onPressed: () {},
                ),
                QuickActionButton(
                  icon: Icons.bar_chart,
                  label: 'View Analytics',
                  hoverColor: Colors.purple,
                  onPressed: () => context.push('/analytics'),
                ),
                QuickActionButton(
                  icon: Icons.refresh,
                  label: 'Sync Data',
                  hoverColor: Colors.orange,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentLeads() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(
                  'Recent Leads',
                  onViewAll: () => context.push('/leads'),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                  color: Colors.grey.shade500,
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 24),
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
}
