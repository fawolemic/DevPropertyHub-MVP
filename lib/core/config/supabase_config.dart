import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration class
/// Contains constants and initialization for Supabase
class SupabaseConfig {
  // Supabase project credentials
  static const String supabaseUrl = 'https://itrcdnrzlnqsaytekmdx.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0cmNkbnJ6bG5xc2F5dGVrbWR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgyNzgxNDEsImV4cCI6MjA2Mzg1NDE0MX0.aZftBGQfqUPL1YEQjO0La0KnlCoQF7UpsUUZOPNXLIw';

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: kDebugMode,
    );
  }

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get Supabase auth instance
  static GoTrueClient get auth => Supabase.instance.client.auth;
}
