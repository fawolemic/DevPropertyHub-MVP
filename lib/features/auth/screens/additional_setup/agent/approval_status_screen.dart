import 'package:flutter/material.dart';

/// ApprovalStatusScreen
///
/// Screen for agents to track their approval status after registration.
/// Shows the current stage of the approval process and estimated time to completion.
///
/// SEARCH TAGS: #agent #approval #registration #status
class ApprovalStatusScreen extends StatefulWidget {
  final String agentName;

  const ApprovalStatusScreen({
    Key? key,
    required this.agentName,
  }) : super(key: key);

  @override
  State<ApprovalStatusScreen> createState() => _ApprovalStatusScreenState();
}

class _ApprovalStatusScreenState extends State<ApprovalStatusScreen> {
  // In a real implementation, this would come from an API
  // For demo purposes, we'll use a hardcoded value
  final String _currentStatus = 'review';
  final DateTime _submissionDate =
      DateTime.now().subtract(const Duration(days: 1));
  final DateTime _estimatedCompletionDate =
      DateTime.now().add(const Duration(days: 2));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: _getStatusColor(_currentStatus)
                                .withOpacity(0.2),
                            child: Icon(
                              _getStatusIcon(_currentStatus),
                              size: 48,
                              color: _getStatusColor(_currentStatus),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getStatusTitle(_currentStatus),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getStatusDescription(_currentStatus),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timeline
                  Text(
                    'Approval Timeline',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTimelineItem(
                    context,
                    'Application Submitted',
                    _formatDate(_submissionDate),
                    'Your agent application has been received.',
                    isCompleted: true,
                  ),

                  _buildTimelineItem(
                    context,
                    'Document Review',
                    'In Progress',
                    'We\'re reviewing your credentials and documentation.',
                    isCompleted: false,
                    isActive: _currentStatus == 'review',
                  ),

                  _buildTimelineItem(
                    context,
                    'Background Verification',
                    'Pending',
                    'Checking license validity and professional history.',
                    isCompleted: false,
                    isActive: _currentStatus == 'verification',
                  ),

                  _buildTimelineItem(
                    context,
                    'Approval Decision',
                    _formatDate(_estimatedCompletionDate),
                    'Final decision on your agent application.',
                    isCompleted: false,
                    isActive: _currentStatus == 'decision',
                    isLast: true,
                  ),

                  const SizedBox(height: 24),

                  // Estimated time
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Completion',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your approval process should be completed by ${_formatDate(_estimatedCompletionDate)}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Text(
                    'Need Help?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Show contact support dialog
                            _showContactSupportDialog(context);
                          },
                          icon: const Icon(Icons.support_agent),
                          label: const Text('Contact Support'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Show additional docs dialog
                            _showAdditionalDocsDialog(context);
                          },
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Submit Documents'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
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
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String date,
    String description, {
    bool isCompleted = false,
    bool isActive = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final Color dotColor = isCompleted
        ? Colors.green
        : (isActive ? theme.colorScheme.primary : theme.colorScheme.outline);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: dotColor.withOpacity(isCompleted || isActive ? 1 : 0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: dotColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted
                    ? Colors.green
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isActive ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isCompleted
                              ? Colors.green
                              : (isActive
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceVariant))
                          .withOpacity(isActive || isCompleted ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCompleted
                            ? Colors.green
                            : (isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'submitted':
        return Icons.check_circle;
      case 'review':
        return Icons.find_in_page;
      case 'verification':
        return Icons.security;
      case 'decision':
        return Icons.gavel;
      case 'approved':
        return Icons.verified;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_bottom;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'submitted':
        return Colors.blue;
      case 'review':
        return Colors.orange;
      case 'verification':
        return Colors.purple;
      case 'decision':
        return Colors.indigo;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'submitted':
        return 'Application Submitted';
      case 'review':
        return 'Under Review';
      case 'verification':
        return 'Verification in Progress';
      case 'decision':
        return 'Decision Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Not Approved';
      default:
        return 'Processing';
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'submitted':
        return 'Your application has been received and is in queue for review.';
      case 'review':
        return 'Our team is currently reviewing your application and documentation.';
      case 'verification':
        return 'We\'re verifying your professional credentials and background.';
      case 'decision':
        return 'Final decision is being made on your application.';
      case 'approved':
        return 'Congratulations! Your agent account has been approved.';
      case 'rejected':
        return 'Unfortunately, your application didn\'t meet our current requirements.';
      default:
        return 'Your application is being processed.';
    }
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Our support team is available to help you with any questions about your agent application.'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email, size: 20),
                const SizedBox(width: 8),
                const Text('Email: support@devpropertyhub.com'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                const Text('Phone: +234 800 123 4567'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would open an email composer
              Navigator.pop(context);
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _showAdditionalDocsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Additional Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'If you\'ve been asked to provide additional documentation for your application, you can upload it here.'),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // In a real app, this would open file picker
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document uploaded successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Select File'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
