import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../../../shared/layouts/main_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);

    return MainLayout(
      title: 'Settings',
      currentIndex: 3,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text('User Profile'),
                      subtitle: Text('Logged in as: ${authProvider.userEmail}'),
                      leading: const Icon(Icons.person),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile settings coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Role'),
                      subtitle: Text(
                          'Current role: ${_formatRole(authProvider.userRole.toString().split('.').last)}'),
                      leading: const Icon(Icons.security),
                      trailing: authProvider.isAdmin
                          ? const Icon(Icons.chevron_right)
                          : null,
                      onTap: authProvider.isAdmin
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Role management coming soon!'),
                                ),
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Application Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text('Low Bandwidth Mode'),
                      subtitle: Text(bandwidthProvider.isLowBandwidth
                          ? 'Enabled - Optimized for slower connections'
                          : 'Disabled - Using full bandwidth'),
                      value: bandwidthProvider.isLowBandwidth,
                      onChanged: (value) {
                        bandwidthProvider.setLowBandwidth(value);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Theme'),
                      subtitle: const Text('Light mode'),
                      leading: const Icon(Icons.brightness_6),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Theme settings coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Language'),
                      subtitle: const Text('English'),
                      leading: const Icon(Icons.language),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Language settings coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (authProvider.userRole == 'admin') ...[
              const Text(
                'Admin Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text('User Management'),
                        subtitle: const Text('Manage system users'),
                        leading: const Icon(Icons.people),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User management coming soon!'),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('System Configuration'),
                        subtitle: const Text('Configure system settings'),
                        leading: const Icon(Icons.settings),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('System configuration coming soon!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                authProvider.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRole(String role) {
    switch (role) {
      case 'admin':
        return 'Administrator';
      case 'standard':
        return 'Standard User';
      case 'viewer':
        return 'Viewer';
      default:
        return 'Unknown';
    }
  }
}
