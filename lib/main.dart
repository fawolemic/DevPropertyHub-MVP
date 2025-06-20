import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/bandwidth_provider.dart';
import 'core/providers/registration_provider.dart';
import 'core/providers/buyer_registration_provider.dart';
import 'core/providers/unified_registration_provider.dart';
import 'core/providers/supabase_provider.dart';
import 'core/providers/supabase_auth_provider.dart';
import 'core/providers/rbac_provider.dart';
import 'features/developments/providers/project_provider.dart';
import 'features/developments/services/project_service.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize other services and providers here

  // Initialize Supabase provider
  final supabaseProvider = SupabaseProvider();
  await supabaseProvider.initialize();

  // Initialize Supabase auth provider
  final supabaseAuthProvider = SupabaseAuthProvider();
  await supabaseAuthProvider.initAuth();

  runApp(
    provider_package.MultiProvider(
      providers: [
        provider_package.ChangeNotifierProvider.value(value: supabaseProvider),
        provider_package.ChangeNotifierProvider.value(
            value: supabaseAuthProvider),
        provider_package.ChangeNotifierProvider(create: (_) => AuthProvider()),
        provider_package.ChangeNotifierProvider(
            create: (_) => BandwidthProvider()),
        provider_package.ChangeNotifierProvider(
            create: (_) => RegistrationProvider()),
        provider_package.ChangeNotifierProvider(
            create: (_) => BuyerRegistrationProvider()),
        provider_package.ChangeNotifierProvider(
            create: (_) => UnifiedRegistrationProvider()),
        provider_package.ChangeNotifierProvider(
          create: (context) => RBACProvider(
            provider_package.Provider.of<SupabaseAuthProvider>(context,
                listen: false),
          ),
        ),
        // Add ProjectProvider for the development projects feature
        provider_package.ChangeNotifierProvider(
          create: (context) => ProjectProvider(
            projectService: ProjectService(
              baseUrl: 'https://api.devpropertyhub.com', // Placeholder API URL
              headers: {'Authorization': 'Bearer placeholder-token'},
            ),
          ),
        ),
      ],
      child: const DevPropertyHub(),
    ),
  );
}

class DevPropertyHub extends StatelessWidget {
  const DevPropertyHub({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the auth provider to handle user roles
    final authProvider = provider_package.Provider.of<AuthProvider>(context);
    // Access the bandwidth provider to optimize UI based on network conditions
    final bandwidthProvider =
        provider_package.Provider.of<BandwidthProvider>(context);

    return MaterialApp.router(
      title: 'DevPropertyHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light theme
      routerConfig: AppRouter.router(authProvider),
      builder: (context, child) {
        // Apply bandwidth optimizations if needed
        final isLowBandwidth = bandwidthProvider.isLowBandwidth;

        return MediaQuery(
          // Adjust font sizes for low bandwidth mode
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              isLowBandwidth ? 0.9 : 1.0,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
