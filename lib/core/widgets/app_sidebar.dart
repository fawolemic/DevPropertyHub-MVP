import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'logout_user_button.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouter.of(context).location;
    bool isActive(String path) => location == path;

    Widget navItem(String title, IconData icon, String path) {
      return ListTile(
        leading: Icon(icon,
            color: isActive(path) ? theme.colorScheme.primary : null),
        title: Text(title,
            style: TextStyle(
                color: isActive(path) ? theme.colorScheme.primary : null,
                fontWeight:
                    isActive(path) ? FontWeight.bold : FontWeight.normal)),
        selected: isActive(path),
        onTap: () => GoRouter.of(context).go(path),
      );
    }

    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 64,
            alignment: Alignment.centerLeft,
            child: Text(
              'DevPropertyHub',
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          navItem('Overview', Icons.dashboard, '/overview'),
          navItem('Properties', Icons.business, '/developments'),
          navItem('Recent Leads', Icons.people, '/leads'),
          navItem('Analytics', Icons.bar_chart, '/analytics'),
          navItem('Documents', Icons.description, '/documents'),
          navItem('Settings', Icons.settings, '/settings'),
          const Divider(),
          const Spacer(),
          const LogoutUserButton(),
        ],
      ),
    );
  }
}
