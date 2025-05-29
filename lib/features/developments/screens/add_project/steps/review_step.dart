import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/models.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({Key? key}) : super(key: key);

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final project = projectProvider.currentProject;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Review all information before submitting your project.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          if (project != null) ...[
            _buildSectionCard(
              context,
              'Basic Information',
              [
                _buildInfoRow('Project Name', project.name),
                _buildInfoRow('Location', project.location),
                _buildInfoRow('Project Type', _getProjectTypeString(project.projectType)),
                if (project.description != null && project.description!.isNotEmpty)
                  _buildInfoRow('Description', project.description!),
              ],
            ),
            
            _buildSectionCard(
              context,
              'Project Details',
              [
                _buildInfoRow('Total Units', project.totalUnits?.toString() ?? 'Not specified'),
                _buildInfoRow('Total Phases', project.totalPhases.toString()),
                if (project.estimatedCompletionDate != null)
                  _buildInfoRow('Estimated Completion', _formatDate(project.estimatedCompletionDate!)),
              ],
            ),
            
            _buildSectionCard(
              context,
              'Project Phases',
              projectProvider.phases.isEmpty
                  ? [_buildInfoRow('Phases', 'No phases defined')]
                  : projectProvider.phases.map((phase) => 
                      _buildInfoRow('Phase ${phase.phaseNumber}', 
                        '${phase.phaseName} - ${_getPhaseStatusString(phase.status)}')
                    ).toList(),
            ),
            
            _buildSectionCard(
              context,
              'Unit Types',
              projectProvider.unitTypes.isEmpty
                  ? [_buildInfoRow('Unit Types', 'No unit types defined')]
                  : projectProvider.unitTypes.map((unitType) => 
                      _buildInfoRow(unitType.name, 
                        '${unitType.bedrooms} bed, ${unitType.bathrooms} bath')
                    ).toList(),
            ),
            
            _buildSectionCard(
              context,
              'Media',
              projectProvider.media.isEmpty
                  ? [_buildInfoRow('Media', 'No media uploaded')]
                  : [_buildInfoRow('Media', '${projectProvider.media.length} items uploaded')],
            ),
            
            _buildSectionCard(
              context,
              'Payment Plans',
              projectProvider.paymentPlans.isEmpty
                  ? [_buildInfoRow('Payment Plans', 'No payment plans defined')]
                  : projectProvider.paymentPlans.map((plan) => 
                      _buildInfoRow(plan.planName, 
                        '${plan.initialDepositPercentage ?? 0}% down, ${plan.installmentCount ?? 0} installments')
                    ).toList(),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Project data not available',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildSectionCard(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  String _getProjectTypeString(ProjectType type) {
    switch (type) {
      case ProjectType.residential:
        return 'Residential';
      case ProjectType.commercial:
        return 'Commercial';
      case ProjectType.mixed_use:
        return 'Mixed Use';
      case ProjectType.estate:
        return 'Estate';
      default:
        return 'Unknown';
    }
  }
  
  String _getPhaseStatusString(PhaseStatus? status) {
    if (status == null) return 'Planning';
    
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
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
