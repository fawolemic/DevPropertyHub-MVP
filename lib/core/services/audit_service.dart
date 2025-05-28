import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Service for handling audit logging of sensitive operations
class AuditService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Log an audit event
  /// 
  /// [userId] - The ID of the user performing the action
  /// [resource] - The resource being acted upon (e.g., 'properties', 'leads')
  /// [resourceId] - The ID of the specific resource
  /// [action] - The action being performed (e.g., 'create', 'update', 'delete')
  /// [details] - Additional details about the action
  Future<void> logAction({
    required String userId,
    required String resource,
    required String resourceId,
    required String action,
    Map<String, dynamic>? details,
  }) async {
    try {
      final auditData = {
        'user_id': userId,
        'resource': resource,
        'resource_id': resourceId,
        'action': action,
        'details': details ?? {},
        'ip_address': await _getIpAddress(),
        'created_at': DateTime.now().toIso8601String(),
      };

      await _client.from('audit_logs').insert(auditData);
    } catch (e) {
      // Log the error but don't throw - audit logging should not block operations
      debugPrint('Error logging audit event: $e');
    }
  }

  /// Get audit logs for a specific resource
  Future<List<Map<String, dynamic>>> getResourceAuditLogs(
    String resource,
    String resourceId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('audit_logs')
          .select()
          .eq('resource', resource)
          .eq('resource_id', resourceId)
          .order('created_at', ascending: false)
          .limit(limit)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting audit logs: $e');
      return [];
    }
  }

  /// Get audit logs for a specific user
  Future<List<Map<String, dynamic>>> getUserAuditLogs(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('audit_logs')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting user audit logs: $e');
      return [];
    }
  }

  /// Get IP address for audit logging
  Future<String> _getIpAddress() async {
    try {
      // This is a simplified approach - in a production app, you might use a service
      // to get the IP address or rely on the server to record it
      return 'client-side-logging';
    } catch (e) {
      return 'unknown';
    }
  }
}
