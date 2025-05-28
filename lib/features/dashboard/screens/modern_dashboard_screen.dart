import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/modern_sidebar.dart';

class ModernDashboardScreen extends StatefulWidget {
  const ModernDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ModernDashboardScreen> createState() => _ModernDashboardScreenState();
}

class _ModernDashboardScreenState extends State<ModernDashboardScreen> {
  bool _sidebarOpen = false;
  String _activeSection = 'dashboard';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    
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
                      final String welcomeText = isVerySmallScreen ? 'Welcome!' : 
                                               isSmallScreen ? 'Welcome!' : 'Welcome, $userName';
                      
                      // Calculate trailing widget width based on screen size
                      final trailingWidth = isVerySmallScreen ? 40 : 
                                           isSmallScreen ? 70 : 100;
                      
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
                          
                          // Welcome message - use Flexible with tight fit
                          Flexible(
                            fit: FlexFit.tight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  welcomeText,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                    fontSize: isDesktop ? 20 : 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                if (isDesktop && !isSmallScreen) // Only show subtitle on desktop
                                  Text(
                                    "Here's what's happening today",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dashboard title
                        Text(
                          'Dashboard',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Stats overview
                        GridView.count(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStatCard(
                              context,
                              'Total Developments',
                              '12',
                              Icons.business,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              context,
                              'Active Leads',
                              '48',
                              Icons.people,
                              Colors.green,
                            ),
                            _buildStatCard(
                              context,
                              'Revenue (MTD)',
                              '\$125,000',
                              Icons.attach_money,
                              Colors.orange,
                            ),
                            _buildStatCard(
                              context,
                              'Conversion Rate',
                              '24%',
                              Icons.trending_up,
                              Colors.purple,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Active frameworks section
                        _buildSectionHeader(context, 'Active Frameworks', onViewAll: () {
                          context.go('/frameworks');
                        }),
                        const SizedBox(height: 16),
                        _buildActiveFrameworks(),
                        
                        const SizedBox(height: 32),
                        
                        // Quick actions section
                        _buildSectionHeader(context, 'Quick Actions'),
                        const SizedBox(height: 16),
                        _buildQuickActions(),
                        
                        const SizedBox(height: 32),
                        
                        // Recent leads section
                        _buildSectionHeader(context, 'Recent Leads', onViewAll: () {
                          context.go('/leads');
                        }),
                        const SizedBox(height: 16),
                        _buildRecentLeads(context),
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
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Row(
              children: [
                Text(
                  'View all',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActiveFrameworks() {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isDesktop ? 2.5 : 3,
      children: [
        _buildFrameworkCard(
          'Sales Framework',
          'Active',
          Colors.green,
          'Last updated: 2 days ago',
          '12 leads in pipeline',
        ),
        _buildFrameworkCard(
          'Marketing Framework',
          'Active',
          Colors.green,
          'Last updated: 1 week ago',
          '3 campaigns running',
        ),
        _buildFrameworkCard(
          'Development Framework',
          'Pending',
          Colors.orange,
          'Last updated: 3 days ago',
          '2 projects in progress',
        ),
      ],
    );
  }

  Widget _buildFrameworkCard(
    String title,
    String status,
    Color statusColor,
    String lastUpdated,
    String description,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lastUpdated,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildActionButton(
          context,
          'Add Lead',
          Icons.person_add,
          theme.colorScheme.primary,
          () {
            context.go('/leads/add');
          },
        ),
        _buildActionButton(
          context,
          'New Development',
          Icons.business,
          Colors.blue,
          () {
            context.go('/developments/add');
          },
        ),
        _buildActionButton(
          context,
          'Schedule Meeting',
          Icons.calendar_today,
          Colors.orange,
          () {
            // Schedule meeting action
          },
        ),
        _buildActionButton(
          context,
          'Generate Report',
          Icons.bar_chart,
          Colors.purple,
          () {
            // Generate report action
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    
    return SizedBox(
      width: isDesktop ? 150 : double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentLeads(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    
    // Sample data
    final leads = [
      {
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'date': '2023-05-15',
        'status': 'New',
        'priority': 'High',
      },
      {
        'name': 'Emily Brown',
        'email': 'emily.brown@example.com',
        'date': '2023-05-14',
        'status': 'Contacted',
        'priority': 'Medium',
      },
      {
        'name': 'David Wilson',
        'email': 'david.wilson@example.com',
        'date': '2023-05-12',
        'status': 'Qualified',
        'priority': 'Low',
      },
    ];
    
    return Column(
      children: leads.map((lead) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to lead details
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar or initials
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      _getInitials(lead['name']!),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Lead info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lead['email']!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status and priority
                  if (isDesktop)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(lead['status']!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lead['status']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(lead['status']!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(lead['priority']!),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${lead['priority']} Priority',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(lead['priority']!),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    String initials = '';
    for (var part in parts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
    }
    return initials;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'Contacted':
        return Colors.orange;
      case 'Qualified':
        return Colors.purple;
      case 'Proposal':
        return Colors.teal;
      case 'Negotiation':
        return Colors.amber.shade800;
      case 'Closed Won':
        return Colors.green;
      case 'Closed Lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSectionChange(String section) {
    setState(() {
      _activeSection = section;
    });
  }
}
