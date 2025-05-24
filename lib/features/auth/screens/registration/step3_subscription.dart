import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/bandwidth_provider.dart';
import '../../../../core/providers/registration_provider.dart';

class Step3SubscriptionScreen extends StatefulWidget {
  const Step3SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<Step3SubscriptionScreen> createState() => _Step3SubscriptionScreenState();
}

class _Step3SubscriptionScreenState extends State<Step3SubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedPlan = 'basic';
  String _selectedPaymentMethod = '';
  String _selectedBillingCycle = 'monthly';
  bool _isAnnualBilling = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    final savedData = registrationProvider.step3Data;
    
    if (savedData.isNotEmpty) {
      setState(() {
        _selectedPlan = savedData['subscriptionPlan'] ?? 'basic';
        _selectedPaymentMethod = savedData['paymentMethod'] ?? '';
        _selectedBillingCycle = savedData['billingCycle'] ?? 'monthly';
        _isAnnualBilling = _selectedBillingCycle == 'annual';
      });
    }
  }

  Future<void> _submitStep3() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      'subscriptionPlan': _selectedPlan,
      'paymentMethod': _selectedPaymentMethod,
      'billingCycle': _isAnnualBilling ? 'annual' : 'monthly',
    };

    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    await registrationProvider.submitStep3(data);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = Provider.of<RegistrationProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: isLowBandwidth ? 0 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isLowBandwidth 
                        ? BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)) 
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Your Plan',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select a subscription plan that best fits your business needs.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Billing cycle toggle
                        SwitchListTile(
                          title: Text(
                            'Annual Billing',
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            'Save 20% with annual billing',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          value: _isAnnualBilling,
                          onChanged: (value) {
                            setState(() {
                              _isAnnualBilling = value;
                              _selectedBillingCycle = value ? 'annual' : 'monthly';
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Subscription plans
                        _buildSubscriptionPlanCards(theme, isLowBandwidth),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Payment Methods
                Card(
                  elevation: isLowBandwidth ? 0 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isLowBandwidth 
                        ? BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)) 
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select your preferred payment method.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Payment method options
                        _buildPaymentMethodOptions(theme, isLowBandwidth),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Navigation buttons
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
                        registrationProvider.goToStep(2);
                      },
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: registrationProvider.isLoading 
                            ? null 
                            : _submitStep3,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: registrationProvider.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Complete Registration'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlanCards(ThemeData theme, bool isLowBandwidth) {
    return Column(
      children: [
        // Basic Plan
        _buildPlanCard(
          theme: theme,
          isLowBandwidth: isLowBandwidth,
          planId: 'basic',
          planName: 'Basic',
          monthlyPrice: '₦25,000',
          annualPrice: '₦240,000',
          color: theme.colorScheme.primary,
          features: [
            'List up to 5 properties',
            'Basic analytics',
            'Email support',
            'Standard listing placement',
          ],
          limitations: [
            'No lead management tools',
            'No premium placement',
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Premium Plan
        _buildPlanCard(
          theme: theme,
          isLowBandwidth: isLowBandwidth,
          planId: 'premium',
          planName: 'Premium',
          monthlyPrice: '₦50,000',
          annualPrice: '₦480,000',
          color: theme.colorScheme.tertiary,
          isRecommended: true,
          features: [
            'List up to 20 properties',
            'Advanced analytics',
            'Lead management tools',
            'Priority support',
            'Featured listings',
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Enterprise Plan
        _buildPlanCard(
          theme: theme,
          isLowBandwidth: isLowBandwidth,
          planId: 'enterprise',
          planName: 'Enterprise',
          monthlyPrice: '₦100,000',
          annualPrice: '₦960,000',
          color: Colors.deepPurple,
          features: [
            'Unlimited property listings',
            'Full analytics suite',
            'Advanced lead management',
            'Dedicated account manager',
            'Custom branding options',
            'API access',
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required ThemeData theme,
    required bool isLowBandwidth,
    required String planId,
    required String planName,
    required String monthlyPrice,
    required String annualPrice,
    required Color color,
    bool isRecommended = false,
    required List<String> features,
    List<String>? limitations,
  }) {
    final isSelected = _selectedPlan == planId;
    final displayPrice = _isAnnualBilling ? annualPrice : monthlyPrice;
    final billingPeriod = _isAnnualBilling ? '/year' : '/month';
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: isLowBandwidth ? 0 : (isSelected ? 4 : 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected 
                  ? color 
                  : theme.colorScheme.outline.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPlan = planId;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        planName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Radio<String>(
                        value: planId,
                        groupValue: _selectedPlan,
                        onChanged: (value) {
                          setState(() {
                            _selectedPlan = value!;
                          });
                        },
                        activeColor: color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Price display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        displayPrice,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        billingPeriod,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Features list
                  ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(feature),
                        ),
                      ],
                    ),
                  )),
                  
                  // Limitations list
                  if (limitations != null && limitations.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...limitations.map((limitation) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              limitation,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ),
        
        // Recommended badge
        if (isRecommended)
          Positioned(
            top: -12,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Recommended',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodOptions(ThemeData theme, bool isLowBandwidth) {
    return Column(
      children: [
        // Payment method option - Bank Transfer
        _buildPaymentMethodCard(
          theme: theme,
          isLowBandwidth: isLowBandwidth,
          methodId: 'bank_transfer',
          methodName: 'Bank Transfer',
          icon: Icons.account_balance_outlined,
          description: 'Transfer funds from your bank account',
        ),
        
        const SizedBox(height: 16),
        
        // Payment method option - Card Payment
        _buildPaymentMethodCard(
          theme: theme,
          isLowBandwidth: isLowBandwidth,
          methodId: 'card',
          methodName: 'Debit/Credit Card',
          icon: Icons.credit_card_outlined,
          description: 'Pay with your debit or credit card',
        ),
        
        const SizedBox(height: 16),
        
        // Payment method option - Mobile Money
        _buildPaymentMethodCard(
          theme: theme,
          isLowBandwidth: isLowBandwidth,
          methodId: 'mobile_money',
          methodName: 'Mobile Money',
          icon: Icons.phone_android_outlined,
          description: 'Pay with mobile money service',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required ThemeData theme,
    required bool isLowBandwidth,
    required String methodId,
    required String methodName,
    required IconData icon,
    required String description,
  }) {
    final isSelected = _selectedPaymentMethod == methodId;
    
    return Card(
      elevation: isLowBandwidth ? 0 : (isSelected ? 2 : 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.5),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = methodId;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Radio<String>(
                value: methodId,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              const SizedBox(width: 8),
              Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      methodName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
