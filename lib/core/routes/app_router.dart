import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/registration/registration_screen.dart';
import '../../features/auth/screens/buyer_registration/buyer_registration_screen.dart';
import '../../features/auth/screens/unified_registration/unified_registration_screen.dart';
import '../../features/auth/screens/registration_test_page.dart';
import '../../features/auth/screens/additional_setup/common/email_verification_screen.dart';
import '../../features/auth/screens/additional_setup/developer/subscription_selection.dart';
import '../../features/auth/screens/additional_setup/developer/payment_screen.dart';
import '../../features/auth/screens/additional_setup/agent/approval_status_screen.dart';
import '../../features/testing/direct_test_page.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/dashboard/screens/modern_dashboard_screen.dart';
import '../../features/developments/screens/modern_developments_screen.dart';
import '../../features/leads/screens/modern_leads_screen.dart';
import '../../features/settings/screens/modern_settings_screen.dart';
import '../../features/developments/screens/developments_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/leads/screens/leads_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../examples/api_service_example.dart';
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
        // Get current auth state
        final isLoggedIn = authProvider.isLoggedIn;
        
        // Define route types
        final isLoginRoute = state.location == '/login';
        final isDashboardRoute = state.location == '/dashboard';
        final isRegistrationRoute = state.location.startsWith('/register') || 
                                   state.location == '/unified-register' ||
                                   state.location.startsWith('/email-verification') ||
                                   state.location.startsWith('/subscription-selection') ||
                                   state.location.startsWith('/approval-status') ||
                                   state.location.startsWith('/payment');
        final isPublicRoute = state.location == '/' || state.location == '/home';
        
        debugPrint('GoRouter redirect: isLoggedIn=$isLoggedIn, path=${state.location}');
        
        // If logged in and on login or home page, redirect to dashboard
        if (isLoggedIn && (isLoginRoute || isPublicRoute)) {
          debugPrint('User is logged in and on login/home. Redirecting to dashboard.');
          return '/dashboard';
        }
        
        // If not logged in and trying to access a protected page, redirect to login
        if (!isLoggedIn && !isLoginRoute && !isRegistrationRoute && !isPublicRoute) {
          debugPrint('User is not logged in and trying to access a protected page. Redirecting to login.');
          return '/login';
        }
        
        // No redirect needed
        return null;
      },
      refreshListenable: authProvider,
      routes: [
        // Public routes
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        
        // Auth routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationScreen(),
        ),
        GoRoute(
          path: '/buyer-register',
          builder: (context, state) => const BuyerRegistrationScreen(),
        ),
        GoRoute(
          path: '/unified-register',
          builder: (context, state) => const UnifiedRegistrationScreen(),
        ),
        GoRoute(
          path: '/registration-test',
          builder: (context, state) => const RegistrationTestPage(),
        ),
        GoRoute(
          path: '/direct-test',
          builder: (context, state) => const DirectTestPage(),
        ),
        
        // Dashboard routes
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const ModernDashboardScreen(), // Modern dashboard is now the default
        ),
        // Legacy dashboard route - kept for backward compatibility
        GoRoute(
          path: '/legacy-dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        
        // Developments route
        GoRoute(
          path: '/developments',
          builder: (context, state) => const ModernDevelopmentsScreen(),
        ),
        
        // Leads route
        GoRoute(
          path: '/leads',
          builder: (context, state) => const ModernLeadsScreen(),
        ),
        
        // Settings route
        GoRoute(
          path: '/settings',
          builder: (context, state) => const ModernSettingsScreen(),
        ),  
        
        // API Service example route
        GoRoute(
          path: '/api-example',
          builder: (context, state) => const ApiServiceExampleScreen(),
        ),
        
        // Email verification route
        GoRoute(
          path: '/email-verification',
          builder: (context, state) {
            // Get email from URI parameters
            // Using state.extra as primary source, then falling back to URI parameters if available
            Map<String, dynamic> extra = {};
            if (state.extra != null && state.extra is Map<String, dynamic>) {
              extra = state.extra as Map<String, dynamic>;
            }
            
            // Get parameters from extra or from the location
            final Uri uri = Uri.parse(state.location);
            final String email = extra['email'] as String? ?? uri.queryParameters['email'] ?? '';
            final String userType = extra['userType'] as String? ?? uri.queryParameters['userType'] ?? '';
            final String fullName = extra['fullName'] as String? ?? uri.queryParameters['fullName'] ?? '';
            
            // Create a callback based on user type
            VoidCallback onVerificationComplete = () {
              // Default to home page
              GoRouter.of(context).go('/home');
            };
            
            // Set the appropriate callback based on user type
            if (userType == 'developer') {
              onVerificationComplete = () {
                GoRouter.of(context).go('/subscription-selection');
              };
            } else if (userType == 'agent') {
              onVerificationComplete = () {
                GoRouter.of(context).go('/approval-status', extra: {'agentName': fullName});
              };
            } else if (userType == 'buyer') {
              onVerificationComplete = () {
                GoRouter.of(context).go('/home');
              };
            }
            
            return EmailVerificationScreen(
              email: email,
              onVerificationComplete: onVerificationComplete,
            );
          },
        ),
        
        // Subscription selection route for developers
        GoRoute(
          path: '/subscription-selection',
          builder: (context, state) => const SubscriptionSelectionScreen(),
        ),
        
        // Payment route for subscription
        GoRoute(
          path: '/payment',
          builder: (context, state) {
            // Try to get plan from both extra and URI parameters
            String plan = 'premium';
            
            // First check if plan is in extra
            if (state.extra != null && state.extra is Map) {
              final Map<dynamic, dynamic> extra = state.extra as Map;
              if (extra.containsKey('plan')) {
                plan = extra['plan'] as String;
                debugPrint('Got plan from extra: $plan');
              }
            }
            
            // If not found in extra, try URI parameters
            if (plan == 'premium') {
              final Uri uri = Uri.parse(state.location);
              if (uri.queryParameters.containsKey('plan')) {
                plan = uri.queryParameters['plan']!;
                debugPrint('Got plan from URI parameters: $plan');
              }
            }
            
            debugPrint('Rendering PaymentScreen with plan: $plan');
            return PaymentScreen(selectedPlan: plan);
          },
        ),
        
        // Approval status route for agents
        GoRoute(
          path: '/approval-status',
          builder: (context, state) {
            final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {};
            final String agentName = extra['agentName'] as String? ?? 'Agent';
            
            return ApprovalStatusScreen(
              agentName: agentName,
            );
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
