import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_role.dart';

/// UserRolesSection
///
/// Displays the different user roles available on the platform.
/// Contains: Card-based role selection with icons and descriptions.
///
/// SEARCH TAGS: #roles #user-types #developer #buyer #investor
class UserRolesSection extends StatelessWidget {
  final List<UserRole> userRoles;

  const UserRolesSection({
    Key? key,
    required this.userRoles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive layout adjustments
    final int crossAxisCount =
        screenWidth > 1100 ? 3 : (screenWidth > 700 ? 2 : 1);
    final double childAspectRatio = screenWidth > 1100 ? 1.5 : 1.3;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Your Role',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the option that best describes you',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: userRoles.length,
            itemBuilder: (context, index) {
              final role = userRoles[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () async {
                    // Handle role selection - direct to unified registration with role parameter
                    final roleParam = role.type.toLowerCase();

                    // Try using url_launcher with web-specific options
                    final Uri url = Uri.parse(
                        'https://devpropertyhub-mvp.netlify.app/unified-register.html?role=$roleParam');
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                      webOnlyWindowName: '_self',
                    )) {
                      // If url_launcher fails, fallback to Go Router
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Navigating to registration page...')),
                        );
                        GoRouter.of(context)
                            .go('/unified-register?role=$roleParam');
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          role.icon,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          role.type,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          role.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
