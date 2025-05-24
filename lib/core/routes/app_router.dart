import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/developments/screens/developments_screen.dart';
import '../../features/leads/screens/leads_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../providers/auth_provider.dart';

/// Handles application routing with role-based access controls
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation
  
  /// Create and configure the app router
  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        // Handle authentication redirects
        final isLoggedIn = authProvider.isLoggedIn;
        final isLoginRoute = state.location == '/login';
        
        // If not logged in and not on login page, redirect to login
        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }
        
        // If logged in and on login page, redirect to dashboard
        if (isLoggedIn && isLoginRoute) {
          return '/dashboard';
        }
        
        // No redirect needed
        return null;
      },
      refreshListenable: authProvider,
      routes: [
        // Login route
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        
        // Dashboard route
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        
        // Developments route
        GoRoute(
          path: '/developments',
          builder: (context, state) => const DevelopmentsScreen(),
        ),
        
        // Leads route
        GoRoute(
          path: '/leads',
          builder: (context, state) => const LeadsScreen(),
        ),
        
        // Settings route (admin only)
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
          redirect: (context, state) {
            // Role-based access control - only allow admins to access settings
            if (!authProvider.hasAdminPermissions) {
              return '/dashboard';
            }
            return null;
          },
        ),
        
        // Development details route
        GoRoute(
          path: '/developments/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            // This would load the actual development in a real app
            return DevelopmentDetailsScreen(developmentId: id);
          },
        ),
        
        // Lead details route
        GoRoute(
          path: '/leads/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            // This would load the actual lead in a real app
            return LeadDetailsScreen(leadId: id);
          },
        ),
        
        // Root redirect
        GoRoute(
          path: '/',
          redirect: (_, __) => '/dashboard',
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The page ${state.location} does not exist',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder screens - these would be replaced by actual implementations
class DevelopmentDetailsScreen extends StatelessWidget {
  final String developmentId;
  
  const DevelopmentDetailsScreen({Key? key, required this.developmentId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Development $developmentId')),
      body: Center(child: Text('Development Details for ID: $developmentId')),
    );
  }
}

class LeadDetailsScreen extends StatelessWidget {
  final String leadId;
  
  const LeadDetailsScreen({Key? key, required this.leadId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lead $leadId')),
      body: Center(child: Text('Lead Details for ID: $leadId')),
    );
  }
}
