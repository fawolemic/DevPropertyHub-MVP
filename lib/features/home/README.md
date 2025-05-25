# Home Feature

This directory contains all components related to the home screen of DevPropertyHub.

## Key Components

### Screens
- `screens/home_screen.dart`: Main container for the home page

### Widgets
- `widgets/home_app_bar.dart`: App bar with "Get Started" button
- `widgets/mobile_navigation_drawer.dart`: Mobile navigation drawer

### Section Components
- `widgets/sections/home_hero_section.dart`: Hero banner with headline
- `widgets/sections/home_search_container.dart`: Search box and filters
- `widgets/sections/user_roles_section.dart`: User role selection cards
- `widgets/sections/stats_section.dart`: Platform statistics
- `widgets/sections/featured_properties_section.dart`: Featured properties carousel
- `widgets/sections/cta_section.dart`: Call-to-action section
- `widgets/sections/footer_section.dart`: Footer with links and copyright

### Models
- `models/user_role.dart`: User role data model
- `models/stat_item.dart`: Statistics data model
- `models/featured_property.dart`: Featured property data model

## Navigation Flow

The home screen contains a "Get Started" button in the app bar that directs users 
to the unified registration page at `/unified-register.html`.

## Design Patterns

- **Component-Based Architecture**: Each section of the home page is implemented as a separate component for better maintainability.
- **Responsive Design**: Components adjust their layout based on screen size.
- **Low Bandwidth Mode**: Images and heavy assets can be conditionally loaded based on bandwidth constraints.

## Search Tags

To quickly locate components in this feature, search for these tags:
- `#home` - General home screen components
- `#hero` - Hero section components
- `#search` - Search functionality
- `#featured` - Featured properties
- `#cta` - Call-to-action components
- `#footer` - Footer section
- `#navigation` - Navigation components
