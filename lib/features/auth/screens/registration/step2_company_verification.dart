import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/bandwidth_provider.dart';
import '../../../../core/providers/registration_provider.dart';

class Step2CompanyVerificationScreen extends StatefulWidget {
  const Step2CompanyVerificationScreen({Key? key}) : super(key: key);

  @override
  State<Step2CompanyVerificationScreen> createState() =>
      _Step2CompanyVerificationScreenState();
}

class _Step2CompanyVerificationScreenState
    extends State<Step2CompanyVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _rcNumberController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _yearsInBusinessController = TextEditingController();

  String? _selectedFile;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _rcNumberController.dispose();
    _businessAddressController.dispose();
    _yearsInBusinessController.dispose();
    super.dispose();
  }

  void _loadSavedData() {
    final registrationProvider =
        provider_package.Provider.of<RegistrationProvider>(context,
            listen: false);
    final savedData = registrationProvider.step2Data;

    if (savedData.isNotEmpty) {
      _rcNumberController.text = savedData['rcNumber'] ?? '';
      _businessAddressController.text = savedData['businessAddress'] ?? '';
      _yearsInBusinessController.text =
          savedData['yearsInBusiness']?.toString() ?? '';
      _selectedFile = savedData['cacCertificateFileName'];
      _agreedToTerms = savedData['agreedToTerms'] ?? false;
    }
  }

  Future<void> _submitStep2() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your CAC certificate'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      'rcNumber': _rcNumberController.text.trim(),
      'businessAddress': _businessAddressController.text.trim(),
      'yearsInBusiness':
          int.tryParse(_yearsInBusinessController.text.trim()) ?? 0,
      'cacCertificate':
          'mock_file_upload', // In a real app, this would be the file
      'cacCertificateFileName': _selectedFile,
      'agreedToTerms': _agreedToTerms,
    };

    final registrationProvider =
        provider_package.Provider.of<RegistrationProvider>(context,
            listen: false);
    await registrationProvider.submitStep2(data);
  }

  Future<void> _selectFile() async {
    // In a real app, this would use a file picker plugin
    // For the demo, we'll just simulate file selection
    setState(() {
      _selectedFile =
          'CAC_Certificate_${DateTime.now().millisecondsSinceEpoch}.pdf';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File selected: $_selectedFile'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider =
        provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider =
        provider_package.Provider.of<RegistrationProvider>(context);

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
                      'Company Verification',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide your company registration details for verification.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // RC Number field
                    TextFormField(
                      controller: _rcNumberController,
                      decoration: const InputDecoration(
                        labelText: 'RC Number',
                        hintText: 'e.g. RC123456',
                        prefixIcon: Icon(Icons.numbers_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'RC Number is required';
                        }
                        final rcRegex = RegExp(r'^RC[0-9]{4,}$');
                        if (!rcRegex.hasMatch(value)) {
                          return 'Please enter a valid RC number (e.g., RC12345)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Business Address field
                    TextFormField(
                      controller: _businessAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Business Address',
                        hintText: 'Full registered address',
                        prefixIcon: Icon(Icons.location_on_outlined),
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

                    // Years in Business field
                    TextFormField(
                      controller: _yearsInBusinessController,
                      decoration: const InputDecoration(
                        labelText: 'Years in Business',
                        hintText: 'e.g. 5',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter years in business';
                        }
                        final years = int.tryParse(value);
                        if (years == null) {
                          return 'Please enter a valid number';
                        }
                        if (years < 0) {
                          return 'Years cannot be negative';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // CAC Certificate upload
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CAC Certificate',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload a scanned copy of your CAC certificate (PDF, JPG, or PNG)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // File selection area
                          InkWell(
                            onTap: _selectFile,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedFile == null
                                      ? theme.colorScheme.outline
                                          .withOpacity(0.5)
                                      : theme.colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _selectedFile == null
                                        ? Icons.upload_file_outlined
                                        : Icons.file_present_outlined,
                                    color: _selectedFile == null
                                        ? theme.colorScheme.onSurfaceVariant
                                        : theme.colorScheme.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _selectedFile == null
                                        ? Text(
                                            'Click to upload your CAC certificate',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _selectedFile!,
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Click to change file',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme.colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Terms and Conditions
                    CheckboxListTile(
                      title: Text(
                        'I agree to the terms and conditions',
                        style: theme.textTheme.bodyMedium,
                      ),
                      subtitle: TextButton(
                        onPressed: () {
                          // Show terms in a real app
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Terms and Conditions would open here'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'View Terms and Conditions',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 32),

                    // Navigation buttons
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            final registrationProvider =
                                provider_package.Provider.of<
                                        RegistrationProvider>(context,
                                    listen: false);
                            registrationProvider.goToStep(1);
                          },
                          child: const Text('Back'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: registrationProvider.isLoading
                                ? null
                                : _submitStep2,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: registrationProvider.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text('Next: Choose Plan'),
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
