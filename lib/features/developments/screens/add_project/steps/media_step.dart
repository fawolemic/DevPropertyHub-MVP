import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';

class MediaStep extends StatefulWidget {
  const MediaStep({Key? key}) : super(key: key);

  @override
  State<MediaStep> createState() => _MediaStepState();
}

class _MediaStepState extends State<MediaStep> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Media',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload images, videos, and other media files for your project.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          // Placeholder content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 64,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Media Gallery',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'This step will allow you to upload and manage media files for your project.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Media'),
                  onPressed: () {
                    // This would open a dialog to add media
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Media upload feature coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
