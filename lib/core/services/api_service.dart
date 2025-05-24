import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

/// API Service that handles authenticated requests and token refresh
class ApiService {
  final AuthProvider _authProvider;
  final String _baseUrl;
  
  /// Default timeout for API requests (15 seconds)
  final Duration timeout = const Duration(seconds: 15);
  
  ApiService({
    required AuthProvider authProvider,
    String baseUrl = 'https://api.devpropertyhub.com/v1', // Example base URL
  }) : 
    _authProvider = authProvider,
    _baseUrl = baseUrl;
  
  /// Make an authenticated GET request
  /// Automatically handles token refresh if needed
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _authenticatedRequest(
      () => http.get(
        _buildUri(endpoint, queryParams),
        headers: await _getHeaders(headers),
      ),
    );
  }
  
  /// Make an authenticated POST request
  /// Automatically handles token refresh if needed
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _authenticatedRequest(
      () => http.post(
        _buildUri(endpoint, queryParams),
        headers: await _getHeaders(headers),
        body: jsonEncode(body),
      ),
    );
  }
  
  /// Make an authenticated PUT request
  /// Automatically handles token refresh if needed
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _authenticatedRequest(
      () => http.put(
        _buildUri(endpoint, queryParams),
        headers: await _getHeaders(headers),
        body: jsonEncode(body),
      ),
    );
  }
  
  /// Make an authenticated DELETE request
  /// Automatically handles token refresh if needed
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    return _authenticatedRequest(
      () => http.delete(
        _buildUri(endpoint, queryParams),
        headers: await _getHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }
  
  /// Makes an authenticated request with token refresh handling
  Future<Map<String, dynamic>> _authenticatedRequest(
    Future<http.Response> Function() requestFunction,
  ) async {
    try {
      // Get a fresh token before making the request
      final token = await _authProvider.getValidToken();
      if (token == null) {
        // Not authenticated, return error
        return _formatErrorResponse(401, 'Authentication required');
      }
      
      // Make the request with valid token
      final response = await requestFunction().timeout(timeout);
      
      // Handle response
      if (response.statusCode == 401) {
        // Try to refresh the token and retry once
        final refreshed = await _authProvider.refreshAuthToken();
        if (refreshed) {
          // Retry with new token
          final retryResponse = await requestFunction().timeout(timeout);
          return _parseResponse(retryResponse);
        } else {
          // Refresh failed, return authentication error
          return _formatErrorResponse(401, 'Authentication failed');
        }
      }
      
      // Parse regular response
      return _parseResponse(response);
    } catch (e) {
      return _formatErrorResponse(500, 'Request failed: ${e.toString()}');
    }
  }
  
  /// Parse HTTP response into a Map
  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Success response
        return {
          'success': true,
          'statusCode': response.statusCode,
          'data': data,
        };
      } else {
        // Error response from server
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': data['error'] ?? 'Unknown error',
          'data': data,
        };
      }
    } catch (e) {
      // Parsing error
      return _formatErrorResponse(
        response.statusCode, 
        'Failed to parse response: ${e.toString()}'
      );
    }
  }
  
  /// Create a formatted error response
  Map<String, dynamic> _formatErrorResponse(int statusCode, String message) {
    return {
      'success': false,
      'statusCode': statusCode,
      'error': message,
    };
  }
  
  /// Build request URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParams) {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    
    if (queryParams == null || queryParams.isEmpty) {
      return uri;
    }
    
    // Convert all query parameter values to strings
    final stringQueryParams = queryParams.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    
    return uri.replace(queryParameters: stringQueryParams);
  }
  
  /// Get request headers with authentication token
  Future<Map<String, String>> _getHeaders(Map<String, String>? additionalHeaders) async {
    // Base headers
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add authentication token if available
    final token = await _authProvider.getValidToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    // Add custom headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }
}
