import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../../core/providers/unified_registration_provider.dart';
import '../../../../../core/providers/bandwidth_provider.dart';
import '../../../widgets/components/selection/location_multi_select.dart';

class BuyerForm extends StatefulWidget {
  const BuyerForm({Key? key}) : super(key: key);

  @override
  State<BuyerForm> createState() => _BuyerFormState();
}

class _BuyerFormState extends State<BuyerForm> {
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
        provider_package.Provider.of<UnifiedRegistrationProvider>(context,
            listen: false);
    final savedData = registrationProvider.step3Data;

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

  void _submitForm() {
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
          provider_package.Provider.of<UnifiedRegistrationProvider>(context,
              listen: false);

      if (registrationProvider.nextStep(data)) {
        // If this is the final step, submit registration
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
        provider_package.Provider.of<UnifiedRegistrationProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              final isSelected = _selectedPropertyTypes.contains(propertyType);
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
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Location Preferences Section using enhanced multi-select component
          LocationMultiSelect(
            availableLocations: _availableLocations,
            selectedLocations: _selectedLocations,
            onChanged: (locations) {
              setState(() {
                _selectedLocations = locations;
              });
            },
            label: 'Preferred Locations',
            isRequired: true,
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                child: const Text('Back'),
              ),
              const SizedBox(width: 16),

              // Continue button
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      registrationProvider.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: registrationProvider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
