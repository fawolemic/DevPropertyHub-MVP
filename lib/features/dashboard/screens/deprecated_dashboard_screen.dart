// **************************************************************************
// DEPRECATED: This dashboard is deprecated and will be removed in a future version.
// Do not add new features to this file. Use ModernDashboardScreen instead.
// All "Add Development" buttons should navigate to the new wizard at '/developments/add'.
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// This class replaces the old dashboard with a deprecation notice
/// that automatically redirects users to the new dashboard.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Automatically redirect to the modern dashboard after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          context.go('/dashboard');
        }
      });
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade700,
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                'DEPRECATED DASHBOARD',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This dashboard has been deprecated and will be removed in a future update.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'You will be automatically redirected to the new dashboard in 3 seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/dashboard'),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to New Dashboard Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'If you need to access development features, please use the buttons below:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go('/developments'),
                    icon: const Icon(Icons.business),
                    label: const Text('View Developments'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/developments/add'),
                    icon: const Icon(Icons.add_business),
                    label: const Text('Add Development'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
