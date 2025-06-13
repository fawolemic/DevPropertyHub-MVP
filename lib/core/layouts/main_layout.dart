import 'package:flutter/material.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_header.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget child;

  const MainLayout({
    Key? key,
    required this.title,
    this.actions,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: const Drawer(child: AppSidebar()),
      appBar: AppHeader(title: title, actions: actions),
      body: Row(
        children: [
          if (isDesktop) const AppSidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
