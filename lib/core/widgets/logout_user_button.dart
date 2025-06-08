import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LogoutUserButton extends StatelessWidget {
  const LogoutUserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final name = auth.currentUser?.firstName ?? 'User';
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(name),
      trailing: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          auth.signOut();
          GoRouter.of(context).go('/login');
        },
      ),
    );
  }
}
