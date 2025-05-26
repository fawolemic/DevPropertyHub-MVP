# Registration Flow Components

## Overview

This document provides a comprehensive guide to all components involved in the DevPropertyHub registration flow. The registration journey is divided into multiple steps, with role-specific forms and additional setup screens depending on the user type selected.

## Core Components

### 1. Validation Components

#### PasswordValidator
- **File**: `lib/features/auth/widgets/components/validation/password_validator.dart`
- **Description**: Provides static methods for validating passwords and calculating password strength.
- **Features**:
  - Validation against security requirements (length, uppercase, digits)
  - Password strength calculation on a scale of 0-4
  - Color-coded strength indicators
  - User-friendly validation messages
- **Usage**:
```dart
// Validate a password
String? errorMessage = PasswordValidator.validate(password);

// Calculate password strength
int strength = PasswordValidator.calculateStrength(password);
Color strengthColor = PasswordValidator.getStrengthColor(strength);
String strengthText = PasswordValidator.getStrengthText(strength);
```

#### PasswordStrengthIndicator
- **File**: `lib/features/auth/widgets/components/validation/password_strength_indicator.dart`
- **Description**: Visual component that displays password strength with a progress bar and tips.
- **Features**:
  - Color-coded progress bar
  - Strength level text (Very Weak to Very Strong)
  - Tips for improving password strength
  - Visual indicators for satisfied requirements
- **Usage**:
```dart
PasswordStrengthIndicator(
  password: _passwordController.text,
)
```

### 2. Input Components

#### TermsAndConditionsCheckbox
- **File**: `lib/features/auth/widgets/components/terms_and_conditions.dart`
- **Description**: Reusable checkbox component for terms and conditions acceptance.
- **Features**:
  - Clickable links to terms of service and privacy policy
  - Error message display
  - Customizable URLs
- **Usage**:
```dart
TermsAndConditionsCheckbox(
  value: _acceptTerms,
  onChanged: (value) => setState(() => _acceptTerms = value ?? false),
  errorText: _showErrors && !_acceptTerms 
      ? 'You must accept the terms and conditions to continue' 
      : null,
)
```

#### DocumentUploader
- **File**: `lib/features/auth/widgets/components/file_upload/document_uploader.dart`
- **Description**: Component for handling document uploads with visual feedback.
- **Features**:
  - File type and size validation
  - Upload progress indicator
  - File preview after upload
  - Error handling
- **Usage**:
```dart
DocumentUploader(
  label: 'CAC Certificate',
  acceptedFileTypes: 'pdf, jpg, png',
  isRequired: true,
  onFileSelected: (filePath) {
    setState(() {
      _cacCertificatePath = filePath;
    });
  },
)
```

#### LocationMultiSelect
- **File**: `lib/features/auth/widgets/components/selection/location_multi_select.dart`
- **Description**: Component for selecting multiple locations with search capability.
- **Features**:
  - Searchable location list
  - Multi-select functionality
  - Chips for selected locations
  - No results handling
- **Usage**:
```dart
LocationMultiSelect(
  availableLocations: _availableLocations,
  selectedLocations: _selectedLocations,
  onChanged: (locations) {
    setState(() {
      _selectedLocations = locations;
    });
  },
  label: 'Preferred Locations',
)
```

### 3. Registration Screens

#### UnifiedRegistrationScreen
- **File**: `lib/features/auth/screens/unified_registration/unified_registration_screen.dart`
- **Description**: Main container for the multi-step registration process.
- **Features**:
  - Progress indicator
  - Step-by-step navigation
  - Back/continue buttons
  - Dynamic content based on current step
  
#### Step1UserTypeScreen
- **File**: `lib/features/auth/screens/unified_registration/step1_user_type.dart`
- **Description**: Selection screen for user type (Developer, Buyer, Agent).
- **Features**:
  - Visual cards for each user type
  - Role descriptions
  - Selection state management

#### Step2BasicInfoScreen
- **File**: `lib/features/auth/screens/unified_registration/step2_basic_info.dart`
- **Description**: Form for collecting basic user information.
- **Features**:
  - Personal information fields
  - Password creation with strength indicator
  - Terms and conditions acceptance
  - Form validation

