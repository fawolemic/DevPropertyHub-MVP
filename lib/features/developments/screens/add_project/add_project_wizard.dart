import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _scrollController = ScrollController();
  final _stepsScrollController = ScrollController();
  final _focusNode = FocusNode();
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

      // Set initial focus
      _focusNode.requestFocus();
    });

    // Set up keyboard listeners for accessibility
    _setupKeyboardListeners();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stepsScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setupKeyboardListeners() {
    _focusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent) {
        final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          // Next step with right arrow if current step is valid
          if (projectProvider.canMoveToNextStep()) {
            projectProvider.nextStep();
            _scrollToTop();
            return KeyEventResult.handled;
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          // Previous step with left arrow
          if (projectProvider.currentStep > 1) {
            projectProvider.previousStep();
            _scrollToTop();
            return KeyEventResult.handled;
          }
        }
      }
      return KeyEventResult.ignored;
    };
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectId != null ? 'Edit Project' : 'Add New Project'),
        elevation: 0,
      ),
      body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: Consumer<ProjectProvider>(
          builder: (context, projectProvider, child) {
            final currentStep = projectProvider.currentStep;
            final completedSteps = projectProvider.completedSteps;

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
                  // Step indicator with horizontal scrolling for small screens
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Scrollbar(
                            controller: _stepsScrollController,
                            thumbVisibility: isSmallScreen,
                            child: SingleChildScrollView(
                              controller: _stepsScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStepIndicator(
                                    context,
                                    0,
                                    'Basic Info',
                                    completedSteps.contains(0) || currentStep == 0,
                                    currentStep == 0,
                                  ),
                                  _buildStepConnector(context, completedSteps.contains(0)),
                                  _buildStepIndicator(
                                    context,
                                    1,
                                    'Details',
                                    completedSteps.contains(1) || currentStep == 1,
                                    currentStep == 1,
                                  ),
                                  _buildStepConnector(context, completedSteps.contains(1)),
                                  _buildStepIndicator(
                                    context,
                                    2,
                                    'Phases',
                                    completedSteps.contains(2) || currentStep == 2,
                                    currentStep == 2,
                                  ),
                                  _buildStepConnector(context, completedSteps.contains(2)),
                                  _buildStepIndicator(
                                    context,
                                    3,
                                    'Unit Types',
                                    completedSteps.contains(3) || currentStep == 3,
                                    currentStep == 3,
                                  ),
                                  _buildStepConnector(context, completedSteps.contains(3)),
                                  _buildStepIndicator(
                                    context,
                                    4,
                                    'Media',
                                    completedSteps.contains(4) || currentStep == 4,
                                    currentStep == 4,
                                  ),
                                  _buildStepConnector(context, completedSteps.contains(4)),
                                  _buildStepIndicator(
                                    context,
                                    5,
                                    'Payment',
                                    completedSteps.contains(5) || currentStep == 5,
                                    currentStep == 5,
                                  ),
                                  _buildStepConnector(context, completedSteps.contains(5)),
                                  _buildStepIndicator(
                                    context,
                                    6,
                                    'Review',
                                    completedSteps.contains(6) || currentStep == 6,
                                    currentStep == 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getStepTitle(currentStep),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSmallScreen)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Scroll for more steps',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Step content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
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
      ),
    );
  }
  
  Widget _buildStepConnector(BuildContext context, bool isActive) {
    final theme = Theme.of(context);
    
    return Container(
      width: 24,
      height: 2,
      color: isActive ? theme.colorScheme.primary : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
  
  Widget _buildStepIndicator(
    BuildContext context,
    int step,
    String label,
    bool isCompleted,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? theme.colorScheme.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.check,
            color: isCompleted ? Colors.white : Colors.grey.shade400,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isCompleted ? theme.colorScheme.primary : Colors.grey.shade600,
          ),
        ),
      ],
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
  
  Future<void> _saveProject(ProjectProvider provider) async {
    // Validate all steps
    if (_validateAllSteps()) {
      // Save project
      provider.saveProject().then((success) {
        if (success) {
          // Show success dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text('Success!'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your development project has been saved successfully.'),
                    SizedBox(height: 16),
                    Text(
                      'Project Name: ${provider.currentProject?.name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Location: ${provider.currentProject?.location}'),
                    Text('Total Units: ${provider.currentProject?.totalUnits}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Return to developments list
                    },
                    child: Text('View All Projects'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Return to developments list
                    },
                    child: Text('Done'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save project: ${provider.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }
  
  bool _validateAllSteps() {
    // Validate all steps
    for (int i = 0; i < 6; i++) {
      if (!_validateCurrentStep(i)) {
        return false;
      }
    }
    return true;
  }
