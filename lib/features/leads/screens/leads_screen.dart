import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/lead_list_item.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({Key? key}) : super(key: key);

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  List<dynamic> _leads = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    try {
      // In a real app, this would be an API call
      // For the MVP, we'll load from a local JSON file
      final jsonString =
          await rootBundle.loadString('assets/data/sample_data.json');
      final jsonData = json.decode(jsonString);

      setState(() {
        _leads = jsonData['leads'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading leads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool canEdit = authProvider.userRole != 'viewer';

    return MainLayout(
      title: 'Leads',
      currentIndex: 2,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _leads.isEmpty
              ? const Center(child: Text('No leads found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Property Leads',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (canEdit)
                            ElevatedButton.icon(
                              onPressed: () {
                                // Add new lead functionality would go here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Add lead feature coming soon!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add New'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _leads.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final lead = _leads[index];
                            return LeadListItem(
                              id: lead['id'],
                              name: lead['name'],
                              email: lead['email'],
                              phone: lead['phone'],
                              interest: lead['interest'],
                              status: lead['status'],
                              createdAt: DateTime.parse(lead['createdAt']),
                              canEdit: canEdit,
                              onEdit: canEdit
                                  ? () {
                                      // Edit lead functionality would go here
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Edit ${lead['name']} feature coming soon!'),
                                        ),
                                      );
                                    }
                                  : null,
                              onDelete: authProvider.userRole == 'admin'
                                  ? () {
                                      // Delete lead functionality would go here
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Delete ${lead['name']} feature coming soon!'),
                                        ),
                                      );
                                    }
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
