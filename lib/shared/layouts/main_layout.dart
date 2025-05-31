import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/bandwidth_provider.dart';

/// MainLayout
/// 
/// The main layout structure used across the application.
/// Handles responsive behaviors across mobile, tablet and desktop layouts.
/// 
/// SEARCH TAGS: #layout #responsive #navigation #scaffold #app-structure

class MainLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final List<Widget>? actions;

  const MainLayout({
    Key? key,
    required this.body,
    required this.title,
    required this.currentIndex,
    this.actions,
  }) : super(key: key);

  // #region MAIN BUILD METHOD
  /// Main build method that constructs the overall layout
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine if we should use a drawer (mobile) or side navigation (tablet/desktop)
    final bool useDrawer = screenWidth < 1100;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: isLowBandwidth ? 0 : 2,
        actions: [
          // Bandwidth toggle button
          IconButton(
            icon: Icon(
              bandwidthProvider.isLowBandwidth
                  ? Icons.signal_cellular_alt_1_bar
                  : Icons.signal_cellular_alt,
            ),
            tooltip: isLowBandwidth ? 'Switch to High Bandwidth' : 'Switch to Low Bandwidth',
            onPressed: () {
              bandwidthProvider.toggleLowBandwidthMode();
            },
          ),
          
          // User menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account',
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.signOut().then((_) {
                  context.go('/login');
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      radius: 16,
                      child: Text(
                        authProvider.userName?.isNotEmpty == true
                            ? authProvider.userName![0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userName ?? 'User',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${authProvider.userRole.toString().split('.').last.substring(0, 1).toUpperCase()}${authProvider.userRole.toString().split('.').last.substring(1)} Developer',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 12),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
          
          // Additional actions
          if (actions != null) ...actions!,
        ],
      ),
      
      // Drawer for mobile layout
      drawer: useDrawer ? _buildDrawer(context, authProvider, currentIndex) : null,
      
      // Side navigation for larger screens
      body: !useDrawer
          ? Row(
              children: [
                _buildSideNavigation(context, authProvider, currentIndex),
                Expanded(child: body),
              ],
            )
          : body,
      
      // Bottom navigation for mobile
      bottomNavigationBar: useDrawer ? _buildBottomNavBar(context, currentIndex) : null,
    );
  }
  
  // Drawer for mobile layout
  // #endregion

  // #region NAVIGATION COMPONENTS
  /// Builds the navigation drawer for mobile devices
  Widget _buildDrawer(
    BuildContext context, 
    AuthProvider authProvider,
    int currentIndex,
  ) {
    final theme = Theme.of(context);
    
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authProvider.userName ?? 'User'),
            accountEmail: Text(
              '${authProvider.userRole.toString().split('.').last.substring(0, 1).toUpperCase()}${authProvider.userRole.toString().split('.').last.substring(1)} Developer',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                authProvider.userName?.isNotEmpty == true
                    ? authProvider.userName![0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
          ),
          
          // Navigation items
          _buildDrawerItem(
            context,
            icon: Icons.business,
            title: 'Developments',
            isSelected: currentIndex == 0,
            onTap: () => context.go('/developments'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.business,
            title: 'Developments',
            isSelected: currentIndex == 1,
            onTap: () => context.go('/developments'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people,
            title: 'Leads',
            isSelected: currentIndex == 2,
            onTap: () => context.go('/leads'),
          ),
          
          // Settings available to all users
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            isSelected: currentIndex == 3,
            onTap: () => context.go('/settings'),
          ),
          
          const Spacer(),
          
          const Divider(),
          
          // Logout button
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authProvider.signOut().then((_) {
                context.go('/login');
              });
            },
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  // Drawer item with selection state
  /// Builds an individual drawer item
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: onTap,
    );
  }
  
  // Side navigation for tablet/desktop
  /// Builds the side navigation for tablet and desktop devices
  Widget _buildSideNavigation(
    BuildContext context, 
    AuthProvider authProvider,
    int currentIndex,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // App title/logo section
          Container(
            padding: const EdgeInsets.all(16),
            height: 64, // Match AppBar height
            child: Row(
              children: [
                Icon(
                  Icons.apartment,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'DevPropertyHub',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // User info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  radius: 20,
                  child: Text(
                    authProvider.userName?.isNotEmpty == true
                        ? authProvider.userName![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userName ?? 'User',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${authProvider.userRole.toString().split('.').last.substring(0, 1).toUpperCase()}${authProvider.userRole.toString().split('.').last.substring(1)} Developer',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSideNavItem(
                  context,
                  icon: Icons.business,
                  title: 'Developments',
                  isSelected: currentIndex == 0,
                  onTap: () => context.go('/developments'),
                ),
                _buildSideNavItem(
                  context,
                  icon: Icons.business,
                  title: 'Developments',
                  isSelected: currentIndex == 1,
                  onTap: () => context.go('/developments'),
                ),
                _buildSideNavItem(
                  context,
                  icon: Icons.people,
                  title: 'Leads',
                  isSelected: currentIndex == 2,
                  onTap: () => context.go('/leads'),
                ),
                
                // Admin-only settings
                if (authProvider.isAdmin)
                  _buildSideNavItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    isSelected: currentIndex == 3,
                    onTap: () => context.go('/settings'),
                  ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                authProvider.signOut().then((_) {
                  context.go('/login');
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Side navigation item
  /// Builds an individual side navigation item
  Widget _buildSideNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? theme.colorScheme.primary : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Bottom navigation for mobile
  /// Builds the bottom navigation bar for mobile devices
  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    // #endregion
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return NavigationBar(
      selectedIndex: currentIndex > 3 ? 0 : currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/developments');
            break;
          case 1:
            context.go('/leads');
            break;
          case 2:
            if (authProvider.isAdmin) {
              context.go('/settings');
            }
            break;
        }
      },
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.business_outlined),
          selectedIcon: Icon(Icons.business),
          label: 'Developments',
        ),
        const NavigationDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people),
          label: 'Leads',
        ),
        if (authProvider.isAdmin)
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
      ],
    );
  }
}
