import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/app_sidebar.dart';

class ModernLeadsScreen extends StatefulWidget {
  const ModernLeadsScreen({Key? key}) : super(key: key);

  @override
  State<ModernLeadsScreen> createState() => _ModernLeadsScreenState();
}

class _ModernLeadsScreenState extends State<ModernLeadsScreen> {
  // Sample data for leads
  final List<Map<String, dynamic>> _leads = [
    {
      'id': 'l1',
      'name': 'John Smith',
      'email': 'john.smith@example.com',
      'phone': '+1 (123) 456-7890',
      'status': 'New',
      'source': 'Website',
      'date': '2023-05-15',
      'priority': 'High',
      'assigned': 'Sarah Johnson',
    },
    {
      'id': 'l2',
      'name': 'Emily Brown',
      'email': 'emily.brown@example.com',
      'phone': '+1 (234) 567-8901',
      'status': 'Contacted',
      'source': 'Referral',
      'date': '2023-05-14',
      'priority': 'Medium',
      'assigned': 'Michael Davis',
    },
    {
      'id': 'l3',
      'name': 'David Wilson',
      'email': 'david.wilson@example.com',
      'phone': '+1 (345) 678-9012',
      'status': 'Qualified',
      'source': 'Social Media',
      'date': '2023-05-12',
      'priority': 'Low',
      'assigned': 'Sarah Johnson',
    },
    {
      'id': 'l4',
      'name': 'Sophia Martinez',
      'email': 'sophia.martinez@example.com',
      'phone': '+1 (456) 789-0123',
      'status': 'Proposal',
      'source': 'Website',
      'date': '2023-05-10',
      'priority': 'High',
      'assigned': 'Michael Davis',
    },
    {
      'id': 'l5',
      'name': 'James Johnson',
      'email': 'james.johnson@example.com',
      'phone': '+1 (567) 890-1234',
      'status': 'Negotiation',
      'source': 'Event',
      'date': '2023-05-08',
      'priority': 'Medium',
      'assigned': 'Unassigned',
    },
    {
      'id': 'l6',
      'name': 'Olivia Taylor',
      'email': 'olivia.taylor@example.com',
      'phone': '+1 (678) 901-2345',
      'status': 'Closed Won',
      'source': 'Referral',
      'date': '2023-05-05',
      'priority': 'Low',
      'assigned': 'Sarah Johnson',
    },
  ];

  void _handleSectionChange(String section) {
    setState(() {
      // _currentSection = section;
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
      drawer: const Drawer(child: AppSidebar()),
      body: Row(
        children: [
          // Sidebar for desktop
          if (isDesktop) const AppSidebar(),
          
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
                      final String title = isVerySmallScreen ? 'Leads' : 
                                          isSmallScreen ? 'Leads' : 'Leads Management';
                      
                      // Calculate trailing widget width based on screen size
                      final double trailingWidth = isVerySmallScreen ? 40.0 : 
                                           isSmallScreen ? 70.0 : 100.0;
                      
                      return Row(
                        children: [
                          // Menu button (mobile only) - fixed width
                          if (!isDesktop)
                            SizedBox(
                              width: 32, // Even smaller fixed width
                              child: Builder(
                                builder: (ctx) => IconButton(
                                  icon: const Icon(Icons.menu, size: 18),
                                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                                  color: Colors.grey.shade700,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
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
                                'All Leads',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isDesktop)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Add Lead'),
                                onPressed: () {
                                  context.go('/leads/add');
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
                                  context.go('/leads/add');
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
                                    'New',
                                    'Contacted',
                                    'Qualified',
                                    'Proposal',
                                    'Negotiation',
                                    'Closed Won',
                                    'Closed Lost',
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
                            
                            // Source filter
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
                                  value: 'All Sources',
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items: [
                                    'All Sources',
                                    'Website',
                                    'Referral',
                                    'Social Media',
                                    'Event',
                                    'Other',
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
                            
                            // Assigned filter
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
                                  value: 'All Agents',
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items: [
                                    'All Agents',
                                    'Sarah Johnson',
                                    'Michael Davis',
                                    'Unassigned',
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
                        
                        // Leads list
                        Expanded(
                          child: ListView.builder(
                            itemCount: _leads.length,
                            itemBuilder: (context, index) {
                              final lead = _leads[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: InkWell(
                                  onTap: () {
                                    context.go('/leads/${lead['id']}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                lead['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(lead['status']),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                lead['status'],
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              lead['email'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              lead['phone'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  lead['date'],
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.source,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  lead['source'],
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: _getPriorityColor(lead['priority']),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${lead['priority']} Priority',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Assigned to: ${lead['assigned']}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
}
