import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/property_model.dart';

/// Service for handling property operations with Supabase
class PropertyService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Create a new property
  Future<PropertyModel> createProperty(PropertyModel property) async {
    try {
      final propertyData = property.toMap();

      // Remove id if it's empty (let Supabase generate it)
      if (property.id.isEmpty) {
        propertyData.remove('id');
      }

      final response = await _client
          .from('properties')
          .insert(propertyData)
          .select()
          .single();

      return PropertyModel.fromMap(response);
    } catch (e) {
      debugPrint('Error creating property: $e');
      rethrow;
    }
  }

  /// Get all properties for a developer
  Future<List<PropertyModel>> getPropertiesByDeveloperId(
      String developerId) async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('developer_id', developerId)
          .order('created_at', ascending: false);

      return response
          .map((property) => PropertyModel.fromMap(property))
          .toList();
    } catch (e) {
      debugPrint('Error getting properties: $e');
      rethrow;
    }
  }

  /// Get a property by ID
  Future<PropertyModel> getPropertyById(String propertyId) async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('id', propertyId)
          .single();

      return PropertyModel.fromMap(response);
    } catch (e) {
      debugPrint('Error getting property: $e');
      rethrow;
    }
  }

  /// Update a property
  Future<PropertyModel> updateProperty(PropertyModel property) async {
    try {
      final propertyData = property.toMap();
      propertyData['updated_at'] = DateTime.now().toIso8601String();

      await _client
          .from('properties')
          .update(propertyData)
          .eq('id', property.id);

      return property.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      debugPrint('Error updating property: $e');
      rethrow;
    }
  }

  /// Delete a property
  Future<void> deleteProperty(String propertyId) async {
    try {
      await _client.from('properties').delete().eq('id', propertyId);
    } catch (e) {
      debugPrint('Error deleting property: $e');
      rethrow;
    }
  }

  /// Get properties by development ID
  Future<List<PropertyModel>> getPropertiesByDevelopmentId(
      String developmentId) async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('development_id', developmentId)
          .order('created_at', ascending: false);

      return response
          .map((property) => PropertyModel.fromMap(property))
          .toList();
    } catch (e) {
      debugPrint('Error getting properties by development: $e');
      rethrow;
    }
  }

  /// Get properties by status
  Future<List<PropertyModel>> getPropertiesByStatus(
      String developerId, PropertyStatus status) async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('developer_id', developerId)
          .eq('status', PropertyModel.statusToString(status))
          .order('created_at', ascending: false);

      return response
          .map((property) => PropertyModel.fromMap(property))
          .toList();
    } catch (e) {
      debugPrint('Error getting properties by status: $e');
      rethrow;
    }
  }

  /// Get properties by type
  Future<List<PropertyModel>> getPropertiesByType(
      String developerId, PropertyType type) async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('developer_id', developerId)
          .eq('type', PropertyModel.typeToString(type))
          .order('created_at', ascending: false);

      return response
          .map((property) => PropertyModel.fromMap(property))
          .toList();
    } catch (e) {
      debugPrint('Error getting properties by type: $e');
      rethrow;
    }
  }

  /// Search properties by title or location
  Future<List<PropertyModel>> searchProperties(
      String developerId, String query) async {
    try {
      final response = await _client
          .from('properties')
          .select()
          .eq('developer_id', developerId)
          .or('title.ilike.%$query%,location.ilike.%$query%')
          .order('created_at', ascending: false);

      return response
          .map((property) => PropertyModel.fromMap(property))
          .toList();
    } catch (e) {
      debugPrint('Error searching properties: $e');
      rethrow;
    }
  }

  /// Upload property images to Supabase storage
  Future<List<String>> uploadPropertyImages(
      String propertyId, List<dynamic> images) async {
    try {
      final imageUrls = <String>[];

      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final fileName =
            '$propertyId-${DateTime.now().millisecondsSinceEpoch}-$i';

        final response = await _client.storage
            .from('property_images')
            .upload(fileName, file);

        final imageUrl =
            _client.storage.from('property_images').getPublicUrl(response);

        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      debugPrint('Error uploading property images: $e');
      rethrow;
    }
  }
}
