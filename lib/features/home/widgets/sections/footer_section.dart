import 'package:flutter/material.dart';
import '../../../../shared/widgets/version_indicator.dart';

/// FooterSection
/// 
/// Footer displayed at the bottom of the home page.
/// Contains: Company information, navigation links, and version indicator.
/// 
/// SEARCH TAGS: #footer #copyright #links #version
class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;
    
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildCompanyInfo(theme)),
                Expanded(child: _buildNavLinks(theme, 'Platform')),
                Expanded(child: _buildNavLinks(theme, 'Resources')),
                Expanded(child: _buildNavLinks(theme, 'Legal')),
              ],
            )
          else
            Column(
              children: [
                _buildCompanyInfo(theme),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildNavLinks(theme, 'Platform')),
                    Expanded(child: _buildNavLinks(theme, 'Resources')),
                  ],
                ),
                const SizedBox(height: 32),
                _buildNavLinks(theme, 'Legal'),
              ],
            ),
          const SizedBox(height: 40),
          Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© ${DateTime.now().year} DevPropertyHub. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const VersionIndicator(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DevPropertyHub',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Connecting property developers with investors and buyers worldwide.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSocialIcon(Icons.facebook, theme),
            _buildSocialIcon(Icons.twitter, theme),
            _buildSocialIcon(Icons.linkedin, theme),
            _buildSocialIcon(Icons.instagram, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          // Handle social media link
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildNavLinks(ThemeData theme, String title) {
    // Define links based on the title
    List<String> links = [];
    switch (title) {
      case 'Platform':
        links = ['How it works', 'Features', 'Pricing', 'Testimonials'];
        break;
      case 'Resources':
        links = ['Blog', 'Guides', 'Help Center', 'Contact'];
        break;
      case 'Legal':
        links = ['Terms of Service', 'Privacy Policy', 'Cookie Policy', 'Disclaimers'];
        break;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                // Handle link navigation
              },
              child: Text(
                link,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
