import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/development_model.dart';

/// Service for handling development operations with Supabase
class DevelopmentService {
  final SupabaseClient _client = SupabaseConfig.client;
  
  /// Create a new development
  Future<DevelopmentModel> createDevelopment(DevelopmentModel development) async {
    try {
      final developmentData = development.toMap();
      
      // Remove id if it's empty (let Supabase generate it)
      if (development.id.isEmpty) {
        developmentData.remove('id');
      }
      
      final response = await _client
          .from('developments')
          .insert(developmentData)
          .select()
          .single();
      
      return DevelopmentModel.fromMap(response);
    } catch (e) {
      debugPrint('Error creating development: $e');
      rethrow;
    }
  }
  
  /// Get all developments for a developer
  Future<List<DevelopmentModel>> getDevelopmentsByDeveloperId(String developerId) async {
    try {
      final response = await _client
          .from('developments')
          .select()
          .eq('developer_id', developerId)
          .order('created_at', ascending: false);
      
      return response.map((development) => DevelopmentModel.fromMap(development)).toList();
    } catch (e) {
      debugPrint('Error getting developments: $e');
      rethrow;
    }
  }
  
  /// Get a development by ID
  Future<DevelopmentModel> getDevelopmentById(String developmentId) async {
    try {
      final response = await _client
          .from('developments')
          .select()
          .eq('id', developmentId)
          .single();
      
      return DevelopmentModel.fromMap(response);
    } catch (e) {
      debugPrint('Error getting development: $e');
      rethrow;
    }
  }
  
  /// Update a development
  Future<DevelopmentModel> updateDevelopment(DevelopmentModel development) async {
    try {
      final developmentData = development.toMap();
      developmentData['updated_at'] = DateTime.now().toIso8601String();
      
      await _client
          .from('developments')
          .update(developmentData)
          .eq('id', development.id);
      
      return development.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      debugPrint('Error updating development: $e');
      rethrow;
    }
  }
  
  /// Delete a development
  Future<void> deleteDevelopment(String developmentId) async {
    try {
      await _client
          .from('developments')
          .delete()
          .eq('id', developmentId);
    } catch (e) {
      debugPrint('Error deleting development: $e');
      rethrow;
    }
  }
  
  /// Get developments by status
  Future<List<DevelopmentModel>> getDevelopmentsByStatus(String developerId, DevelopmentStatus status) async {
    try {
      final response = await _client
          .from('developments')
          .select()
          .eq('developer_id', developerId)
          .eq('status', DevelopmentModel.statusToString(status))
          .order('created_at', ascending: false);
      
      return response.map((development) => DevelopmentModel.fromMap(development)).toList();
    } catch (e) {
      debugPrint('Error getting developments by status: $e');
      rethrow;
    }
  }
  
  /// Search developments by name or location
  Future<List<DevelopmentModel>> searchDevelopments(String developerId, String query) async {
    try {
      final response = await _client
          .from('developments')
          .select()
          .eq('developer_id', developerId)
          .or('name.ilike.%$query%,location.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return response.map((development) => DevelopmentModel.fromMap(development)).toList();
    } catch (e) {
      debugPrint('Error searching developments: $e');
      rethrow;
    }
  }
  
  /// Upload development images to Supabase storage
  Future<List<String>> uploadDevelopmentImages(String developmentId, List<dynamic> images) async {
    try {
      final imageUrls = <String>[];
      
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final fileName = '$developmentId-${DateTime.now().millisecondsSinceEpoch}-$i';
        
        final response = await _client
            .storage
            .from('development_images')
            .upload(fileName, file);
        
        final imageUrl = _client
            .storage
            .from('development_images')
            .getPublicUrl(response);
        
        imageUrls.add(imageUrl);
      }
      
      return imageUrls;
    } catch (e) {
      debugPrint('Error uploading development images: $e');
      rethrow;
    }
  }
}
