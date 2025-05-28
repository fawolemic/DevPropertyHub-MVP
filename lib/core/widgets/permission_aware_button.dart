import 'package:flutter/material.dart';
import '../services/rbac_service.dart';

/// A button that is aware of user permissions and provides appropriate feedback
class PermissionAwareButton extends StatefulWidget {
  final String resource;
  final String? resourceId;
  final String action;
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final RBACService rbacService;
  final Color? color;
  final bool showFeedback;

  const PermissionAwareButton({
    Key? key,
    required this.resource,
    this.resourceId,
    required this.action,
    required this.label,
    this.icon,
    required this.onPressed,
    required this.rbacService,
    this.color,
    this.showFeedback = true,
  }) : super(key: key);

  @override
  State<PermissionAwareButton> createState() => _PermissionAwareButtonState();
}

class _PermissionAwareButtonState extends State<PermissionAwareButton> {
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void didUpdateWidget(PermissionAwareButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resource != widget.resource ||
        oldWidget.resourceId != widget.resourceId ||
        oldWidget.action != widget.action) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    setState(() {
      _isLoading = true;
    });

    bool hasPermission = false;
    
    // Check the appropriate permission based on the action
    if (widget.action == 'create') {
      hasPermission = await widget.rbacService.canCreate(widget.resource);
    } else if (widget.action == 'read') {
      hasPermission = await widget.rbacService.canRead(widget.resource);
    } else if (widget.action == 'update') {
      if (widget.resourceId != null) {
        hasPermission = await widget.rbacService.canUpdate(widget.resource, widget.resourceId!);
      }
    } else if (widget.action == 'delete') {
      if (widget.resourceId != null) {
        hasPermission = await widget.rbacService.canDelete(widget.resource, widget.resourceId!);
      }
    } else {
      // For custom actions
      hasPermission = await widget.rbacService.hasPermission(widget.resource, widget.action);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasPermission = hasPermission;
      });
    }
  }

  void _showPermissionDeniedFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You do not have permission to ${widget.action} this ${widget.resource}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 36,
        width: 36,
        child: Center(
          child: SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.color ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      );
    }

    // If no permission, either hide or disable the button
    if (!_hasPermission) {
      // Option 1: Hide the button completely
      // return const SizedBox.shrink();
      
      // Option 2: Show disabled button with feedback on press
      return ElevatedButton.icon(
        icon: widget.icon != null ? Icon(widget.icon) : const SizedBox.shrink(),
        label: Text(widget.label),
        onPressed: widget.showFeedback ? _showPermissionDeniedFeedback : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
      );
    }

    // If has permission, show the normal button
    return ElevatedButton.icon(
      icon: widget.icon != null ? Icon(widget.icon) : const SizedBox.shrink(),
      label: Text(widget.label),
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
