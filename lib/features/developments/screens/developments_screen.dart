import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/bandwidth_provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/widgets/development_card.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DevelopmentsScreen extends StatefulWidget {
  const DevelopmentsScreen({Key? key}) : super(key: key);

  @override
  State<DevelopmentsScreen> createState() => _DevelopmentsScreenState();
}

class _DevelopmentsScreenState extends State<DevelopmentsScreen> {
  List<dynamic> _developments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevelopments();
  }

  Future<void> _loadDevelopments() async {
    try {
      // In a real app, this would be an API call
      // For the MVP, we'll load from a local JSON file
      final jsonString = await rootBundle.loadString('assets/data/sample_data.json');
      final jsonData = json.decode(jsonString);
      
      setState(() {
        _developments = jsonData['developments'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading developments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;

    return MainLayout(
      title: 'Developments',
      currentIndex: 1,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _developments.isEmpty
              ? const Center(child: Text('No developments found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Property Developments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (authProvider.userRole != 'viewer')
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigate to the new multi-step wizard
                                context.go('/developments/add');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add New'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 
                                         MediaQuery.of(context).size.width > 600 ? 2 : 1,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _developments.length,
                        itemBuilder: (context, index) {
                          final development = _developments[index];
                          return DevelopmentCard(
                            id: development['id'],
                            name: development['name'],
                            location: development['location'],
                            imageUrl: development['imageUrl'],
                            units: development['units'],
                            unitsSold: development['unitsSold'],
                            description: development['description'],
                            isLowBandwidth: isLowBandwidth,
                            onTap: () {
                              // Development details navigation would go here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Details for ${development['name']} coming soon!'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
