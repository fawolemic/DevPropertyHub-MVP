import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A simple test page to verify routing functionality
class DirectTestPage extends StatelessWidget {
  const DirectTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routing Test Page'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is a direct test page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deployment time: 2025-05-25 17:18',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text('Go to Home'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () => launchUrl(Uri.parse('https://devpropertyhub-mvp.netlify.app/unified-register.html')),
              child: const Text('Go to Unified Registration'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () => GoRouter.of(context).go('/registration-test'),
              child: const Text('Go to Registration Test Page'),
            ),
          ],
        ),
      ),
    );
  }
}
