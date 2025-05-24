import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../../../shared/widgets/development_card.dart';
import '../../../shared/widgets/lead_list_item.dart';
import '../../../shared/layouts/main_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    
    // Get user role information
    final userName = authProvider.userName ?? 'Developer';
    final userRole = authProvider.userRole;
    final roleDisplay = userRole.toString().split('.').last;
    
    return MainLayout(
      currentIndex: 0,
      title: 'Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, userName, roleDisplay, isLowBandwidth),
            
            const SizedBox(height: 24),
            
            // Summary Cards
            _buildSummaryCards(context, isLowBandwidth),
            
            const SizedBox(height: 24),
            
            // Active Developments Section
            _buildSectionHeader(
              context, 
              'Active Developments', 
              onViewAll: () => context.push('/developments'),
            ),
            const SizedBox(height: 12),
            _buildActiveDevelopments(context, isLowBandwidth),
            
            const SizedBox(height: 24),
            
            // Recent Leads Section
            _buildSectionHeader(
              context, 
              'Recent Leads', 
              onViewAll: () => context.push('/leads'),
            ),
            const SizedBox(height: 12),
            _buildRecentLeads(context, isLowBandwidth, authProvider),
            
            // Admin-only section
            if (authProvider.isAdmin) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(
                context, 
                'Admin Controls', 
                onViewAll: () => context.push('/settings'),
              ),
              const SizedBox(height: 12),
              _buildAdminControls(context, isLowBandwidth),
            ],
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomeSection(
    BuildContext context, 
    String userName, 
    String roleDisplay,
    bool isLowBandwidth,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isLowBandwidth ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isLowBandwidth ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  radius: 24,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'D',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $userName',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${roleDisplay.substring(0, 1).toUpperCase()}${roleDisplay.substring(1)} Developer',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isLowBandwidth) ...[
              const SizedBox(height: 16),
              Text(
                'Welcome to your property developer dashboard. Here you can manage your developments, track leads, and monitor sales performance.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryCards(BuildContext context, bool isLowBandwidth) {
    final theme = Theme.of(context);
    
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSummaryCard(
          context,
          title: 'Active Developments',
          value: '5',
          icon: Icons.business,
          color: theme.colorScheme.primary,
          isLowBandwidth: isLowBandwidth,
        ),
        _buildSummaryCard(
          context,
          title: 'Total Leads',
          value: '42',
          icon: Icons.people,
          color: theme.colorScheme.secondary,
          isLowBandwidth: isLowBandwidth,
        ),
        _buildSummaryCard(
          context,
          title: 'Sales This Month',
          value: '8',
          icon: Icons.shopping_cart,
          color: Colors.orange,
          isLowBandwidth: isLowBandwidth,
        ),
      ],
    );
  }
  
  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isLowBandwidth,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isLowBandwidth ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isLowBandwidth ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(
    BuildContext context, 
    String title, {
    VoidCallback? onViewAll,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All'),
          ),
      ],
    );
  }
  
  Widget _buildActiveDevelopments(BuildContext context, bool isLowBandwidth) {
    // Sample development data
    final developments = [
      {
        'id': '1',
        'name': 'Sunset Heights',
        'location': 'Lagos, Nigeria',
        'status': 'Active',
        'units': 120,
        'progress': 0.45,
        'imageUrl': 'assets/images/development1.jpg',
      },
      {
        'id': '2',
        'name': 'Palm Residences',
        'location': 'Accra, Ghana',
        'status': 'Active',
        'units': 85,
        'progress': 0.32,
        'imageUrl': 'assets/images/development2.jpg',
      },
    ];
    
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: developments.length,
        itemBuilder: (context, index) {
          final development = developments[index];
          return SizedBox(
            width: 280,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DevelopmentCard(
                id: development['id'] as String,
                name: development['name'] as String,
                location: development['location'] as String,
                status: development['status'] as String,
                units: development['units'] as int,
                progress: development['progress'] as double,
                imageUrl: development['imageUrl'] as String,
                isLowBandwidth: isLowBandwidth,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildRecentLeads(
    BuildContext context, 
    bool isLowBandwidth,
    AuthProvider authProvider,
  ) {
    final theme = Theme.of(context);
    
    // Sample lead data
    final leads = [
      {
        'id': '1',
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'development': 'Sunset Heights',
        'status': 'Contacted',
        'date': 'May 20, 2025',
      },
      {
        'id': '2',
        'name': 'Sarah Johnson',
        'email': 'sarah.j@example.com',
        'development': 'Palm Residences',
        'status': 'Interested',
        'date': 'May 18, 2025',
      },
      {
        'id': '3',
        'name': 'Mike Thompson',
        'email': 'mike.t@example.com',
        'development': 'Business Park',
        'status': 'New Lead',
        'date': 'May 23, 2025',
      },
    ];
    
    return Card(
      elevation: isLowBandwidth ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isLowBandwidth ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
      ),
      child: Column(
        children: [
          for (int i = 0; i < leads.length; i++) ...[
            LeadListItem(
              id: leads[i]['id'] as String,
              name: leads[i]['name'] as String,
              email: leads[i]['email'] as String,
              development: leads[i]['development'] as String,
              status: leads[i]['status'] as String,
              date: leads[i]['date'] as String,
              isLowBandwidth: isLowBandwidth,
              canEdit: authProvider.canEdit,
            ),
            if (i < leads.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: theme.dividerTheme.color,
              ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAdminControls(BuildContext context, bool isLowBandwidth) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isLowBandwidth ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isLowBandwidth ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Administrative Controls',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAdminButton(
                  context,
                  icon: Icons.people,
                  label: 'Manage Users',
                  onPressed: () {},
                ),
                _buildAdminButton(
                  context,
                  icon: Icons.settings,
                  label: 'Company Settings',
                  onPressed: () {},
                ),
                _buildAdminButton(
                  context,
                  icon: Icons.bar_chart,
                  label: 'Analytics',
                  onPressed: () {},
                ),
                _buildAdminButton(
                  context,
                  icon: Icons.add_business,
                  label: 'Add Development',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAdminButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
    );
  }
}
