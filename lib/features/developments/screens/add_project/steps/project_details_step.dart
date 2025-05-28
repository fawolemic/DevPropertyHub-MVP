import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/project_provider.dart';

class ProjectDetailsStep extends StatefulWidget {
  const ProjectDetailsStep({Key? key}) : super(key: key);

  @override
  State<ProjectDetailsStep> createState() => _ProjectDetailsStepState();
}

class _ProjectDetailsStepState extends State<ProjectDetailsStep> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _totalUnitsController;
  late TextEditingController _totalPhasesController;
  DateTime? _estimatedCompletionDate;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if available
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final project = projectProvider.currentProject;
    
    _totalUnitsController = TextEditingController(
      text: project?.totalUnits?.toString() ?? '',
    );
    _totalPhasesController = TextEditingController(
      text: project?.totalPhases.toString() ?? '1',
    );
    _estimatedCompletionDate = project?.estimatedCompletionDate;
  }
  
  @override
  void dispose() {
    _totalUnitsController.dispose();
    _totalPhasesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Details',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the detailed information about your development project.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Total units
          TextFormField(
            controller: _totalUnitsController,
            decoration: const InputDecoration(
              labelText: 'Total Units',
              hintText: 'Enter the total number of units in this project',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Please enter a valid number of units';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Total phases
          TextFormField(
            controller: _totalPhasesController,
            decoration: const InputDecoration(
              labelText: 'Total Phases',
              hintText: 'Enter the number of phases for this project',
              border: OutlineInputBorder(),
              helperText: 'Minimum 1 phase required',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of phases';
              }
              final number = int.tryParse(value);
              if (number == null || number < 1) {
                return 'At least 1 phase is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Estimated completion date
          InkWell(
            onTap: _selectCompletionDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Estimated Completion Date',
                hintText: 'Select a date',
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                ),
              ),
              child: Text(
                _estimatedCompletionDate != null
                    ? DateFormat('MMMM dd, yyyy').format(_estimatedCompletionDate!)
                    : 'Select a date',
                style: _estimatedCompletionDate != null
                    ? null
                    : TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProjectDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save & Continue'),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _selectCompletionDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _estimatedCompletionDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );
    
    if (picked != null && picked != _estimatedCompletionDate) {
      setState(() {
        _estimatedCompletionDate = picked;
      });
    }
  }
  
  void _saveProjectDetails() {
    if (_formKey.currentState?.validate() ?? false) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      projectProvider.updateProjectDetails(
        totalUnits: _totalUnitsController.text.isNotEmpty
            ? int.parse(_totalUnitsController.text)
            : null,
        totalPhases: int.parse(_totalPhasesController.text),
        estimatedCompletionDate: _estimatedCompletionDate,
      );
      
      // Move to next step
      projectProvider.nextStep();
    }
  }
}
