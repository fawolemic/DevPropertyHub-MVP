# Authentication Feature

This directory contains all components related to the authentication functionality of DevPropertyHub.

## Key Components

### Screens
- `screens/login_screen.dart`: User login screen
- `screens/registration_test_page.dart`: Test page for registration routing
- `screens/unified_registration/`: Unified registration flow components
- `screens/buyer_registration/`: Buyer-specific registration components

### Widgets
- `widgets/components/login_form.dart`: Reusable login form component
- `widgets/components/auth_page_layout.dart`: Layout template for authentication pages

### Utilities
- `widgets/auth_widgets.dart`: Library file that exports all auth components

## Authentication Flow

The application uses a unified registration approach with role-specific screens:

1. Users start at the unified registration entry point (`/unified-register.html`)
2. They select their role (Developer, Buyer, etc.)
3. Role-specific forms are presented based on the selection
4. Upon successful registration, users are directed to the appropriate dashboard

## Direct URL Approach

Due to routing issues with Flutter web on Netlify, direct HTML pages are used:
- `unified-register.html`: Entry point for the registration process
- `routing-test.html`: Test page for verifying routing functionality

## Design Patterns

- **Component-Based Architecture**: Auth UI is broken down into reusable components
- **Responsive Design**: All auth screens adapt to different screen sizes
- **Form Validation**: Consistent validation patterns across all auth forms

## Search Tags

To quickly locate components in this feature, search for these tags:
- `#auth` - General authentication components
- `#login` - Login-related components
- `#registration` - Registration-related components
- `#form` - Form components for data collection
- `#validation` - Input validation logic
