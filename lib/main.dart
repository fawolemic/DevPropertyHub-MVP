import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/bandwidth_provider.dart';
import 'core/providers/registration_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services and providers here
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BandwidthProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
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
    final authProvider = Provider.of<AuthProvider>(context);
    // Access the bandwidth provider to optimize UI based on network conditions
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    
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
