import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

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
      
      return {
        'users': userCount.count,
        'leads': leadCount.count,
        'developments': developmentCount.count,
        'properties': propertyCount.count,
      };
    } catch (e) {
      debugPrint('Error getting database stats: $e');
      return {
        'users': 0,
        'leads': 0,
        'developments': 0,
        'properties': 0,
      };
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
      
      // Create a backup object
      final backupData = {
        'id': backupId,
        'timestamp': timestamp,
        'data': {
          'users': users,
          'leads': leads,
          'developments': developments,
          'properties': properties,
        },
      };
      
      // Store the backup in Supabase storage
      await _client
          .storage
          .from('backups')
          .uploadBinary(
            '$backupId.json',
            Uint8List.fromList(backupData.toString().codeUnits),
          );
      
      return backupId;
    } catch (e) {
      debugPrint('Error backing up database: $e');
      rethrow;
    }
  }
}
