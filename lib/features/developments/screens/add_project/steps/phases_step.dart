import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/project_provider.dart';
import '../../../models/project_phase.dart';

class PhasesStep extends StatefulWidget {
  const PhasesStep({Key? key}) : super(key: key);

  @override
  State<PhasesStep> createState() => _PhasesStepState();
}

class _PhasesStepState extends State<PhasesStep> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        final phases = projectProvider.phases;
        final totalPhases = projectProvider.currentProject?.totalPhases ?? 1;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Phases',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Define the phases of your development project.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            
            // Add phase button
            if (phases.length < totalPhases)
              ElevatedButton.icon(
                onPressed: () => _showAddPhaseDialog(context, phases.length + 1),
                icon: const Icon(Icons.add),
                label: const Text('Add Phase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Phases list
            if (phases.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No phases added yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Click the "Add Phase" button to add your first project phase',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: phases.length,
                itemBuilder: (context, index) {
                  final phase = phases[index];
                  return _buildPhaseCard(context, phase);
                },
              ),
            
            const SizedBox(height: 32),
            
            // Navigation buttons
            if (phases.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    projectProvider.nextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue to Unit Types'),
                ),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildPhaseCard(BuildContext context, ProjectPhase phase) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phase ${phase.phaseNumber}: ${phase.phaseName}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditPhaseDialog(context, phase),
                      color: theme.colorScheme.primary,
                      tooltip: 'Edit Phase',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _showDeletePhaseDialog(context, phase),
                      color: theme.colorScheme.error,
                      tooltip: 'Delete Phase',
                    ),
                  ],
                ),
              ],
            ),
            if (phase.description != null && phase.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                phase.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPhaseInfoItem(
                  context,
                  'Units',
                  phase.unitsCount.toString(),
                  Icons.home,
                ),
                const SizedBox(width: 24),
                _buildPhaseInfoItem(
                  context,
                  'Status',
                  _getPhaseStatusLabel(phase.status),
                  Icons.info,
                ),
                const SizedBox(width: 24),
                _buildPhaseInfoItem(
                  context,
                  'Completion',
                  '${(phase.completionPercentage * 100).toInt()}%',
                  Icons.pie_chart,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: phase.completionPercentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_getPhaseStatusColor(phase.status)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateInfo(
                    context,
                    'Start Date',
                    phase.startDate != null
                        ? DateFormat('MMM dd, yyyy').format(phase.startDate!)
                        : 'Not set',
                  ),
                ),
                Expanded(
                  child: _buildDateInfo(
                    context,
                    'End Date',
                    phase.endDate != null
                        ? DateFormat('MMM dd, yyyy').format(phase.endDate!)
                        : 'Not set',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPhaseInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateInfo(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  String _getPhaseStatusLabel(PhaseStatus status) {
    switch (status) {
      case PhaseStatus.planning:
        return 'Planning';
      case PhaseStatus.in_progress:
        return 'In Progress';
      case PhaseStatus.completed:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
  
  Color _getPhaseStatusColor(PhaseStatus status) {
    switch (status) {
      case PhaseStatus.planning:
        return Colors.blue;
      case PhaseStatus.in_progress:
        return Colors.orange;
      case PhaseStatus.completed:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  Future<void> _showAddPhaseDialog(BuildContext context, int phaseNumber) async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final projectId = projectProvider.currentProject?.id ?? '';
    
    // Form controllers
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final unitsController = TextEditingController();
    final completionController = TextEditingController(text: '0');
    
    PhaseStatus selectedStatus = PhaseStatus.planning;
    DateTime? startDate;
    DateTime? endDate;
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Phase ${phaseNumber}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phase name
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Phase Name',
                        hintText: 'e.g., Foundation, Structure, Finishing',
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Optional description of this phase',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Units count
                    TextField(
                      controller: unitsController,
                      decoration: const InputDecoration(
                        labelText: 'Number of Units',
                        hintText: 'How many units in this phase?',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Status
                    DropdownButtonFormField<PhaseStatus>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: PhaseStatus.values.map((status) {
                        return DropdownMenuItem<PhaseStatus>(
                          value: status,
                          child: Text(_getPhaseStatusLabel(status)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                            
                            // Update completion percentage based on status
                            if (value == PhaseStatus.completed) {
                              completionController.text = '100';
                            } else if (value == PhaseStatus.planning) {
                              completionController.text = '0';
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Completion percentage
                    TextField(
                      controller: completionController,
                      decoration: const InputDecoration(
                        labelText: 'Completion Percentage',
                        hintText: 'Enter a value from 0 to 100',
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Start date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        
                        if (date != null) {
                          setState(() {
                            startDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          startDate != null
                              ? DateFormat('MMM dd, yyyy').format(startDate!)
                              : 'Select a date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // End date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? (startDate?.add(const Duration(days: 180)) ?? DateTime.now()),
                          firstDate: startDate ?? DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        
                        if (date != null) {
                          setState(() {
                            endDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          endDate != null
                              ? DateFormat('MMM dd, yyyy').format(endDate!)
                              : 'Select a date',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate inputs
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a phase name')),
                      );
                      return;
                    }
                    
                    if (unitsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter the number of units')),
                      );
                      return;
                    }
                    
                    final units = int.tryParse(unitsController.text);
                    if (units == null || units <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid number of units')),
                      );
                      return;
                    }
                    
                    final completion = double.tryParse(completionController.text);
                    if (completion == null || completion < 0 || completion > 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid completion percentage (0-100)')),
                      );
                      return;
                    }
                    
                    // Create phase
                    final phase = ProjectPhase(
                      projectId: projectId,
                      phaseNumber: phaseNumber,
                      phaseName: nameController.text,
                      description: descriptionController.text.isEmpty ? null : descriptionController.text,
                      unitsCount: units,
                      completionPercentage: completion / 100,
                      startDate: startDate,
                      endDate: endDate,
                      status: selectedStatus,
                    );
                    
                    // Add to provider
                    projectProvider.addProjectPhase(phase);
                    
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Phase'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Future<void> _showEditPhaseDialog(BuildContext context, ProjectPhase phase) async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    
    // Form controllers
    final nameController = TextEditingController(text: phase.phaseName);
    final descriptionController = TextEditingController(text: phase.description);
    final unitsController = TextEditingController(text: phase.unitsCount.toString());
    final completionController = TextEditingController(
      text: (phase.completionPercentage * 100).toInt().toString(),
    );
    
    var selectedStatus = phase.status;
    var startDate = phase.startDate;
    var endDate = phase.endDate;
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Phase ${phase.phaseNumber}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phase name
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Phase Name',
                        hintText: 'e.g., Foundation, Structure, Finishing',
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Optional description of this phase',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Units count
                    TextField(
                      controller: unitsController,
                      decoration: const InputDecoration(
                        labelText: 'Number of Units',
                        hintText: 'How many units in this phase?',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Status
                    DropdownButtonFormField<PhaseStatus>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: PhaseStatus.values.map((status) {
                        return DropdownMenuItem<PhaseStatus>(
                          value: status,
                          child: Text(_getPhaseStatusLabel(status)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                            
                            // Update completion percentage based on status
                            if (value == PhaseStatus.completed) {
                              completionController.text = '100';
                            } else if (value == PhaseStatus.planning && completionController.text == '100') {
                              completionController.text = '0';
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Completion percentage
                    TextField(
                      controller: completionController,
                      decoration: const InputDecoration(
                        labelText: 'Completion Percentage',
                        hintText: 'Enter a value from 0 to 100',
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Start date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        
                        if (date != null) {
                          setState(() {
                            startDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          startDate != null
                              ? DateFormat('MMM dd, yyyy').format(startDate!)
                              : 'Select a date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // End date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? (startDate?.add(const Duration(days: 180)) ?? DateTime.now()),
                          firstDate: startDate ?? DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        
                        if (date != null) {
                          setState(() {
                            endDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          endDate != null
                              ? DateFormat('MMM dd, yyyy').format(endDate!)
                              : 'Select a date',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate inputs
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a phase name')),
                      );
                      return;
                    }
                    
                    if (unitsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter the number of units')),
                      );
                      return;
                    }
                    
                    final units = int.tryParse(unitsController.text);
                    if (units == null || units <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid number of units')),
                      );
                      return;
                    }
                    
                    final completion = double.tryParse(completionController.text);
                    if (completion == null || completion < 0 || completion > 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid completion percentage (0-100)')),
                      );
                      return;
                    }
                    
                    // Update phase
                    final updatedPhase = ProjectPhase(
                      id: phase.id,
                      projectId: phase.projectId,
                      phaseNumber: phase.phaseNumber,
                      phaseName: nameController.text,
                      description: descriptionController.text.isEmpty ? null : descriptionController.text,
                      unitsCount: units,
                      completionPercentage: completion / 100,
                      startDate: startDate,
                      endDate: endDate,
                      status: selectedStatus,
                      createdAt: phase.createdAt,
                    );
                    
                    // Update in provider
                    projectProvider.updateProjectPhase(updatedPhase);
                    
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update Phase'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  Future<void> _showDeletePhaseDialog(BuildContext context, ProjectPhase phase) async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Phase'),
          content: Text('Are you sure you want to delete Phase ${phase.phaseNumber}: ${phase.phaseName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                projectProvider.removeProjectPhase(phase);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
