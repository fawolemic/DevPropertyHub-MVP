import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/api_service.dart';

/// Example screen demonstrating the use of the API service with token handling
class ApiServiceExampleScreen extends StatefulWidget {
  const ApiServiceExampleScreen({Key? key}) : super(key: key);

  @override
  State<ApiServiceExampleScreen> createState() =>
      _ApiServiceExampleScreenState();
}

class _ApiServiceExampleScreenState extends State<ApiServiceExampleScreen> {
  late ApiService _apiService;
  bool _isLoading = false;
  String _resultText = 'No API calls made yet';

  @override
  void initState() {
    super.initState();
    // Initialize API service with the auth provider
    _apiService = ApiService(
      authProvider: Provider.of<AuthProvider>(context, listen: false),
    );
  }

  // Example GET request that would fetch user data
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _resultText = 'Fetching user data...';
    });

    try {
      // Make an authenticated GET request
      final result = await _apiService.get(
        'user/profile', // Endpoint
        queryParams: {
          'include_preferences': 'true'
        }, // Optional query parameters
      );

      if (result['success']) {
        setState(() {
          _resultText = 'SUCCESS: User data retrieved\n\n'
              'Data: ${result['data']}';
        });
      } else {
        setState(() {
          _resultText = 'ERROR: ${result['error']}\n'
              'Status Code: ${result['statusCode']}';
        });

        // Handle authentication errors (e.g., redirect to login)
        if (result['statusCode'] == 401) {
          _handleAuthError();
        }
      }
    } catch (e) {
      setState(() {
        _resultText = 'EXCEPTION: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Example POST request to update user preferences
  Future<void> _updateUserPreferences() async {
    setState(() {
      _isLoading = true;
      _resultText = 'Updating preferences...';
    });

    try {
      // Create the request body
      final requestBody = {
        'preferences': {
          'notifications': {
            'email': true,
            'push': false,
          },
          'theme': 'dark',
        }
      };

      // Make an authenticated POST request
      final result = await _apiService.post(
        'user/preferences', // Endpoint
        body: requestBody,
      );

      if (result['success']) {
        setState(() {
          _resultText = 'SUCCESS: Preferences updated\n\n'
              'Data: ${result['data']}';
        });
      } else {
        setState(() {
          _resultText = 'ERROR: ${result['error']}\n'
              'Status Code: ${result['statusCode']}';
        });

        // Handle authentication errors
        if (result['statusCode'] == 401) {
          _handleAuthError();
        }
      }
    } catch (e) {
      setState(() {
        _resultText = 'EXCEPTION: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Example that would specifically trigger a token expiry
  Future<void> _simulateTokenExpiry() async {
    setState(() {
      _isLoading = true;
      _resultText = 'Simulating token expiry...';
    });

    // Force token to be "expired" by setting expiry to now
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Note: In a real app, you wouldn't manipulate the token expiry directly
    // This is just for demonstration purposes

    try {
      // In a real app, this would be a protected endpoint
      // that would return 401 when token is expired
      final result = await _apiService.get('protected/resource');

      setState(() {
        _resultText = 'Request completed. Token refresh '
            'would happen automatically if needed.\n\n'
            'Result: $result';
      });
    } catch (e) {
      setState(() {
        _resultText = 'EXCEPTION: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleAuthError() {
    // In a real app, you might show a dialog and redirect to login
    // For demo purposes, we'll just show a snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication required. Please login again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Service Example'),
        actions: [
          // Only show the user info if they're logged in
          if (authProvider.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${authProvider.userName} (${authProvider.userRole.toString().split('.').last})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Authentication status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Authentication Status',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                        'Logged in:', authProvider.isLoggedIn.toString()),
                    _buildStatusRow('User type:',
                        authProvider.userType.toString().split('.').last),
                    _buildStatusRow('User role:',
                        authProvider.userRole.toString().split('.').last),
                    _buildStatusRow('Token expiry:',
                        authProvider.isTokenExpired ? 'Expired' : 'Valid'),
                    if (authProvider.isDeveloper)
                      _buildStatusRow('Verification:',
                          authProvider.verificationStatus ?? 'N/A'),
                    const Divider(),
                    Text(
                      'Permissions: ${authProvider.permissions.join(", ")}',
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // API action buttons
            Text(
              'API Actions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _fetchUserData,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Fetch User Data'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _updateUserPreferences,
                  icon: const Icon(Icons.settings),
                  label: const Text('Update Preferences'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _simulateTokenExpiry,
                  icon: const Icon(Icons.timer),
                  label: const Text('Simulate Token Expiry'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Result display
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API Result',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _resultText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
