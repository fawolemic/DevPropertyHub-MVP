# DevPropertyHub-MVP
A Flutter-based property developer portal with Material Design

## Project Overview

DevPropertyHub is a comprehensive platform connecting property developers, buyers, and investors in one marketplace. The application is built with Flutter for web and follows Material Design principles.

---

# Flutter Project Organization Playbook

A comprehensive guide to creating maintainable, discoverable Flutter codebases

## 1. Project Structure

### 1.1 Feature-First Organization
```
lib/
├── core/                  # Core utilities, shared across features
│   ├── component_catalog.dart  # Central reference for all components
│   ├── models/            # Core data models
│   ├── providers/         # State management
│   ├── routes/            # Application routing
│   └── utils/             # Utilities and helpers
├── features/              # Feature modules
│   ├── home/              # Home feature
│   │   ├── README.md      # Feature documentation
│   │   ├── models/        # Feature-specific models
│   │   ├── screens/       # Screen components
│   │   └── widgets/       # UI components
│   │       ├── home_widgets.dart  # Library exports
│   │       ├── sections/   # Logical grouping of components
│   │       └── components/ # Reusable small components
│   └── auth/              # Auth feature (same structure)
└── shared/                # Shared components across features
    ├── layouts/           # Layout templates
    ├── styles/            # Theme and styling
    └── widgets/           # Common widgets
```

### 1.2 Component Organization Guidelines
- **One Component Per File**: Keep files focused on a single responsibility
- **Logical Grouping**: Group related components in subdirectories
- **Library Exports**: Create barrel files (`*_widgets.dart`) to simplify imports
- **README Per Feature**: Document each feature's components and patterns

## 2. Component Design Principles

### 2.1 Component Architecture
- **Single Responsibility**: Each component should do one thing well
- **Composability**: Build complex UIs from simple, reusable components
- **Isolation**: Components should be testable in isolation
- **Stateful vs. Stateless**: Prefer stateless widgets when possible

### 2.2 Component Documentation
```dart
/// HomeHeroSection
/// 
/// The main hero banner displayed at the top of the home page.
/// Contains: Main headline, subtitle, and primary CTA button.
/// 
/// SEARCH TAGS: #home #hero #banner #cta #get-started
class HomeHeroSection extends StatelessWidget {
  // Implementation
}
```

### 2.3 Component Naming Conventions
- **Descriptive Names**: `LoginForm` instead of `Form1`
- **Feature Prefixing**: `HomeAppBar` instead of just `AppBar`
- **Purpose Indication**: `UserRolesSection` clearly indicates purpose
- **Consistency**: Maintain consistent naming patterns

## 3. Code Discoverability Tools

### 3.1 Component Catalog
Maintain a central catalog (`component_catalog.dart`) that serves as a reference guide:

```dart
/// # Navigation Components
/// - HomeAppBar: lib/features/home/widgets/home_app_bar.dart
///   The main app bar for the home screen with the "Get Started" button.
/// 
/// # Home Page Sections
/// - HomeHeroSection: lib/features/home/widgets/sections/home_hero_section.dart
///   The hero banner with headline and subtitle.
```

### 3.2 Search Tags System
Add search tags to all significant components:
```dart
/// SEARCH TAGS: #auth #login #form #validation
```

### 3.3 Component Finder Script
Implement a search utility (`find_component.sh`) to locate components by:
- Search tags
- Class names
- Code content

### 3.4 Region Comments
For larger files, use region comments to improve navigation:
```dart
// #region NAVIGATION COMPONENTS
/// Builds the navigation drawer for mobile devices
Widget _buildDrawer() {
  // Implementation
}
// #endregion
```

## 4. Documentation Practices

### 4.1 Feature README Files
Each feature should have a README.md with:
- Component inventory
- Navigation flows
- Design patterns
- Search tags
- Implementation details

### 4.2 Automated Documentation
Set up automated documentation generation:
- Use `dartdoc` for API documentation
- Document all public APIs
- Include examples for complex components
- Generate documentation as part of CI/CD

### 4.3 Component Headers
Every component should have a header that includes:
- Brief description
- Purpose
- Key functionality
- Search tags

## 5. Development Workflow

### 5.1 Component Creation Checklist
- [ ] Component has a clear, single responsibility
- [ ] Name reflects purpose and feature context
- [ ] Header documentation with search tags
- [ ] Added to appropriate widget library export
- [ ] Referenced in component catalog

### 5.2 Code Review Focus
- Component boundary definition
- Reuse opportunities
- Documentation completeness
- Adherence to naming conventions
- Search tag accuracy

### 5.3 Refactoring Strategy
- Identify components with multiple responsibilities
- Extract logical sections into separate components
- Update documentation and search tags
- Maintain backward compatibility where possible

## 6. Testing Considerations

### 6.1 Component Testing
- Test components in isolation
- Verify responsive behavior
- Test user interactions
- Validate accessibility

### 6.2 Navigation Testing
- Verify routing between components
- Test deep linking
- Validate navigation state preservation

## 7. Project Evolution

### 7.1 Component Lifecycle Management
- Document component deprecations
- Version components when API changes
- Communicate breaking changes

### 7.2 Scaling Strategies
- Split large features into sub-features
- Extract common patterns into shared components
- Regularly update component catalog

## 8. Implementation Examples

### 8.1 Feature Library Export
```dart
/// Home Widgets Library
library home_widgets;

// App bar and navigation
export 'home_app_bar.dart';
export 'mobile_navigation_drawer.dart';

// Home page sections
export 'sections/home_hero_section.dart';
export 'sections/home_search_container.dart';
```

### 8.2 Component Refactoring
Before:
```dart
// Large monolithic screen with multiple sections
class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeroSection(),
        _buildSearchSection(),
        _buildFeaturedSection(),
      ],
    );
  }
  
  Widget _buildHeroSection() { /* 100 lines of code */ }
  Widget _buildSearchSection() { /* 80 lines of code */ }
  Widget _buildFeaturedSection() { /* 120 lines of code */ }
}
```

After:
```dart
// Clean screen composition using components
class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeHeroSection(),
        HomeSearchContainer(),
        FeaturedPropertiesSection(),
      ],
    );
  }
}
```

## Developments Page CTA

The `/developments` screen now features a prominent “Add Development Project” CTA button at the top of the list. This button:
- Uses `ElevatedButton.icon` with an add icon and the label “Add Development Project”.
- Is visible on all screen sizes (desktop and mobile) and positioned for high visibility.
- Navigates to the Add Development wizard via `GoRouter` at `/developments/add`.
