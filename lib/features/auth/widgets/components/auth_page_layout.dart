import 'package:flutter/material.dart';

/// AuthPageLayout
/// 
/// A reusable layout component for authentication pages.
/// Features a responsive layout with a left side image/illustration
/// and content area on the right.
/// 
/// SEARCH TAGS: #auth #layout #responsive #login-page #registration-page
class AuthPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final String? imagePath;
  final bool isLowBandwidth;
  final Widget? bottomContent;

  const AuthPageLayout({
    Key? key,
    required this.title,
    this.subtitle,
    required this.content,
    this.imagePath,
    this.isLowBandwidth = false,
    this.bottomContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;
    
    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? _buildDesktopLayout(theme, size)
            : _buildMobileLayout(theme, size),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme, Size size) {
    return Row(
      children: [
        // Left side - Image or illustration
        if (!isLowBandwidth) ...[
          Expanded(
            flex: 5,
            child: Container(
              color: theme.colorScheme.primary,
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      fit: BoxFit.cover,
                      height: double.infinity,
                    )
                  : Center(
                      child: Icon(
                        Icons.business,
                        size: 120,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
            ),
          ),
        ],
        
        // Right side - Content
        Expanded(
          flex: isLowBandwidth ? 10 : 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - 80,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  
                  // Main content
                  content,
                  
                  // Bottom content if provided
                  if (bottomContent != null) ...[
                    const SizedBox(height: 40),
                    bottomContent!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData theme, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional header image for mobile
            if (!isLowBandwidth && imagePath != null) ...[
              Center(
                child: SizedBox(
                  height: 200,
                  child: Image.asset(
                    imagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
            
            // Header
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            const SizedBox(height: 32),
            
            // Main content
            content,
            
            // Bottom content if provided
            if (bottomContent != null) ...[
              const SizedBox(height: 32),
              bottomContent!,
            ],
          ],
        ),
      ),
    );
  }
}
