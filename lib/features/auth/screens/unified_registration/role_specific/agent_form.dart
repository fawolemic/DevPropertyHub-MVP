import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../../core/providers/unified_registration_provider.dart';
import '../../../../../core/providers/bandwidth_provider.dart';
import '../../../widgets/components/file_upload/document_uploader.dart';

class AgentForm extends StatefulWidget {
  const AgentForm({Key? key}) : super(key: key);

  @override
  State<AgentForm> createState() => _AgentFormState();
}

class _AgentFormState extends State<AgentForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _invitationCodeController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _bioController = TextEditingController();
  
  // Document upload
  String? _licenseDocumentPath;
  
  // Specialization areas
  final List<String> _availableSpecializations = [
    'Residential',
    'Commercial',
    'Industrial',
    'Land',
    'Luxury Properties',
    'Rentals',
    'Affordable Housing',
    'International',
  ];
  List<String> _selectedSpecializations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _invitationCodeController.dispose();
    _licenseNumberController.dispose();
    _yearsOfExperienceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _loadSavedData() {
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
    final savedData = registrationProvider.step3Data;
    
    if (savedData.isNotEmpty) {
      _invitationCodeController.text = savedData['invitationCode'] ?? '';
      _licenseNumberController.text = savedData['licenseNumber'] ?? '';
      _yearsOfExperienceController.text = savedData['yearsOfExperience'] ?? '';
      _bioController.text = savedData['bio'] ?? '';
      _licenseDocumentPath = savedData['licenseDocumentPath'];
      setState(() {
        _selectedSpecializations = List<String>.from(savedData['specializations'] ?? []);
      });
    }
    
    // If we already have invitation code from step 1
    if (_invitationCodeController.text.isEmpty && registrationProvider.step1Data.containsKey('invitationCode')) {
      _invitationCodeController.text = registrationProvider.step1Data['invitationCode'];
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSpecializations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one specialization area')),
        );
        return;
      }
      
      if (_licenseDocumentPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload your license document')),
        );
        return;
      }
      
      final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
      
      // Make sure the license document is marked as uploaded in the provider
      registrationProvider.setLicenseDocumentUploaded(_licenseDocumentPath);
      
      final data = {
        'invitationCode': _invitationCodeController.text.trim(),
        'licenseNumber': _licenseNumberController.text.trim(),
        'yearsOfExperience': _yearsOfExperienceController.text.trim(),
        'bio': _bioController.text.trim(),
        'specializations': _selectedSpecializations,
      };
      
      if (registrationProvider.nextStep(data)) {
        // If this is the final step, submit registration
        registrationProvider.submitRegistration();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invitation Code
          TextFormField(
            controller: _invitationCodeController,
            decoration: const InputDecoration(
              labelText: 'Invitation Code',
              hintText: 'Enter the code you received from a developer',
              prefixIcon: Icon(Icons.vpn_key),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Invitation code is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // License Number
          TextFormField(
            controller: _licenseNumberController,
            decoration: const InputDecoration(
              labelText: 'Professional License Number',
              hintText: 'Enter your real estate license number',
              prefixIcon: Icon(Icons.badge),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'License number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Years of Experience
          TextFormField(
            controller: _yearsOfExperienceController,
            decoration: const InputDecoration(
              labelText: 'Years of Experience',
              hintText: 'How long have you worked as an agent?',
              prefixIcon: Icon(Icons.timeline),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Years of experience is required';
              }
              final years = int.tryParse(value);
              if (years == null || years < 0) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Specialization Areas
          Text(
            'Specialization Areas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select all areas you specialize in',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          
          // Specialization chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSpecializations.map((specialization) {
              final isSelected = _selectedSpecializations.contains(specialization);
              return FilterChip(
                label: Text(specialization),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSpecializations.add(specialization);
                    } else {
                      _selectedSpecializations.remove(specialization);
                    }
                  });
                },
                selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Bio/Description
          TextFormField(
            controller: _bioController,
            decoration: const InputDecoration(
              labelText: 'Brief Bio/Description',
              hintText: 'Tell developers about yourself and your experience',
              prefixIcon: Icon(Icons.description),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            minLines: 3,
          ),
          const SizedBox(height: 24),
          
          // License Document Upload
          DocumentUploader(
            label: 'License Document',
            acceptedFileTypes: 'PDF, JPG, PNG',
            maxSizeInMB: 5,
            onFileSelected: (path) {
  setState(() {
    _licenseDocumentPath = path;
  });
  // Use the provider's method to update the state properly
  final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
  registrationProvider.setLicenseDocumentUploaded(path);
},
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                child: const Text('Back'),
              ),
              const SizedBox(width: 16),
              
              // Continue button
              Expanded(
                child: ElevatedButton(
                  onPressed: registrationProvider.isLoading ? null : _submitForm,
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
