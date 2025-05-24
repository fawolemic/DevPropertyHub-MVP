# DevPropertyHub Design System

This document outlines the design system for the DevPropertyHub application, based on Material Design principles with custom branding elements. The design system focuses on providing a consistent, accessible, and responsive user interface optimized for the African market.

## Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| **Primary Navy** | `#1B2B4D` | Headers, CTA buttons, Navigation |
| **Primary Navy Light** | `#2A3B5D` | Hover states, Secondary elements |
| **Primary Navy Dark** | `#0F1B35` | Active states, Shadows |
| **Secondary Gold** | `#D4A574` | Accents, Highlights, Secondary buttons |
| **Secondary Gold Light** | `#E2B884` | Hover states for secondary elements |
| **Secondary Gold Dark** | `#C29764` | Active states for secondary elements |
| **Accent Teal** | `#2D7D7D` | Progress indicators, Links, Analytics |
| **Accent Teal Light** | `#3D8D8D` | Hover states for accent elements |
| **Accent Teal Dark** | `#1D6D6D` | Active states for accent elements |

## Supporting Colors

| Color | Hex | Usage |
|-------|-----|-------|
| **Background Light** | `#F8F9FA` | Page backgrounds |
| **Background White** | `#FFFFFF` | Card backgrounds, Form fields |
| **Text Primary** | `#212529` | Main text content |
| **Text Secondary** | `#6C757D` | Secondary text, Labels |
| **Text Light** | `#ADB5BD` | Placeholders, Disabled text |

## Status Colors

| Color | Hex | Usage |
|-------|-----|-------|
| **Success** | `#28A745` | Positive actions, Completed states |
| **Warning** | `#FD7E14` | Alerts, Pending states |
| **Error** | `#DC3545` | Errors, Destructive actions |
| **Info** | `#17A2B8` | Informational messages |

## Typography

The DevPropertyHub uses the **Inter** font family for all text elements:

| Style | Properties | Usage |
|-------|------------|-------|
| **Display Large** | 32px / Bold / 1.2 line height | Main page headers |
| **Display Medium** | 28px / SemiBold / 1.3 line height | Section headers |
| **Display Small** | 24px / SemiBold / 1.3 line height | Card titles, Modal headers |
| **Headline Medium** | 20px / Medium / 1.4 line height | Subsection headers |
| **Headline Small** | 18px / Medium / 1.4 line height | Important labels |
| **Title Large** | 16px / Medium / 1.4 line height | Card titles, Form labels |
| **Body Large** | 16px / Regular / 1.5 line height | Main content text |
| **Body Medium** | 14px / Regular / 1.5 line height | Secondary content |
| **Body Small** | 12px / Regular / 1.4 line height | Captions, Helper text |

## Spacing

| Size | Value | Usage |
|------|-------|-------|
| **XS** | 4px | Minimum spacing, tight alignments |
| **SM** | 8px | Icon padding, tight spacing |
| **MD** | 16px | Standard spacing, padding |
| **LG** | 24px | Section spacing |
| **XL** | 32px | Component separation |
| **XXL** | 48px | Major section spacing |

## Border Radius

| Size | Value | Usage |
|------|-------|-------|
| **Small** | 4px | Small elements (chips, tags) |
| **Medium** | 8px | Buttons, Form inputs |
| **Large** | 12px | Cards, Modal dialogs |
| **XLarge** | 16px | Floating panels, Drawers |

## Elevation & Shadows

| Level | Usage | Description |
|-------|-------|-------------|
| **Elevation 1** | Cards, Buttons | Subtle lift (1-3px blur) |
| **Elevation 2** | Hover states, Active cards | Medium lift (3-6px blur) |
| **Elevation 3** | Modals, Dropdowns | Pronounced lift (10-20px blur) |
| **Elevation 4** | Navigation drawer | Maximum lift (14-28px blur) |

## Components

### Buttons

| Type | Description | Usage |
|------|-------------|-------|
| **Primary** | Navy background, White text | Main actions, Form submissions |
| **Secondary** | Gold background, Navy text | Alternative actions, Highlights |
| **Outline** | Transparent background, Navy border | Secondary actions |
| **Text** | No background, Navy text | Tertiary actions, Links |

### Status Indicators

| Type | Description | Usage |
|------|-------------|-------|
| **Success** | Green text/border, Light green background | Completed, Verified |
| **Warning** | Orange text/border, Light orange background | Pending, Attention needed |
| **Error** | Red text/border, Light red background | Errors, Warnings |
| **Info** | Blue text/border, Light blue background | Information, Notes |

## Usage Guidelines

### For Role-Based UI

Our application supports three user roles, each with different UI requirements:

1. **Admin Developer**
   - Access to all UI components and actions
   - Complete sidebar navigation
   - Management controls visible

2. **Standard Developer**
   - Limited settings access
   - Project-scoped actions
   - Restricted user management

3. **Viewer Developer**
   - Read-only interface
   - No action buttons for editing
   - Simplified navigation

### Low-Bandwidth Considerations

For users in low-bandwidth environments (common in the African market):

- Reduced image resolutions
- Simplified animations
- Text-based alternatives where possible
- Compressed assets
- Progressive loading indicators

## Implementation

All design system elements are implemented in:

```dart
lib/core/theme/app_theme.dart
```

To use the design system in your widgets:

```dart
// Access theme colors
final primaryColor = Theme.of(context).colorScheme.primary;

// Access text styles
final headlineStyle = Theme.of(context).textTheme.headlineMedium;

// Use helper methods for consistent components
final cardDecoration = AppTheme.cardElevation2;
final successStatusDecoration = AppTheme.statusSuccess();
```

## Common Patterns

### Progress Indicators

```dart
// Create a progress bar at 65%
AppTheme.progressIndicator(0.65)

// With custom color
AppTheme.progressIndicator(0.65, color: AppTheme.secondaryGold)
```

### Status Indicators

```dart
Container(
  decoration: AppTheme.statusSuccess(),
  padding: const EdgeInsets.all(AppTheme.spaceMD),
  child: Text('Verified', style: AppTheme.successTextStyle),
)
```

This design system is a living document and will evolve as the DevPropertyHub application grows.