#### Step3RoleSpecificScreen
- **File**: `lib/features/auth/screens/unified_registration/step3_role_specific.dart`
- **Description**: Container for role-specific forms.
- **Features**:
  - Dynamic form loading based on user type
  - Role-specific form validation
  - Consistent UI across different forms

#### RegistrationCompleteScreen
- **File**: `lib/features/auth/screens/unified_registration/registration_complete.dart`
- **Description**: Success screen with role-specific next steps.
- **Features**:
  - Success confirmation
  - Role-specific next step guidance
  - Navigation to additional setup screens

### 4. Role-Specific Forms

#### DeveloperForm
- **File**: `lib/features/auth/screens/unified_registration/role_specific/developer_form.dart`
- **Description**: Form for collecting developer-specific information.
- **Features**:
  - Company information fields
  - Business address
  - Document upload for CAC certificate
  - Years in business

#### BuyerForm
- **File**: `lib/features/auth/screens/unified_registration/role_specific/buyer_form.dart`
- **Description**: Form for collecting buyer preferences.
- **Features**:
  - Property type selection
  - Location preferences with multi-select
  - Budget range selection
  - Additional preferences

#### AgentForm
- **File**: `lib/features/auth/screens/unified_registration/role_specific/agent_form.dart`
- **Description**: Form for collecting agent professional information.
- **Features**:
  - License number
  - Years of experience
  - Specialization areas
  - Invitation code (if applicable)

### 5. Additional Setup Screens

#### SubscriptionSelectionScreen
- **File**: `lib/features/auth/screens/additional_setup/developer/subscription_selection.dart`
- **Description**: Screen for developers to select subscription plans.
- **Features**:
  - Multiple plan options with features
  - Visual selection cards
  - Pricing information
  - Continue to payment or skip options

## Component Relationships

The registration flow components work together in the following hierarchy:

1. **UnifiedRegistrationScreen** (main container)
   - Contains step indicator and navigation
   - Manages current step state
   
2. **Step Screens** (loaded based on current step)
   - Step 1: User Type Selection
   - Step 2: Basic Information (uses validation components)
   - Step 3: Role-Specific Information (loads appropriate form)
   - Step 4: Registration Complete (shows next steps)
   
3. **Role-Specific Forms** (loaded based on user type)
   - Each form uses appropriate input components
   - DeveloperForm uses DocumentUploader
   - BuyerForm uses LocationMultiSelect
   - AgentForm uses specialized inputs
   
4. **Additional Setup** (launched after registration)
   - SubscriptionSelectionScreen for developers
   - Future: Email verification, account setup screens

## State Management

The registration flow uses the `UnifiedRegistrationProvider` to manage state across all steps:

```dart
final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context);

// Access current step
int currentStep = registrationProvider.currentStep;

// Access user type
UserType? userType = registrationProvider.userType;

// Access stored data
Map<String, dynamic> step1Data = registrationProvider.step1Data;

// Save data and advance
bool success = registrationProvider.nextStep({
  'key1': 'value1',
  'key2': 'value2',
});
```

## Testing

Each component includes comprehensive unit tests and widget tests to ensure functionality:

- Validation logic tests
- Component rendering tests
- User interaction tests
- Integration tests for complete flows

See the [Registration Flow Test Plan](../test_plans/registration_flow_test_plan.md) for detailed testing information.

## Design Patterns

The registration components follow these design patterns:

1. **Composition over inheritance** - Components are composed from smaller, reusable parts
2. **Provider pattern** - Centralized state management through providers
3. **Single responsibility** - Each component has a clear, focused purpose
4. **Progressive disclosure** - Complex information is revealed progressively through steps

## Future Enhancements

Planned enhancements for the registration flow:

1. **Social sign-in integration** - Allow registration via Google, Facebook, etc.
2. **Multi-language support** - Internationalization for all registration forms
3. **Biometric authentication** - Add fingerprint/face ID options for mobile
4. **Advanced validation** - Phone number formatting, email verification codes
5. **Analytics integration** - Track completion rates and abandonment points

## Conclusion

The registration flow components provide a comprehensive, modular system for user onboarding that can be easily extended and maintained. By following the component-based architecture and proper state management, we ensure a seamless user experience across all steps of the registration process.
