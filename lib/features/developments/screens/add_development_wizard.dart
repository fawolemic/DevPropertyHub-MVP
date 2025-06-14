import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/add_development_draft_service.dart';

class AddDevelopmentWizard extends StatefulWidget {
  const AddDevelopmentWizard({Key? key}) : super(key: key);

  @override
  _AddDevelopmentWizardState createState() => _AddDevelopmentWizardState();
}

class _AddDevelopmentWizardState extends State<AddDevelopmentWizard> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _detailsFormKey = GlobalKey<FormState>();
  final _unitTypeFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _completionDateController = TextEditingController();
  final TextEditingController _phasesController = TextEditingController();
  bool _offPlan = false;
  final TextEditingController _identifierController = TextEditingController();
  // Autocomplete controllers and suggestion lists
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _lgaController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<String> _addressSuggestions = [];
  final List<String> _devTypesList = ['Residential condos', 'Estates', 'Commercial malls', 'Mixed-use', 'Land for sale'];
  final Map<String, IconData> _devTypeIcons = {
    'Residential condos': Icons.location_city,
    'Estates': Icons.home,
    'Commercial malls': Icons.store,
    'Mixed-use': Icons.apartment,
    'Land for sale': Icons.terrain,
  }; // end field declarations

  final TextEditingController _newPhaseController = TextEditingController();
  String? _brochurePath;
  String? _selectedState;
  String? _selectedLga;
  List<String> _phaseNames = [];
  List<PlatformFile> _mediaFiles = [];

  // Nigerian states and LGAs map
  final Map<String, List<String>> _stateLgaMap = {
    'Lagos': ['Ikeja', 'Surulere', 'Epe', 'Eti-Osa'],
    'Abuja FCT': ['Abuja Municipal', 'Gwagwalada', 'Bwari', 'Kuje'],
    'Rivers': ['Port Harcourt', 'Obio-Akpor', 'Okrika', 'Bonny'],
    'Oyo': ['Ibadan North', 'Ibadan South-West', 'Oyo West', 'Oyo East'],
  };

  bool _isMultiPhase = false;
  String _devType = 'Residential condos';

  // Unit Types Step
  final TextEditingController _unitNameController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _sqftController = TextEditingController();
  final TextEditingController _unitCountController = TextEditingController();
  final TextEditingController _priceMinController = TextEditingController();
  final TextEditingController _priceMaxController = TextEditingController();
  List<Map<String, dynamic>> _unitTypes = [];

  // Payment Plans Step
  final TextEditingController _downPaymentController = TextEditingController();
  final TextEditingController _installmentsController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  List<Map<String, dynamic>> _paymentPlans = [];

  @override
  void dispose() {
    _nameController.dispose();
    _unitsController.dispose();
    _completionDateController.dispose();
    _phasesController.dispose();
    _identifierController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    _newPhaseController.dispose();
    _unitNameController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _sqftController.dispose();
    _unitCountController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _downPaymentController.dispose();
    _installmentsController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_currentStep == 0) {
      if (_formKey.currentState?.validate() ?? false) setState(() => _currentStep++);
    } else if (_currentStep == 1) {
      if (_detailsFormKey.currentState?.validate() ?? false) setState(() => _currentStep++);
    } else if (_currentStep == 2 || _currentStep == 4) {
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      if (_unitTypeFormKey.currentState?.validate() ?? false) setState(() => _currentStep++);
    } else if (_currentStep == 5) {
      if (_paymentFormKey.currentState?.validate() ?? false) setState(() => _currentStep++);
    } else if (_currentStep == 6) {
      // Final submission
      AddDevelopmentDraftService.clearDraft();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Project submitted')));
      GoRouter.of(context).go('/developments');
    } else {
      setState(() => _currentStep++);
    }
  }

  void _onCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    // Load saved draft if any
    AddDevelopmentDraftService.getDraft().then((draft) {
      if (draft != null) {
        setState(() {
          _nameController.text = draft['name'] ?? '';
          _selectedState = draft['state'] as String?;
          _selectedLga = draft['lga'] as String?;
          _addressController.text = draft['address'] ?? '';
          _devType = draft['devType'] ?? 'Residential condos';
          _isMultiPhase = draft['isMultiPhase'] ?? false;
          _phasesController.text = draft['phases'] ?? '';
          _offPlan = draft['offPlan'] ?? false;
          _identifierController.text = draft['identifier'] ?? '';
          _brochurePath = draft['brochurePath'] as String?;
          _phaseNames = draft['phaseNames'] ?? [];
          _unitTypes = draft['unitTypes'] ?? [];
          _mediaFiles = (draft['mediaFiles'] as List<dynamic>?)?.map((m) => PlatformFile(
                name: m['name'],
                path: m['path'],
                size: m['size'] as int,
              )).toList() ?? [];
          _paymentPlans = List<Map<String, dynamic>>.from(draft['paymentPlans'] as List<dynamic>? ?? []);
        });
      }
    });
  }

  Future<void> _pickBrochure() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _brochurePath = result.files.single.path);
    }
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() => _mediaFiles = result.files);
    }
  }

  Future<void> _saveDraft() async {
    final draft = {
      'name': _nameController.text,
      'state': _selectedState,
      'lga': _selectedLga,
      'address': _addressController.text,
      'devType': _devType,
      'isMultiPhase': _isMultiPhase,
      'phases': _phasesController.text,
      'offPlan': _offPlan,
      'identifier': _identifierController.text,
      'brochurePath': _brochurePath,
      'phaseNames': _phaseNames,
      'unitTypes': _unitTypes,
      'mediaFiles': _mediaFiles.map((f) => {
        'name': f.name,
        'path': f.path,
        'size': f.size,
      }).toList(),
      'paymentPlans': _paymentPlans,
    };
    await AddDevelopmentDraftService.saveDraft(draft);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Development')),
      body: Stepper(
        type: StepperType.horizontal,
        onStepTapped: (step) {
          if (step <= _currentStep) setState(() => _currentStep = step);
        },
        currentStep: _currentStep,
        onStepContinue: _onContinue,
        onStepCancel: _onCancel,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(_currentStep == 6 ? 'Submit' : 'Next'),
              ),
              const SizedBox(width: 8),
              if (_currentStep > 0)
                TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
              const Spacer(),
              TextButton(onPressed: _saveDraft, child: const Text('Save Draft')),
            ],
          );
        },
        steps: [
          // Step 1: Core Details
          Step(
            title: const Text('Core Details'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Project Name *'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  // State (autocomplete)
                  TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'State *'),
                    ),
                    suggestionsCallback: (pattern) => _stateLgaMap.keys
                        .where((s) => s.toLowerCase().contains(pattern.toLowerCase()))
                        .toList(),
                    itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        _stateController.text = suggestion;
                        _selectedState = suggestion;
                        _selectedLga = null;
                        _lgaController.clear();
                      });
                    },
                    validator: (value) => _selectedState == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  // LGA (autocomplete)
                  TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _lgaController,
                      decoration: const InputDecoration(labelText: 'LGA *'),
                    ),
                    suggestionsCallback: (pattern) {
                      if (_selectedState == null) return [];
                      return _stateLgaMap[_selectedState]!
                          .where((l) => l.toLowerCase().contains(pattern.toLowerCase()))
                          .toList();
                    },
                    itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        _lgaController.text = suggestion;
                        _selectedLga = suggestion;
                      });
                    },
                    validator: (value) => _selectedLga == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  // Specific Address
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Specific Address *'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  // Development Type selector
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _devTypesList.map((type) {
                      final selected = _devType == type;
                      return GestureDetector(
                        onTap: () => setState(() => _devType = type),
                        child: Card(
                          color: selected ? Theme.of(context).primaryColor : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: selected ? Theme.of(context).primaryColor : Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_devTypeIcons[type], size: 24, color: selected ? Colors.white : Colors.black),
                                const SizedBox(height: 4),
                                Text(type, style: TextStyle(color: selected ? Colors.white : Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.grey[50],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text('Multi-phase project?'),
                            value: _isMultiPhase,
                            onChanged: (v) => setState(() => _isMultiPhase = v),
                          ),
                          if (_isMultiPhase) ...[
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _phasesController,
                              decoration: const InputDecoration(
                                labelText: 'Phase Names * (comma-separated)',
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                          const SizedBox(height: 8),
                          SwitchListTile(
                            title: const Text('Off-plan selling'),
                            value: _offPlan,
                            onChanged: (v) => setState(() => _offPlan = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _identifierController,
                    decoration: const InputDecoration(labelText: 'Identifier (optional)'),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.grey[50],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Project Brochure (optional)', style: Theme.of(context).textTheme.subtitle1),
                          const SizedBox(height: 4),
                          ElevatedButton(onPressed: _pickBrochure, child: Text(_brochurePath != null ? 'Change Brochure' : 'Upload Brochure')),
                          if (_brochurePath != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(_brochurePath!.split('/').last, style: const TextStyle(fontSize: 12)),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            'Developer: ${auth.currentUser?.firstName ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Step 2: Project Details
          Step(
            title: const Text('Project Details'),
            isActive: _currentStep >= 1,
            content: Form(
              key: _detailsFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _unitsController,
                    decoration: const InputDecoration(labelText: 'Total Units *'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _completionDateController,
                    decoration: const InputDecoration(labelText: 'Estimated Completion Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (date != null) {
                        _completionDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Step 3: Phase Management
          Step(
            title: const Text('Phases'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isMultiPhase) ...[
                  TextFormField(
                    controller: _newPhaseController,
                    decoration: const InputDecoration(labelText: 'Phase Name'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final name = _newPhaseController.text.trim();
                      if (name.isNotEmpty) {
                        setState(() {
                          _phaseNames.add(name);
                          _newPhaseController.clear();
                        });
                      }
                    },
                    child: const Text('Add Phase'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _phaseNames
                        .map((name) => Chip(
                              label: Text(name),
                              onDeleted: () => setState(() => _phaseNames.remove(name)),
                            ))
                        .toList(),
                  ),
                ] else
                  const Text('Single-phase project. No extra phases.'),
              ],
            ),
          ),
          // Step 4: Unit Types
          Step(
            title: const Text('Unit Types'),
            isActive: _currentStep >= 3,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _unitTypeFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _unitNameController,
                        decoration: const InputDecoration(labelText: 'Unit Type Name *'),
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: _bedroomsController,
                        decoration: const InputDecoration(labelText: 'Bedrooms'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _bathroomsController,
                        decoration: const InputDecoration(labelText: 'Bathrooms'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _sqftController,
                        decoration: const InputDecoration(labelText: 'Square Footage'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _unitCountController,
                        decoration: const InputDecoration(labelText: 'Number of Units *'),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceMinController,
                              decoration: const InputDecoration(labelText: 'Price Min'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _priceMaxController,
                              decoration: const InputDecoration(labelText: 'Price Max'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_unitTypeFormKey.currentState?.validate() ?? false) {
                            setState(() {
                              _unitTypes.add({
                                'name': _unitNameController.text,
                                'bedrooms': int.tryParse(_bedroomsController.text) ?? 0,
                                'bathrooms': int.tryParse(_bathroomsController.text) ?? 0,
                                'sqft': int.tryParse(_sqftController.text) ?? 0,
                                'units': int.parse(_unitCountController.text),
                                'priceMin': double.tryParse(_priceMinController.text) ?? 0,
                                'priceMax': double.tryParse(_priceMaxController.text) ?? 0,
                              });
                              _unitNameController.clear();
                              _bedroomsController.clear();
                              _bathroomsController.clear();
                              _sqftController.clear();
                              _unitCountController.clear();
                              _priceMinController.clear();
                              _priceMaxController.clear();
                            });
                          }
                        },
                        child: const Text('Add Unit Type'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // List of added unit types
                if (_unitTypes.isEmpty)
                  const Text('No unit types added')
                else
                  Column(
                    children: _unitTypes.map((ut) => Card(
                          child: ListTile(
                            title: Text(ut['name']),
                            subtitle: Text('${ut['units']} units, ${ut['bedrooms']}BR/${ut['bathrooms']}BA'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => _unitTypes.remove(ut)),
                            ),
                          ),
                        )).toList(),
                  ),
              ],
            ),
          ),
          // Step 5: Media
          Step(
            title: const Text('Media'),
            isActive: _currentStep >= 4,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _pickMedia,
                  child: const Text('Pick Media'),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _mediaFiles
                      .map((f) => Chip(
                            label: Text(f.name),
                            onDeleted: () => setState(() => _mediaFiles.remove(f)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Step 6: Payment Plans
          Step(
            title: const Text('Payment Plans'),
            isActive: _currentStep >= 5,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _paymentFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _downPaymentController,
                        decoration: const InputDecoration(labelText: 'Down Payment (%) *'),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _installmentsController,
                        decoration: const InputDecoration(labelText: 'Installments *'),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _interestRateController,
                        decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_paymentFormKey.currentState?.validate() ?? false) {
                            setState(() {
                              _paymentPlans.add({
                                'downPayment': double.parse(_downPaymentController.text),
                                'installments': int.parse(_installmentsController.text),
                                'interestRate': double.tryParse(_interestRateController.text) ?? 0.0,
                              });
                              _downPaymentController.clear();
                              _installmentsController.clear();
                              _interestRateController.clear();
                            });
                          }
                        },
                        child: const Text('Add Payment Plan'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_paymentPlans.isEmpty)
                  const Text('No payment plans added')
                else
                  Column(
                    children: _paymentPlans.map((plan) => Card(
                          child: ListTile(
                            title: Text('${plan['downPayment']}% DP, ${plan['installments']} installments'),
                            subtitle: Text('Interest: ${plan['interestRate']}%'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => _paymentPlans.remove(plan)),
                            ),
                          ),
                        )).toList(),
                  ),
              ],
            ),
          ),
          // Step 7: Review
          Step(
            title: const Text('Review'),
            isActive: _currentStep >= 6,
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project Name: ${_nameController.text}'),
                  Text('Location: ${_selectedState}, ${_selectedLga}, ${_addressController.text}'),
                  Text('Development Type: $_devType'),
                  Text('Phases: ${_isMultiPhase ? _phaseNames.join(', ') : 'Single phase'}'),
                  Text('Total Units: ${_unitsController.text}'),
                  Text('Estimated Completion: ${_completionDateController.text}'),
                  const SizedBox(height: 8),
                  const Text('Unit Types:'),
                  ..._unitTypes.map((ut) => Text('${ut['name']} (${ut['units']} units)')).toList(),
                  const SizedBox(height: 8),
                  const Text('Media Files:'),
                  ..._mediaFiles.map((f) => Text(f.name)).toList(),
                  const SizedBox(height: 8),
                  const Text('Payment Plans:'),
                  ..._paymentPlans.map((plan) => Text('${plan['downPayment']}% DP, ${plan['installments']}x at ${plan['interestRate']}%')).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
