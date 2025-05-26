import 'package:flutter/material.dart';

/// LocationMultiSelect
/// 
/// Component for selecting multiple locations with search capability.
/// Includes visualization of selected items and filtering.
/// 
/// SEARCH TAGS: #selection #location #multi-select #filter #registration
class LocationMultiSelect extends StatefulWidget {
  final List<String> availableLocations;
  final List<String> selectedLocations;
  final ValueChanged<List<String>> onChanged;
  final String label;
  final bool isRequired;

  const LocationMultiSelect({
    Key? key,
    required this.availableLocations,
    required this.selectedLocations,
    required this.onChanged,
    required this.label,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<LocationMultiSelect> createState() => _LocationMultiSelectState();
}

class _LocationMultiSelectState extends State<LocationMultiSelect> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredLocations = [];
  
  @override
  void initState() {
    super.initState();
    _filteredLocations = List.from(widget.availableLocations);
    _searchController.addListener(_filterLocations);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_filterLocations);
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterLocations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = List.from(widget.availableLocations);
      } else {
        _filteredLocations = widget.availableLocations
            .where((location) => location.toLowerCase().contains(query))
            .toList();
      }
    });
  }
  
  void _toggleLocation(String location) {
    final newSelected = List<String>.from(widget.selectedLocations);
    if (newSelected.contains(location)) {
      newSelected.remove(location);
    } else {
      newSelected.add(location);
    }
    widget.onChanged(newSelected);
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
        
        // Search field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search locations',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Selected locations chips
        if (widget.selectedLocations.isNotEmpty) ...[
          Text(
            'Selected Locations:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedLocations.map((location) {
              return Chip(
                label: Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _toggleLocation(location),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Available locations
        Text(
          'Available Locations:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 200,
          child: _filteredLocations.isEmpty
              ? Center(
                  child: Text(
                    'No locations found',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredLocations.length,
                  itemBuilder: (context, index) {
                    final location = _filteredLocations[index];
                    final isSelected = widget.selectedLocations.contains(location);
                    
                    return CheckboxListTile(
                      title: Text(location),
                      value: isSelected,
                      onChanged: (_) => _toggleLocation(location),
                      activeColor: theme.colorScheme.primary,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
