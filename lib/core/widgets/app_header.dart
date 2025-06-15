import 'package:flutter/material.dart';
import '../widgets/logout_user_button.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppHeader({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade700),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
      ),
      leading: isDesktop
          ? null
          : Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
      actions: [
        if (actions != null) ...actions!,
        const LogoutUserButton(),
      ],
    );
  }
}
