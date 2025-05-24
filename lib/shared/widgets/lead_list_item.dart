import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeadListItem extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String interest;
  final String status;
  final DateTime createdAt;
  final bool canEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LeadListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.interest,
    required this.status,
    required this.createdAt,
    required this.canEdit,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy');
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(status),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(name, style: theme.textTheme.titleMedium),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('Interest: $interest', style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text('Contact: $email | $phone', style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text('Added: ${dateFormat.format(createdAt)}', style: theme.textTheme.bodySmall),
        ],
      ),
      trailing: canEdit ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(status),
            backgroundColor: _getStatusColor(status).withOpacity(0.2),
            labelStyle: TextStyle(color: _getStatusColor(status)),
          ),
          if (onEdit != null) 
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Edit Lead',
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete Lead',
              color: Colors.red,
            ),
        ],
      ) : Chip(
        label: Text(status),
        backgroundColor: _getStatusColor(status).withOpacity(0.2),
        labelStyle: TextStyle(color: _getStatusColor(status)),
      ),
      isThreeLine: true,
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'contacted':
        return Colors.orange;
      case 'qualified':
        return Colors.green;
      case 'negotiation':
        return Colors.purple;
      case 'closed':
        return Colors.teal;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
