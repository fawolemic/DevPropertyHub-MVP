import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// DocumentUploader
///
/// Component for handling document uploads with visual feedback.
/// Shows upload progress, validation, and error handling.
///
/// SEARCH TAGS: #upload #document #file #cac #registration
class DocumentUploader extends StatefulWidget {
  final String label;
  final String acceptedFileTypes;
  final int maxSizeInMB;
  final ValueChanged<String?> onFileSelected;
  final bool isRequired;

  const DocumentUploader({
    Key? key,
    required this.label,
    required this.acceptedFileTypes,
    this.maxSizeInMB = 5,
    required this.onFileSelected,
    this.isRequired = true,
  }) : super(key: key);

  @override
  State<DocumentUploader> createState() => _DocumentUploaderState();
}

class _DocumentUploaderState extends State<DocumentUploader> {
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _errorMessage;

  Future<void> _selectFile() async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      // In a real implementation, we would use file_picker package
      // For now, we'll simulate the file selection and upload

      // Simulate file selection delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate file selection (in a real app, this would come from file_picker)
      final mockFileName = widget.label.contains('License')
          ? 'License_Document.pdf'
          : 'CAC_Certificate.pdf';

      // Simulate upload progress
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _uploadProgress = i / 10;
        });
      }

      // Generate a unique file path with timestamp to avoid any caching issues
      final uniqueFilePath =
          'mock_path_${DateTime.now().millisecondsSinceEpoch}_$mockFileName';

      setState(() {
        _isUploading = false;
        _selectedFileName = mockFileName;
        _selectedFilePath =
            uniqueFilePath; // In a real app, this would be the actual file path
      });

      // Important: Call onFileSelected after state is updated to ensure the callback receives the updated path
      // This ensures the parent widget gets the correct file path
      debugPrint('Document uploaded successfully: $_selectedFilePath');
      widget.onFileSelected(_selectedFilePath);
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = 'Failed to upload file: ${e.toString()}';
      });
      debugPrint('Document upload failed: ${e.toString()}');
      widget.onFileSelected(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              widget.label,
              style: theme.textTheme.titleMedium,
            ),
            if (widget.isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Helper text
        Text(
          'Accepted file types: ${widget.acceptedFileTypes}. Max size: ${widget.maxSizeInMB}MB',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),

        // Upload UI states
        if (_selectedFilePath == null && !_isUploading)
          _buildUploadButton(theme)
        else if (_isUploading)
          _buildProgressIndicator(theme)
        else
          _buildFilePreview(theme),

        // Error message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUploadButton(ThemeData theme) {
    return OutlinedButton.icon(
      onPressed: _selectFile,
      icon: const Icon(Icons.upload_file),
      label: Text('Upload ${widget.label}'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _uploadProgress,
          backgroundColor: theme.colorScheme.surfaceVariant,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Uploading... ${(_uploadProgress * 100).toInt()}%',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFilePreview(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedFileName ?? 'Selected File',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'File uploaded successfully',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove file',
            onPressed: () {
              setState(() {
                _selectedFilePath = null;
                _selectedFileName = null;
                widget.onFileSelected(null);
              });
            },
          ),
        ],
      ),
    );
  }
}
