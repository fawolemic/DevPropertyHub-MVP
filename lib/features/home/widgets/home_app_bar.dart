import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 1,
      title: InkWell(
        onTap: () => GoRouter.of(context).go('/'),
        child: const Text(
          'DevPropertyHub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      // Add hamburger menu for mobile
      leading: MediaQuery.of(context).size.width <= 800
        ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Show mobile navigation drawer
              Scaffold.of(context).openDrawer();
            },
          )
        : null,
      actions: [
        // Navigation links for larger screens
        if (MediaQuery.of(context).size.width > 800) ...[
          _buildNavLink(context, 'Projects', theme),
          _buildNavLink(context, 'Developers', theme),
          _buildNavLink(context, 'Market Insights', theme),
          _buildNavLink(context, 'About', theme),
          const SizedBox(width: 16),
        ],
        
        // Auth buttons
        TextButton(
          onPressed: () async {
            // Try using url_launcher for direct HTML page
            final Uri url = Uri.parse('https://devpropertyhub-mvp.netlify.app/login.html');
            if (!await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
              webOnlyWindowName: '_self',
            )) {
              // If url_launcher fails, fallback to Go Router
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to login page...')),
                );
                GoRouter.of(context).go('/login');
              }
            }
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/unified-register');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Get Started'),
          ),
        ),
      ],
    );
  }

  Widget _buildNavLink(BuildContext context, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {
          // Handle navigation based on the link text
          switch (text) {
            case 'Projects':
              // Navigate to projects
              break;
            case 'Developers':
              // Navigate to developers
              break;
            case 'Market Insights':
              // Navigate to market insights
              break;
            case 'About':
              // Navigate to about
              break;
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
        ),
        child: Text(text),
      ),
    );
  }
}
