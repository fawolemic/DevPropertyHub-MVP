import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../../core/providers/unified_registration_provider.dart';
import '../../../../../core/providers/bandwidth_provider.dart';
import '../../../widgets/components/file_upload/document_uploader.dart';

class DeveloperForm extends StatefulWidget {
  const DeveloperForm({Key? key}) : super(key: key);

  @override
  State<DeveloperForm> createState() => _DeveloperFormState();
}

class _DeveloperFormState extends State<DeveloperForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _companyNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _rcNumberController = TextEditingController();
  final _yearsInBusinessController = TextEditingController();
  final _contactPersonController = TextEditingController();
  
  // Track the CAC certificate file path
  String? _cacCertificatePath;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _businessAddressController.dispose();
    _rcNumberController.dispose();
    _yearsInBusinessController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  void _loadSavedData() {
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
    final savedData = registrationProvider.step3Data;
    
    if (savedData.isNotEmpty) {
      _companyNameController.text = savedData['companyName'] ?? '';
      _businessAddressController.text = savedData['businessAddress'] ?? '';
      _rcNumberController.text = savedData['rcNumber'] ?? '';
      _yearsInBusinessController.text = savedData['yearsInBusiness'] ?? '';
      _contactPersonController.text = savedData['contactPerson'] ?? '';
      setState(() {
        _cacCertificatePath = savedData['cacCertificatePath'];
      });
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
      if (registrationProvider.step3Data['hasUploadedCertificate'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload your CAC certificate')),
        );
        return;
      }
      
      final data = {
        'companyName': _companyNameController.text.trim(),
        'businessAddress': _businessAddressController.text.trim(),
        'rcNumber': _rcNumberController.text.trim(),
        'yearsInBusiness': _yearsInBusinessController.text.trim(),
        'contactPerson': _contactPersonController.text.trim(),
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
          // Company Name
          TextFormField(
            controller: _companyNameController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              hintText: 'Enter your company\'s registered name',
              prefixIcon: Icon(Icons.business),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Company name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Business Address
          TextFormField(
            controller: _businessAddressController,
            decoration: const InputDecoration(
              labelText: 'Business Address',
              hintText: 'Enter your company\'s address',
              prefixIcon: Icon(Icons.location_on),
            ),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Business address is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // RC Number
          TextFormField(
            controller: _rcNumberController,
            decoration: InputDecoration(
              labelText: 'RC Number',
              hintText: 'Enter your CAC registration number',
              prefixIcon: const Icon(Icons.badge),
              helperText: 'Your Corporate Affairs Commission registration number',
              helperStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'RC number is required';
              }
              // Simple validation for RC number format (can be enhanced)
              if (!RegExp(r'^[A-Z0-9]{6,}$').hasMatch(value.toUpperCase())) {
                return 'Enter a valid RC number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Years in Business
          TextFormField(
            controller: _yearsInBusinessController,
            decoration: const InputDecoration(
              labelText: 'Years in Business',
              hintText: 'How long has your company been operating?',
              prefixIcon: Icon(Icons.timeline),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Years in business is required';
              }
              final years = int.tryParse(value);
              if (years == null || years < 0) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Contact Person (Optional)
          TextFormField(
            controller: _contactPersonController,
            decoration: const InputDecoration(
              labelText: 'Contact Person Name (Optional)',
              hintText: 'If different from account holder',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 24),
          
          // CAC Certificate Upload using our enhanced component
          DocumentUploader(
            label: 'CAC Certificate',
            acceptedFileTypes: 'pdf, jpg, png',
            isRequired: true,
            maxSizeInMB: 10,
            onFileSelected: (filePath) {
  setState(() {
    _cacCertificatePath = filePath;
  });
  // Always update the provider state via the new setter
  final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
  registrationProvider.setCacCertificateUploaded(filePath);
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
