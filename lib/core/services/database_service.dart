import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import 'dart:convert';

/// Service for managing database operations with Supabase
class DatabaseService {
  final SupabaseClient _client = SupabaseConfig.client;
  
  /// Initialize the database schema
  /// This should be called once when setting up the application
  Future<void> initializeDatabase() async {
    try {
      // Check if tables already exist
      final tablesExist = await _checkTablesExist();
      
      if (!tablesExist) {
        await _createTables();
      }
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }
  
  /// Check if the required tables exist
  Future<bool> _checkTablesExist() async {
    try {
      // Try to query the users table
      await _client.from('users').select('id').limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Create the required tables in the database
  Future<void> _createTables() async {
    try {
      // Note: In a production app, you would typically create these tables
      // using Supabase's web interface or migrations. This is a simplified approach.
      
      // Create users table
      await _client.rpc('create_users_table');
      
      // Create leads table
      await _client.rpc('create_leads_table');
      
      // Create developments table
      await _client.rpc('create_developments_table');
      
      // Create properties table
      await _client.rpc('create_properties_table');
      
    } catch (e) {
      debugPrint('Error creating tables: $e');
      rethrow;
    }
  }
  
  /// Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      // Using the correct count syntax for Supabase Flutter SDK v2.8.4
      final userCount = await _client.from('users').select('*').count();
      final leadCount = await _client.from('leads').select('*').count();
      final developmentCount = await _client.from('developments').select('*').count();
      final propertyCount = await _client.from('properties').select('*').count();
      final leadActivityCount = await _client.from('lead_activities').select('*').count();
      
      return {
        'users': userCount.count,
        'leads': leadCount.count,
        'developments': developmentCount.count,
        'properties': propertyCount.count,
        'lead_activities': leadActivityCount.count,
      };
    } catch (e) {
      debugPrint('Error getting database stats: $e');
      return {
        'users': 0,
        'leads': 0,
        'developments': 0,
        'properties': 0,
        'lead_activities': 0,
      };
    }
  }
  
  /// Safely insert a record into a table
  /// Removes id field if present to allow Supabase to auto-generate it
  /// Returns the inserted record
  Future<Map<String, dynamic>?> safeInsert(String table, Map<String, dynamic> data) async {
    try {
      // Create a copy of the data to avoid modifying the original
      final Map<String, dynamic> insertData = Map.from(data);
      
      // Remove id if present to allow Supabase to auto-generate it
      insertData.remove('id');
      
      // Set created_at if not present
      if (!insertData.containsKey('created_at')) {
        insertData['created_at'] = DateTime.now().toIso8601String();
      }
      
      // Insert the record
      final response = await _client.from(table).insert(insertData).select().single();
      return response;
    } catch (e) {
      debugPrint('Error inserting into $table: $e');
      return null;
    }
  }
  
  /// Safely update a record in a table
  /// Ensures updated_at is set
  /// Returns the updated record
  Future<Map<String, dynamic>?> safeUpdate(String table, String id, Map<String, dynamic> data) async {
    try {
      // Create a copy of the data to avoid modifying the original
      final Map<String, dynamic> updateData = Map.from(data);
      
      // Always set updated_at to current time
      updateData['updated_at'] = DateTime.now().toIso8601String();
      
      // Update the record
      final response = await _client
          .from(table)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      debugPrint('Error updating $table with id $id: $e');
      return null;
    }
  }
  
  /// Perform a secure query that respects RLS policies
  /// This ensures client-side queries are always scoped to the current user's permissions
  /// Returns a list of records that match the query
  Future<List<Map<String, dynamic>>> secureQuery({
    required String table,
    String? column,
    dynamic value,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      // Start building the query
      var query = _client.from(table).select();
      
      // Add filter if provided
      if (column != null && value != null) {
        query = query.eq(column, value);
      }
      
      // Create a variable to hold the transformed query
      dynamic transformedQuery = query;
      
      // Add ordering if provided
      if (orderBy != null) {
        transformedQuery = ascending 
            ? transformedQuery.order(orderBy, ascending: true)
            : transformedQuery.order(orderBy, ascending: false);
      }
      
      // Add pagination if provided
      if (limit != null) {
        transformedQuery = transformedQuery.limit(limit);
      }
      
      if (offset != null) {
        transformedQuery = transformedQuery.range(offset, offset + (limit ?? 10) - 1);
      }
      
      // Use the transformed query for execution
      query = transformedQuery;
      
      // Execute the query
      final response = await query;
      
      // Convert to List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error performing secure query on $table: $e');
      return [];
    }
  }
  
  /// Backup database (for admin purposes)
  Future<String> backupDatabase() async {
    try {
      // This is a simplified approach. In a real app, you would use Supabase's
      // backup functionality or a more robust solution.
      final timestamp = DateTime.now().toIso8601String();
      final backupId = 'backup-$timestamp';
      
      // Export each table
      final users = await _client.from('users').select();
      final leads = await _client.from('leads').select();
      final developments = await _client.from('developments').select();
      final properties = await _client.from('properties').select();
      final leadActivities = await _client.from('lead_activities').select();
      
      // Create a backup object
      final backupData = {
        'id': backupId,
        'timestamp': timestamp,
        'version': '1.0',
        'data': {
          'users': users,
          'leads': leads,
          'developments': developments,
          'properties': properties,
          'lead_activities': leadActivities,
        },
      };
      
      // Store the backup in Supabase storage using proper JSON encoding
      // Using jsonEncode instead of toString for better data integrity
      await _client
          .storage
          .from('backups')
          .uploadBinary(
            '$backupId.json',
            Uint8List.fromList(jsonEncode(backupData).codeUnits),
          );
      
      return backupId;
    } catch (e) {
      debugPrint('Error backing up database: $e');
      rethrow;
    }
  }
}
