import 'package:flutter/material.dart';

class ModernSidebar extends StatelessWidget {
  final String activeSection;
  final Function(String) onSectionChanged;
  final bool isMobile;
  final VoidCallback? onClose;

  const ModernSidebar({
    Key? key,
    required this.activeSection,
    required this.onSectionChanged,
    this.isMobile = false,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 2,
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primary,
            child: Row(
              children: [
                Icon(Icons.business, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'DevPropertyHub',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (isMobile && onClose != null)
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: onClose,
                  ),
              ],
            ),
          ),
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                    context, 'Dashboard', Icons.dashboard, 'dashboard'),
                _buildNavItem(
                    context, 'Developments', Icons.business, 'developments'),
                _buildNavItem(context, 'Leads', Icons.people, 'leads'),
                _buildNavItem(context, 'Settings', Icons.settings, 'settings'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String title, IconData icon, String section) {
    final theme = Theme.of(context);
    final isActive = activeSection == section;

    return ListTile(
      leading: Icon(icon,
          color: isActive ? theme.colorScheme.primary : Colors.grey.shade600),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? theme.colorScheme.primary : Colors.grey.shade800,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isActive ? theme.colorScheme.primary.withOpacity(0.1) : null,
      onTap: () => onSectionChanged(section),
    );
  }
}
