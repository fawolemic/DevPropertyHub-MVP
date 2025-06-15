import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/buyer_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';

class Step2PreferencesScreen extends StatefulWidget {
  const Step2PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<Step2PreferencesScreen> createState() => _Step2PreferencesScreenState();
}

class _Step2PreferencesScreenState extends State<Step2PreferencesScreen> {
  final _formKey = GlobalKey<FormState>();

  // Property type preferences
  final List<String> _availablePropertyTypes = [
    'Apartment',
    'House',
    'Land',
    'Commercial',
    'Office Space',
    'Warehouse',
    'Mixed-Use',
  ];
  List<String> _selectedPropertyTypes = [];

  // Location preferences
  final List<String> _availableLocations = [
    'Lagos - Mainland',
    'Lagos - Island',
    'Abuja - Central',
    'Abuja - Suburbs',
    'Port Harcourt',
    'Ibadan',
    'Kano',
    'Enugu',
    'Calabar',
    'Kaduna',
  ];
  List<String> _selectedLocations = [];

  // Budget range
  String _budgetRange = 'NGN 10M - 30M';
  final List<String> _availableBudgetRanges = [
    'Under NGN 5M',
    'NGN 5M - 10M',
    'NGN 10M - 30M',
    'NGN 30M - 50M',
    'NGN 50M - 100M',
    'Above NGN 100M',
  ];

  // Additional preferences
  bool _interestedInMortgage = false;
  bool _interestedInInvestmentProperties = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    final registrationProvider =
        provider_package.Provider.of<BuyerRegistrationProvider>(context,
            listen: false);
    final savedData = registrationProvider.step2Data;

    if (savedData.isNotEmpty) {
      setState(() {
        _selectedPropertyTypes =
            List<String>.from(savedData['propertyTypes'] ?? []);
        _selectedLocations =
            List<String>.from(savedData['preferredLocations'] ?? []);
        _budgetRange = savedData['budgetRange'] ?? 'NGN 10M - 30M';
        _interestedInMortgage = savedData['interestedInMortgage'] ?? false;
        _interestedInInvestmentProperties =
            savedData['interestedInInvestmentProperties'] ?? false;
      });
    }
  }

  void _submitStep() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPropertyTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select at least one property type')),
        );
        return;
      }

      if (_selectedLocations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select at least one preferred location')),
        );
        return;
      }

      final data = {
        'propertyTypes': _selectedPropertyTypes,
        'preferredLocations': _selectedLocations,
        'budgetRange': _budgetRange,
        'interestedInMortgage': _interestedInMortgage,
        'interestedInInvestmentProperties': _interestedInInvestmentProperties,
      };

      final registrationProvider =
          provider_package.Provider.of<BuyerRegistrationProvider>(context,
              listen: false);

      if (registrationProvider.nextStep(data)) {
        // This was the last step, submit registration
        registrationProvider.submitRegistration();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider =
        provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider =
        provider_package.Provider.of<BuyerRegistrationProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: isLowBandwidth ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isLowBandwidth
                  ? BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.5))
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Preferences',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us what you\'re looking for to help us find the perfect property for you',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Property Types Section
                    Text(
                      'Property Types',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select all that interest you',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Property type chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availablePropertyTypes.map((propertyType) {
                        final isSelected =
                            _selectedPropertyTypes.contains(propertyType);
                        return FilterChip(
                          label: Text(propertyType),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedPropertyTypes.add(propertyType);
                              } else {
                                _selectedPropertyTypes.remove(propertyType);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Location Preferences Section
                    Text(
                      'Preferred Locations',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select all locations you\'re interested in',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Location chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableLocations.map((location) {
                        final isSelected =
                            _selectedLocations.contains(location);
                        return FilterChip(
                          label: Text(location),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedLocations.add(location);
                              } else {
                                _selectedLocations.remove(location);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Budget Range Section
                    Text(
                      'Budget Range',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Budget range dropdown
                    DropdownButtonFormField<String>(
                      value: _budgetRange,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      items: _availableBudgetRanges.map((range) {
                        return DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _budgetRange = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Additional Preferences Section
                    Text(
                      'Additional Preferences',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Mortgage Interest
                    CheckboxListTile(
                      title: const Text('Interested in mortgage options'),
                      subtitle: const Text(
                          'I would like information about financing and mortgage options'),
                      value: _interestedInMortgage,
                      onChanged: (value) {
                        setState(() {
                          _interestedInMortgage = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),

                    // Investment Properties
                    CheckboxListTile(
                      title: const Text('Looking for investment properties'),
                      subtitle: const Text(
                          'I\'m interested in properties for investment purposes'),
                      value: _interestedInInvestmentProperties,
                      onChanged: (value) {
                        setState(() {
                          _interestedInInvestmentProperties = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    const SizedBox(height: 32),

                    const Divider(),
                    const SizedBox(height: 24),

                    // Navigation buttons
                    Row(
                      children: [
                        // Back button
                        OutlinedButton(
                          onPressed: registrationProvider.isLoading
                              ? null
                              : () {
                                  registrationProvider.previousStep();
                                },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          child: const Text('Back'),
                        ),
                        const SizedBox(width: 16),

                        // Submit button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: registrationProvider.isLoading
                                ? null
                                : _submitStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: registrationProvider.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text('Complete Registration'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
