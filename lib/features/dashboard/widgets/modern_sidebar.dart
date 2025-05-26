import 'package:flutter/material.dart';

/// A modern sidebar widget for the dashboard
/// 
/// Displays navigation options and user information
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
    
    return Container(
      width: 256,
      color: Colors.white,
      child: Column(
        children: [
          // Header with logo and close button
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DevPropertyHub',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                if (isMobile && onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    color: Colors.grey.shade500,
                  ),
              ],
            ),
          ),
          
          // Navigation items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _buildNavItem(
                    context,
                    'overview',
                    'Overview',
                    Icons.home,
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    context,
                    'properties',
                    'Properties',
                    Icons.business,
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    context,
                    'leads',
                    'Recent Leads',
                    Icons.people,
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    context,
                    'analytics',
                    'Analytics',
                    Icons.bar_chart,
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    context,
                    'documents',
                    'Documents',
                    Icons.visibility,
                  ),
                  const SizedBox(height: 8),
                  _buildNavItem(
                    context,
                    'settings',
                    'Settings',
                    Icons.settings,
                  ),
                ],
              ),
            ),
          ),
          
          // Upgrade promo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Pro',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get advanced analytics and unlimited listings',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Upgrade action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Upgrade Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(
    BuildContext context,
    String id,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isActive = activeSection == id;
    
    return InkWell(
      onTap: () {
        onSectionChanged(id);
        if (isMobile && onClose != null) {
          onClose!();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          border: isActive
              ? Border.all(color: theme.colorScheme.primary.withOpacity(0.3))
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? theme.colorScheme.primary : Colors.grey.shade700,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? theme.colorScheme.primary : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
