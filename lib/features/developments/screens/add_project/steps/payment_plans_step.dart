import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/project_provider.dart';

class PaymentPlansStep extends StatefulWidget {
  const PaymentPlansStep({Key? key}) : super(key: key);

  @override
  State<PaymentPlansStep> createState() => _PaymentPlansStepState();
}

class _PaymentPlansStepState extends State<PaymentPlansStep> {
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
            'Payment Plans',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Define payment options for the units in your project.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          
          // Placeholder content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: 64,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Plans Configuration',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'This step will allow you to define payment plans for your project units.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment Plan'),
                  onPressed: () {
                    // This would open a dialog to add a payment plan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment Plan feature coming soon!'),
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
