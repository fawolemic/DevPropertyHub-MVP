import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// SubscriptionSelectionScreen
/// 
/// Screen for developers to select subscription plans after registration.
/// Shows plan features, pricing, and benefits.
/// 
/// SEARCH TAGS: #subscription #pricing #payment #developer #registration
class SubscriptionSelectionScreen extends StatefulWidget {
  const SubscriptionSelectionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionSelectionScreen> createState() => _SubscriptionSelectionScreenState();
}

class _SubscriptionSelectionScreenState extends State<SubscriptionSelectionScreen> {
  String _selectedPlan = 'premium'; // Default selection
  
  final List<Map<String, dynamic>> _plans = [
    {
      'id': 'basic',
      'name': 'Basic',
      'price': 'NGN 50,000/month',
      'description': 'Essential tools for new developers',
      'features': [
        'List up to 5 properties',
        'Basic analytics',
        'Email support',
        'Standard listing visibility',
      ],
      'recommended': false,
    },
    {
      'id': 'premium',
      'name': 'Premium',
      'price': 'NGN 100,000/month',
      'description': 'Advanced features for growing developers',
      'features': [
        'List up to 20 properties',
        'Advanced analytics and reporting',
        'Priority email and phone support',
        'Featured listings',
        'Custom branding options',
      ],
      'recommended': true,
    },
    {
      'id': 'enterprise',
      'name': 'Enterprise',
      'price': 'NGN 250,000/month',
      'description': 'Comprehensive solution for large developers',
      'features': [
        'Unlimited property listings',
        'Real-time analytics dashboard',
        'Dedicated account manager',
        'Premium placement in search results',
        'API access for custom integration',
        'Marketing campaign tools',
      ],
      'recommended': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subscription Plan'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Plan',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select the subscription plan that best suits your needs',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              
              // Plan selection cards
              ...List.generate(_plans.length, (index) {
                final plan = _plans[index];
                final isSelected = _selectedPlan == plan['id'];
                
                return Card(
                  elevation: isSelected ? 4 : 1,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected 
                          ? theme.colorScheme.primary 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPlan = plan['id'];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                plan['name'],
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (plan['recommended'])
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12, 
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'RECOMMENDED',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onTertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan['price'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan['description'],
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          Text(
                            'Features',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(
                            (plan['features'] as List).length,
                            (featureIndex) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      plan['features'][featureIndex],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: 32),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to payment setup
                    _proceedToPayment();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Continue to Payment'),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Skip for now option
              Center(
                child: TextButton(
                  onPressed: () {
                    // Skip subscription selection for now
                    _skipSubscription();
                  },
                  child: Text(
                    'Skip for now',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _proceedToPayment() {
    // Navigate to the payment screen with the selected plan as a query parameter
    GoRouter.of(context).go('/payment?plan=$_selectedPlan');
  }
  
  void _skipSubscription() {
    // Show a message that subscription selection was skipped
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subscription selection skipped'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // Navigate to the dashboard using GoRouter
    GoRouter.of(context).go('/dashboard');
  }
}
