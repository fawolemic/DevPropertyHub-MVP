import 'package:flutter/material.dart';

/// HomeSearchContainer
///
/// Search container component displayed on the home page hero section.
/// Contains: Search input field and search button.
/// Registration buttons have been intentionally removed.
///
/// SEARCH TAGS: #home #search #searchbar #property-search
class HomeSearchContainer extends StatelessWidget {
  final TextEditingController searchController;

  const HomeSearchContainer({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by location, developer, or project name...',
                prefixIcon: Icon(Icons.search,
                    color: theme.colorScheme.onSurfaceVariant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle search
                },
                icon: const Icon(Icons.search),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Intentionally removed registration options
            // Using zero-height spacer as per requirements
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
