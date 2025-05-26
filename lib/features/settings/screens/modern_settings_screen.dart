import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../../dashboard/widgets/modern_sidebar.dart';

class ModernSettingsScreen extends StatefulWidget {
  const ModernSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ModernSettingsScreen> createState() => _ModernSettingsScreenState();
}

class _ModernSettingsScreenState extends State<ModernSettingsScreen> {
  bool _sidebarOpen = false;
  String _activeSection = 'settings';
  
  // Settings state
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _lowBandwidthMode = false;
  String _language = 'English';
  
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
  void initState() {
    super.initState();
    // Initialize settings from providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bandwidthProvider = Provider.of<BandwidthProvider>(context, listen: false);
      setState(() {
        _lowBandwidthMode = bandwidthProvider.isLowBandwidth;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width >= 1024;
    
    // Get user info
    final userName = authProvider.userName ?? 'Admin User';
    final userRole = authProvider.userRole.toString().split('.').last;
    
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
                          'Settings',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile section
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile Settings',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile picture
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: theme.colorScheme.primary,
                                          child: Text(
                                            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        OutlinedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Change photo feature coming soon')),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Change Photo'),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(width: 32),
                                    
                                    // Profile details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Name field
                                          TextFormField(
                                            initialValue: userName,
                                            decoration: const InputDecoration(
                                              labelText: 'Full Name',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Email field
                                          TextFormField(
                                            initialValue: 'user@example.com',
                                            decoration: const InputDecoration(
                                              labelText: 'Email Address',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Phone field
                                          TextFormField(
                                            initialValue: '+1 234 567 8900',
                                            decoration: const InputDecoration(
                                              labelText: 'Phone Number',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          
                                          // Role display
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Account Type:',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: theme.colorScheme.primary.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    '${userRole.substring(0, 1).toUpperCase()}${userRole.substring(1)} Developer',
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
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Save button
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Profile updated successfully')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Save Changes'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Notification settings
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notification Settings',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Email notifications
                                SwitchListTile(
                                  title: const Text('Email Notifications'),
                                  subtitle: const Text('Receive updates and alerts via email'),
                                  value: _emailNotifications,
                                  onChanged: (value) {
                                    setState(() {
                                      _emailNotifications = value;
                                    });
                                  },
                                  secondary: Icon(
                                    Icons.email,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                
                                const Divider(),
                                
                                // Push notifications
                                SwitchListTile(
                                  title: const Text('Push Notifications'),
                                  subtitle: const Text('Receive real-time alerts on your device'),
                                  value: _pushNotifications,
                                  onChanged: (value) {
                                    setState(() {
                                      _pushNotifications = value;
                                    });
                                  },
                                  secondary: Icon(
                                    Icons.notifications,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // App settings
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'App Settings',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Dark mode
                                SwitchListTile(
                                  title: const Text('Dark Mode'),
                                  subtitle: const Text('Switch between light and dark themes'),
                                  value: _darkMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _darkMode = value;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Dark mode will be available in a future update')),
                                    );
                                  },
                                  secondary: Icon(
                                    Icons.dark_mode,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                
                                const Divider(),
                                
                                // Low bandwidth mode
                                SwitchListTile(
                                  title: const Text('Low Bandwidth Mode'),
                                  subtitle: const Text('Reduce data usage and improve performance'),
                                  value: _lowBandwidthMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _lowBandwidthMode = value;
                                    });
                                    bandwidthProvider.setLowBandwidth(value);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Low bandwidth mode ${value ? 'enabled' : 'disabled'}')),
                                    );
                                  },
                                  secondary: Icon(
                                    Icons.speed,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                
                                const Divider(),
                                
                                // Language
                                ListTile(
                                  title: const Text('Language'),
                                  subtitle: Text(_language),
                                  leading: Icon(
                                    Icons.language,
                                    color: theme.colorScheme.primary,
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    _showLanguageSelector(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Security settings
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Security',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Change password
                                ListTile(
                                  title: const Text('Change Password'),
                                  subtitle: const Text('Update your account password'),
                                  leading: Icon(
                                    Icons.lock,
                                    color: theme.colorScheme.primary,
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    _showChangePasswordDialog(context);
                                  },
                                ),
                                
                                const Divider(),
                                
                                // Two-factor authentication
                                ListTile(
                                  title: const Text('Two-Factor Authentication'),
                                  subtitle: const Text('Add an extra layer of security'),
                                  leading: Icon(
                                    Icons.security,
                                    color: theme.colorScheme.primary,
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Two-factor authentication coming soon')),
                                    );
                                  },
                                ),
                                
                                const Divider(),
                                
                                // Logout from all devices
                                ListTile(
                                  title: const Text('Logout from All Devices'),
                                  subtitle: const Text('Secure your account by logging out everywhere'),
                                  leading: Icon(
                                    Icons.logout,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onTap: () {
                                    _showLogoutConfirmation(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Danger zone
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Danger Zone',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                Text(
                                  'Actions in this section can have permanent consequences.',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Delete account
                                OutlinedButton.icon(
                                  onPressed: () {
                                    _showDeleteAccountConfirmation(context);
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  label: const Text('Delete Account'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                    side: BorderSide(color: Colors.red.shade700),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showLanguageSelector(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Language',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    return ListTile(
                      title: Text(language),
                      trailing: language == _language
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _language = language;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Language changed to $_language')),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String currentPassword = '';
    String newPassword = '';
    String confirmPassword = '';
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    currentPassword = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    newPassword = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != newPassword) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully')),
                  );
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        );
      },
    );
  }
  
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout from All Devices'),
          content: const Text(
            'This will log you out from all devices where you are currently signed in. You will need to sign in again on each device.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out from all devices')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout Everywhere'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'This action cannot be undone. All your data will be permanently deleted. Are you sure you want to delete your account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deletion request submitted')),
                );
                // In a real app, you would handle the account deletion here
                Future.delayed(const Duration(seconds: 2), () {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  authProvider.signOut();
                  context.go('/login');
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }
}
