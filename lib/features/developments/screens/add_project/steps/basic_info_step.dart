import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/models.dart';

class BasicInfoStep extends StatefulWidget {
  const BasicInfoStep({Key? key}) : super(key: key);

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _slugController;
  late TextEditingController _descriptionController;
  late TextEditingController _stateController;
  late TextEditingController _lgaController;
  late TextEditingController _addressController;
  
  ProjectType _selectedProjectType = ProjectType.residential;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data if available
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final project = projectProvider.currentProject;
    
    _nameController = TextEditingController(text: project?.name ?? '');
    _slugController = TextEditingController(text: project?.slug ?? '');
    _descriptionController = TextEditingController(text: project?.description ?? '');
    _stateController = TextEditingController(text: project?.locationState ?? '');
    _lgaController = TextEditingController(text: project?.locationLga ?? '');
    _addressController = TextEditingController(text: project?.locationAddress ?? '');
    
    _selectedProjectType = project?.projectType ?? ProjectType.residential;
    
    // Auto-generate slug from name
    _nameController.addListener(_updateSlug);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  void _updateSlug() {
    if (_nameController.text.isNotEmpty) {
      final slug = _nameController.text
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
      
      _slugController.text = slug;
    }
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
            'Basic Information',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the basic details about your development project.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Project name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              hintText: 'Enter the name of your development project',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Project slug
          TextFormField(
            controller: _slugController,
            decoration: const InputDecoration(
              labelText: 'Project Slug',
              hintText: 'URL-friendly name (auto-generated)',
              border: OutlineInputBorder(),
              helperText: 'This will be used in the URL for your project page',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project slug';
              }
              if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                return 'Slug can only contain lowercase letters, numbers, and hyphens';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Project description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Project Description',
              hintText: 'Enter a detailed description of your project',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          
          // Project type
          Text(
            'Project Type',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildProjectTypeOption(ProjectType.residential, 'Residential', Icons.home),
              _buildProjectTypeOption(ProjectType.commercial, 'Commercial', Icons.business),
              _buildProjectTypeOption(ProjectType.mixed_use, 'Mixed Use', Icons.apartment),
              _buildProjectTypeOption(ProjectType.estate, 'Estate', Icons.location_city),
            ],
          ),
          const SizedBox(height: 24),
          
          // Location information
          Text(
            'Location Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // State
          TextFormField(
            controller: _stateController,
            decoration: const InputDecoration(
              labelText: 'State',
              hintText: 'Enter the state where the project is located',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the state';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // LGA
          TextFormField(
            controller: _lgaController,
            decoration: const InputDecoration(
              labelText: 'Local Government Area (LGA)',
              hintText: 'Enter the LGA where the project is located',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the LGA';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Address
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Enter the full address of the project',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveBasicInfo,
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
  
  Widget _buildProjectTypeOption(ProjectType type, String label, IconData icon) {
    final theme = Theme.of(context);
    final isSelected = _selectedProjectType == type;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedProjectType = type;
        });
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.grey.shade600,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : Colors.grey.shade800,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveBasicInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      projectProvider.updateProjectBasicInfo(
        name: _nameController.text,
        slug: _slugController.text,
        description: _descriptionController.text,
        locationState: _stateController.text,
        locationLga: _lgaController.text,
        locationAddress: _addressController.text,
        projectType: _selectedProjectType,
      );
      
      // Move to next step
      projectProvider.nextStep();
    }
  }
}
