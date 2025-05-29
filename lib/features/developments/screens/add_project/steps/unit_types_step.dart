import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';
import '../../../models/unit_type.dart';

class UnitTypesStep extends StatelessWidget {
  const UnitTypesStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final unitTypes = projectProvider.unitTypes;
    final currentProject = projectProvider.currentProject;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unit Types Step',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8),
          Text(
            'This step allows you to define different types of units in your project.',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Unit Type'),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => _AddUnitTypeDialog(projectId: currentProject?.id ?? ''),
              );
            },
          ),
          SizedBox(height: 24),
          if (unitTypes.isEmpty)
            Center(child: Text('No unit types added yet.'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: unitTypes.length,
                itemBuilder: (context, index) {
                  final unitType = unitTypes[index];
                  return ListTile(
                    title: Text(unitType.name),
                    subtitle: Text('Bedrooms: ${unitType.bedrooms ?? '-'} | Bathrooms: ${unitType.bathrooms ?? '-'} | Price: ${unitType.priceMin} - ${unitType.priceMax}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => _AddUnitTypeDialog(
                                projectId: currentProject?.id ?? '',
                                unitType: unitType,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            projectProvider.removeUnitType(unitType.id ?? '');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _AddUnitTypeDialog extends StatefulWidget {
  final String projectId;
  final UnitType? unitType;

  const _AddUnitTypeDialog({
    required this.projectId,
    this.unitType,
  });

  @override
  State<_AddUnitTypeDialog> createState() => _AddUnitTypeDialogState();
}

class _AddUnitTypeDialogState extends State<_AddUnitTypeDialog> {
  final _nameController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _priceMinController = TextEditingController();
  final _priceMaxController = TextEditingController();
  final _unitCountController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    if (widget.unitType != null) {
      _nameController.text = widget.unitType!.name;
      _bedroomsController.text = widget.unitType!.bedrooms?.toString() ?? '';
      _bathroomsController.text = widget.unitType!.bathrooms?.toString() ?? '';
      _priceMinController.text = widget.unitType!.priceMin.toString();
      _priceMaxController.text = widget.unitType!.priceMax.toString();
      _unitCountController.text = widget.unitType!.unitCount.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _unitCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.unitType != null ? 'Edit Unit Type' : 'Add Unit Type'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Unit Name *'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bedroomsController,
                    decoration: InputDecoration(labelText: 'Bedrooms'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _bathroomsController,
                    decoration: InputDecoration(labelText: 'Bathrooms'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _unitCountController,
              decoration: InputDecoration(labelText: 'Number of Units *'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceMinController,
                    decoration: InputDecoration(labelText: 'Min Price *'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _priceMaxController,
                    decoration: InputDecoration(labelText: 'Max Price *'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final bedrooms = _bedroomsController.text.isEmpty ? null : int.tryParse(_bedroomsController.text);
            final bathrooms = _bathroomsController.text.isEmpty ? null : int.tryParse(_bathroomsController.text);
            final priceMin = double.tryParse(_priceMinController.text) ?? 0.0;
            final priceMax = double.tryParse(_priceMaxController.text) ?? 0.0;
            final unitCount = int.tryParse(_unitCountController.text) ?? 1;

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a unit name')),
              );
              return;
            }

            final unitType = UnitType(
              id: widget.unitType?.id,
              projectId: widget.projectId,
              name: name,
              bedrooms: bedrooms,
              bathrooms: bathrooms,
              priceMin: priceMin,
              priceMax: priceMax,
              unitCount: unitCount,
              currency: 'NGN',
              features: [],
            );

            final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
            if (widget.unitType != null) {
              projectProvider.updateUnitType(unitType);
            } else {
              projectProvider.addUnitType(unitType);
            }

            Navigator.of(context).pop();
          },
          child: Text(widget.unitType != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
