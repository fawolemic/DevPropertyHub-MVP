import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../dashboard/widgets/modern_sidebar.dart';
import '../../dashboard/widgets/lead_card.dart';

class ModernLeadsScreen extends StatefulWidget {
  const ModernLeadsScreen({Key? key}) : super(key: key);

  @override
  State<ModernLeadsScreen> createState() => _ModernLeadsScreenState();
}

class _ModernLeadsScreenState extends State<ModernLeadsScreen> {
  bool _sidebarOpen = false;
  String _activeSection = 'leads';
  
  // Sample data for leads
  final List<Map<String, dynamic>> _leads = [
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
    {
      'id': 4,
      'name': 'Emily Davis',
      'email': 'emily.d@email.com',
      'property': 'Skyline Towers - Unit 10D',
      'budget': '\$950K',
      'status': 'New Inquiry',
      'time': '3 hours ago',
      'priority': 'medium',
    },
    {
      'id': 5,
      'name': 'Robert Wilson',
      'email': 'robert.w@email.com',
      'property': 'Harbor View - Unit 7A',
      'budget': '\$1.5M',
      'status': 'Offer Made',
      'time': '6 hours ago',
      'priority': 'high',
    },
    {
      'id': 6,
      'name': 'Jennifer Brown',
      'email': 'jennifer.b@email.com',
      'property': 'Prop Developers - Unit 3C',
      'budget': '\$680K',
      'status': 'Follow Up',
      'time': '2 days ago',
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
                          'Leads Management',
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
                              hintText: 'Search leads...',
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
                                  'All Leads',
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
                                      // Navigate to add lead screen
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Add lead functionality coming soon')),
                                      );
                                    },
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add Lead'),
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
                                  'All Leads',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigate to add lead screen
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Add lead functionality coming soon')),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Lead'),
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
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                // Status filter
                                Container(
                                  width: ResponsiveUtils.isMobile(context) ? 140 : null,
                                  margin: EdgeInsets.only(right: ResponsiveUtils.isMobile(context) ? 12 : 16),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Status',
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, 
                                        vertical: ResponsiveUtils.isMobile(context) ? 4 : 8
                                      ),
                                      isDense: ResponsiveUtils.isMobile(context),
                                      labelStyle: ResponsiveUtils.isMobile(context) 
                                        ? TextStyle(fontSize: 12) 
                                        : null,
                                    ),
                                    value: 'All',
                                    items: const [
                                      DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                                      DropdownMenuItem(value: 'Hot Lead', child: Text('Hot Lead')),
                                      DropdownMenuItem(value: 'Interested', child: Text('Interested')),
                                      DropdownMenuItem(value: 'Viewing Scheduled', child: Text('Viewing Scheduled')),
                                      DropdownMenuItem(value: 'Offer Made', child: Text('Offer Made')),
                                    ],
                                    onChanged: (value) {},
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down, size: ResponsiveUtils.isMobile(context) ? 18 : 24),
                                  ),
                                ),
                                
                                // Priority filter
                                Container(
                                  width: ResponsiveUtils.isMobile(context) ? 140 : null,
                                  margin: EdgeInsets.only(right: ResponsiveUtils.isMobile(context) ? 12 : 16),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Priority',
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, 
                                        vertical: ResponsiveUtils.isMobile(context) ? 4 : 8
                                      ),
                                      isDense: ResponsiveUtils.isMobile(context),
                                      labelStyle: ResponsiveUtils.isMobile(context) 
                                        ? TextStyle(fontSize: 12) 
                                        : null,
                                    ),
                                    value: 'All',
                                    items: const [
                                      DropdownMenuItem(value: 'All', child: Text('All Priorities')),
                                      DropdownMenuItem(value: 'high', child: Text('High')),
                                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                                      DropdownMenuItem(value: 'low', child: Text('Low')),
                                    ],
                                    onChanged: (value) {},
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down, size: ResponsiveUtils.isMobile(context) ? 18 : 24),
                                  ),
                                ),
                                
                                // Sort option
                                Container(
                                  width: ResponsiveUtils.isMobile(context) ? 140 : null,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Sort By',
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, 
                                        vertical: ResponsiveUtils.isMobile(context) ? 4 : 8
                                      ),
                                      isDense: ResponsiveUtils.isMobile(context),
                                      labelStyle: ResponsiveUtils.isMobile(context) 
                                        ? TextStyle(fontSize: 12) 
                                        : null,
                                    ),
                                    value: 'Recent',
                                    items: const [
                                      DropdownMenuItem(value: 'Recent', child: Text('Most Recent')),
                                      DropdownMenuItem(value: 'Name', child: Text('Name')),
                                      DropdownMenuItem(value: 'Budget', child: Text('Budget')),
                                      DropdownMenuItem(value: 'Priority', child: Text('Priority')),
                                    ],
                                    onChanged: (value) {},
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down, size: ResponsiveUtils.isMobile(context) ? 18 : 24),
                                  ),
                                ),
                                      ],
                                    ),
                                  ),
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
                                        DropdownMenuItem(value: 'Hot Lead', child: Text('Hot Lead')),
                                        DropdownMenuItem(value: 'Interested', child: Text('Interested')),
                                        DropdownMenuItem(value: 'Viewing Scheduled', child: Text('Viewing Scheduled')),
                                        DropdownMenuItem(value: 'Offer Made', child: Text('Offer Made')),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Priority filter
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Priority',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      value: 'All',
                                      items: const [
                                        DropdownMenuItem(value: 'All', child: Text('All Priorities')),
                                        DropdownMenuItem(value: 'high', child: Text('High')),
                                        DropdownMenuItem(value: 'medium', child: Text('Medium')),
                                        DropdownMenuItem(value: 'low', child: Text('Low')),
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
                                      value: 'Recent',
                                      items: const [
                                        DropdownMenuItem(value: 'Recent', child: Text('Most Recent')),
                                        DropdownMenuItem(value: 'Name', child: Text('Name')),
                                        DropdownMenuItem(value: 'Budget', child: Text('Budget')),
                                        DropdownMenuItem(value: 'Priority', child: Text('Priority')),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Leads list
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context)),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveUtils.isMobile(context) ? 12 : 16),
                            child: Column(
                              children: [
                                // Table header - only show on desktop/tablet
                                ResponsiveUtils.isMobile(context)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'All Leads (${_leads.length})',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        Text(
                                          'Tap for details',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Lead',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Property',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Budget',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(width: 48), // Actions column
                                      ],
                                    ),
                                  ),
                                
                                const Divider(),
                                
                                // Leads list
                                ResponsiveUtils.isMobile(context)
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _leads.length,
                                    itemBuilder: (context, index) {
                                      final lead = _leads[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: BorderSide(color: Colors.grey.shade200),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          leading: CircleAvatar(
                                            backgroundColor: theme.colorScheme.primary,
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
                                                    constraints: const BoxConstraints(maxWidth: 80),
                                                    child: Text(
                                                      lead['status'],
                                                      overflow: TextOverflow.ellipsis,
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
                                          trailing: IconButton(
                                            icon: const Icon(Icons.more_vert, size: 16),
                                            onPressed: () => _showLeadActions(context, lead),
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                          ),
                                          onTap: () {
                                            // View lead details
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Viewing details for ${lead['name']}')),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _leads.length,
                                    separatorBuilder: (context, index) => const Divider(),
                                    itemBuilder: (context, index) {
                                      final lead = _leads[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: InkWell(
                                          onTap: () {
                                            // View lead details
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Viewing details for ${lead['name']}')),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                            children: [
                                              // Lead info
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    // Avatar
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: theme.colorScheme.primary,
                                                      child: Text(
                                                        _getInitials(lead['name']),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    // Name and email
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            lead['name'],
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Text(
                                                            lead['email'],
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey.shade600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                          Text(
                                                            lead['time'],
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey.shade500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              
                                              // Property
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  lead['property'],
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              
                                              // Budget
                                              Expanded(
                                                child: Text(
                                                  lead['budget'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              
                                              // Status
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getPriorityColor(lead['priority']).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Text(
                                                    lead['status'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: _getPriorityColor(lead['priority']),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              
                                              // Actions
                                              SizedBox(
                                                width: 48,
                                                child: IconButton(
                                                  icon: const Icon(Icons.more_vert),
                                                  onPressed: () {
                                                    // Show actions menu
                                                    _showLeadActions(context, lead);
                                                  },
                                                  color: Colors.grey.shade500,
                                                  iconSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
                ),
              ],
            ),
          ),
        ],
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
  
  void _showLeadActions(BuildContext context, Map<String, dynamic> lead) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing details for ${lead['name']}')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Lead'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Editing ${lead['name']}')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Lead'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${lead['name']}')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Send Email'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Composing email to ${lead['name']}')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red.shade700),
                title: Text('Delete Lead', style: TextStyle(color: Colors.red.shade700)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleting ${lead['name']}')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
