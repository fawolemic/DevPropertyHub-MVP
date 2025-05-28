import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../models/models.dart';
import 'steps/basic_info_step.dart';
import 'steps/project_details_step.dart';
import 'steps/phases_step.dart';
import 'steps/unit_types_step.dart';
import 'steps/media_step.dart';
import 'steps/payment_plans_step.dart';
import 'steps/review_step.dart';

class AddProjectWizard extends StatefulWidget {
  final String developerId;
  final String? projectId; // If editing an existing project

  const AddProjectWizard({
    Key? key,
    required this.developerId,
    this.projectId,
  }) : super(key: key);

  @override
  State<AddProjectWizard> createState() => _AddProjectWizardState();
}

class _AddProjectWizardState extends State<AddProjectWizard> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize project data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      
      if (widget.projectId != null) {
        // Load existing project
        projectProvider.loadProject(widget.projectId!);
      } else {
        // Initialize new project
        projectProvider.initNewProject(widget.developerId);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectId != null ? 'Edit Project' : 'Add New Project'),
        elevation: 0,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (projectProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${projectProvider.error}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.projectId != null) {
                        projectProvider.loadProject(widget.projectId!);
                      } else {
                        projectProvider.initNewProject(widget.developerId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Stepper indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  color: theme.colorScheme.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStepIndicator(0, 'Basic Info', projectProvider.currentStep),
                      _buildStepDivider(),
                      _buildStepIndicator(1, 'Details', projectProvider.currentStep),
                      _buildStepDivider(),
                      _buildStepIndicator(2, 'Phases', projectProvider.currentStep),
                      _buildStepDivider(),
                      _buildStepIndicator(3, 'Units', projectProvider.currentStep),
                      _buildStepDivider(),
                      _buildStepIndicator(4, 'Media', projectProvider.currentStep),
                      _buildStepDivider(),
                      _buildStepIndicator(5, 'Payment', projectProvider.currentStep),
                      _buildStepDivider(),
                      _buildStepIndicator(6, 'Review', projectProvider.currentStep),
                    ],
                  ),
                ),
                
                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildStepContent(projectProvider.currentStep),
                  ),
                ),
                
                // Navigation buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (projectProvider.currentStep > 0)
                        ElevatedButton(
                          onPressed: () {
                            projectProvider.previousStep();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: theme.colorScheme.primary,
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                          child: const Text('Previous'),
                        )
                      else
                        const SizedBox.shrink(),
                      
                      ElevatedButton(
                        onPressed: () {
                          if (projectProvider.currentStep < 6) {
                            // Validate current step
                            if (_validateCurrentStep(projectProvider.currentStep)) {
                              projectProvider.nextStep();
                            }
                          } else {
                            // Final step - save project
                            _saveProject(projectProvider);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          projectProvider.currentStep < 6 ? 'Next' : 'Save Project',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStepIndicator(int step, String label, int currentStep) {
    final theme = Theme.of(context);
    final isActive = step == currentStep;
    final isCompleted = step < currentStep;
    
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? theme.colorScheme.primary
                : isCompleted
                    ? theme.colorScheme.primary.withOpacity(0.7)
                    : Colors.grey.shade300,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? theme.colorScheme.primary
                : isCompleted
                    ? theme.colorScheme.primary.withOpacity(0.7)
                    : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStepDivider() {
    return Container(
      width: 20,
      height: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
  
  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return const BasicInfoStep();
      case 1:
        return const ProjectDetailsStep();
      case 2:
        return const PhasesStep();
      case 3:
        return const UnitTypesStep();
      case 4:
        return const MediaStep();
      case 5:
        return const PaymentPlansStep();
      case 6:
        return const ReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }
  
  bool _validateCurrentStep(int step) {
    // Each step will have its own validation logic
    switch (step) {
      case 0:
        // Basic info validation
        return _formKey.currentState?.validate() ?? false;
      case 1:
        // Project details validation
        return _formKey.currentState?.validate() ?? false;
      case 2:
        // Phases validation
        final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
        return projectProvider.phases.isNotEmpty;
      case 3:
        // Unit types validation
        final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
        return projectProvider.unitTypes.isNotEmpty;
      case 4:
        // Media validation
        return true; // Media is optional
      case 5:
        // Payment plans validation
        final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
        return projectProvider.paymentPlans.isNotEmpty;
      case 6:
        // Review validation
        return true; // No validation needed for review
      default:
        return false;
    }
  }
  
  Future<void> _saveProject(ProjectProvider projectProvider) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    final success = await projectProvider.saveProject();
    
    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Project saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back to projects list
      navigator.pop();
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to save project: ${projectProvider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
