import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Mobile navigation drawer that provides access to all app sections
/// and handles back navigation for improved mobile experience
class MobileNavigationDrawer extends StatelessWidget {
  const MobileNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DevPropertyHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Property Developer Portal',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close drawer
                        GoRouter.of(context).go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close drawer
                        GoRouter.of(context).go('/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            'Home',
            Icons.home,
            () {
              Navigator.pop(context);
              GoRouter.of(context).go('/');
            },
          ),
          _buildDrawerItem(
            context,
            'Projects',
            Icons.business,
            () {
              Navigator.pop(context);
              // Navigate to projects
              GoRouter.of(context).go('/developments');
            },
          ),
          _buildDrawerItem(
            context,
            'Developers',
            Icons.people,
            () {
              Navigator.pop(context);
              // Navigate to developers section
            },
          ),
          _buildDrawerItem(
            context,
            'Market Insights',
            Icons.insights,
            () {
              Navigator.pop(context);
              // Navigate to market insights
            },
          ),
          _buildDrawerItem(
            context,
            'About',
            Icons.info,
            () {
              Navigator.pop(context);
              // Navigate to about
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            'Help Center',
            Icons.help,
            () {
              Navigator.pop(context);
              // Navigate to help center
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, 
    String title, 
    IconData icon, 
    VoidCallback onTap
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
