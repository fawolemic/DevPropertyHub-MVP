import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider_package;

import '../../../../core/providers/unified_registration_provider.dart';
import '../../../../core/providers/bandwidth_provider.dart';

class Step1UserTypeScreen extends StatefulWidget {
  const Step1UserTypeScreen({Key? key}) : super(key: key);

  @override
  State<Step1UserTypeScreen> createState() => _Step1UserTypeScreenState();
}

class _Step1UserTypeScreenState extends State<Step1UserTypeScreen> {
  final _agentInvitationController = TextEditingController();
  bool _showAgentInvitation = false;
  
  @override
  void dispose() {
    _agentInvitationController.dispose();
    super.dispose();
  }

  void _submitStep() {
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context, listen: false);
    
    // If agent is selected but invitation code is empty, show validation error
    if (registrationProvider.userType == UserType.agent && 
        (_agentInvitationController.text.isEmpty || _agentInvitationController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an invitation code')),
      );
      return;
    }
    
    // If agent is selected, store invitation code
    if (registrationProvider.userType == UserType.agent) {
      final data = {
        'invitationCode': _agentInvitationController.text.trim(),
      };
      
      // In MVP, we just store the code without validation
      registrationProvider.nextStep(data);
    } else {
      // For other user types, just move to next step
      registrationProvider.nextStep({});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bandwidthProvider = provider_package.Provider.of<BandwidthProvider>(context);
    final isLowBandwidth = bandwidthProvider.isLowBandwidth;
    final registrationProvider = provider_package.Provider.of<UnifiedRegistrationProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
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
                    'Welcome - Choose Your Role',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select the option that best describes how you\'ll use DevPropertyHub',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Developer option
                  _buildRoleCard(
                    context,
                    icon: Icons.business,
                    title: 'Developer',
                    description: 'List and manage properties',
                    isSelected: registrationProvider.userType == UserType.developer,
                    onTap: () {
                      setState(() {
                        _showAgentInvitation = false;
                        registrationProvider.setUserType(UserType.developer);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Buyer option
                  _buildRoleCard(
                    context,
                    icon: Icons.home,
                    title: 'Buyer',
                    description: 'Find your dream property',
                    isSelected: registrationProvider.userType == UserType.buyer,
                    onTap: () {
                      setState(() {
                        _showAgentInvitation = false;
                        registrationProvider.setUserType(UserType.buyer);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Agent option
                  _buildRoleCard(
                    context,
                    icon: Icons.person_search,
                    title: 'Agent',
                    description: 'Represent developers',
                    isSelected: registrationProvider.userType == UserType.agent,
                    onTap: () {
                      setState(() {
                        _showAgentInvitation = true;
                        registrationProvider.setUserType(UserType.agent);
                      });
                    },
                  ),
                  
                  // Agent invitation code field
                  if (_showAgentInvitation) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _agentInvitationController,
                      decoration: InputDecoration(
                        labelText: 'Invitation Code',
                        hintText: 'Enter your invitation code',
                        prefixIcon: const Icon(Icons.vpn_key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: registrationProvider.userType == null || registrationProvider.isLoading
                          ? null
                          : _submitStep,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: registrationProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Continue'),
                    ),
                  ),
                  
                  if (registrationProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      registrationProvider.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildRoleCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
