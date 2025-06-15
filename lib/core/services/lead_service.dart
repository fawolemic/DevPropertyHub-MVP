import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/lead_model.dart';

/// Service for handling lead operations with Supabase
class LeadService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Create a new lead
  Future<LeadModel> createLead(LeadModel lead) async {
    try {
      final leadData = lead.toMap();

      // Remove id if it's empty (let Supabase generate it)
      if (lead.id.isEmpty) {
        leadData.remove('id');
      }

      final response =
          await _client.from('leads').insert(leadData).select().single();

      return LeadModel.fromMap(response);
    } catch (e) {
      debugPrint('Error creating lead: $e');
      rethrow;
    }
  }

  /// Get all leads for a developer
  Future<List<LeadModel>> getLeadsByDeveloperId(String developerId) async {
    try {
      final response = await _client
          .from('leads')
          .select()
          .eq('developer_id', developerId)
          .order('created_at', ascending: false);

      return response.map((lead) => LeadModel.fromMap(lead)).toList();
    } catch (e) {
      debugPrint('Error getting leads: $e');
      rethrow;
    }
  }

  /// Get a lead by ID
  Future<LeadModel> getLeadById(String leadId) async {
    try {
      final response =
          await _client.from('leads').select().eq('id', leadId).single();

      return LeadModel.fromMap(response);
    } catch (e) {
      debugPrint('Error getting lead: $e');
      rethrow;
    }
  }

  /// Update a lead
  Future<LeadModel> updateLead(LeadModel lead) async {
    try {
      final leadData = lead.toMap();
      leadData['updated_at'] = DateTime.now().toIso8601String();

      await _client.from('leads').update(leadData).eq('id', lead.id);

      return lead.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      debugPrint('Error updating lead: $e');
      rethrow;
    }
  }

  /// Delete a lead
  Future<void> deleteLead(String leadId) async {
    try {
      await _client.from('leads').delete().eq('id', leadId);
    } catch (e) {
      debugPrint('Error deleting lead: $e');
      rethrow;
    }
  }

  /// Get leads by property ID
  Future<List<LeadModel>> getLeadsByPropertyId(String propertyId) async {
    try {
      final response = await _client
          .from('leads')
          .select()
          .eq('property_id', propertyId)
          .order('created_at', ascending: false);

      return response.map((lead) => LeadModel.fromMap(lead)).toList();
    } catch (e) {
      debugPrint('Error getting leads by property: $e');
      rethrow;
    }
  }

  /// Get leads by status
  Future<List<LeadModel>> getLeadsByStatus(
      String developerId, LeadStatus status) async {
    try {
      final response = await _client
          .from('leads')
          .select()
          .eq('developer_id', developerId)
          .eq('status', LeadModel.statusToString(status))
          .order('created_at', ascending: false);

      return response.map((lead) => LeadModel.fromMap(lead)).toList();
    } catch (e) {
      debugPrint('Error getting leads by status: $e');
      rethrow;
    }
  }

  /// Get leads by priority
  Future<List<LeadModel>> getLeadsByPriority(
      String developerId, LeadPriority priority) async {
    try {
      final response = await _client
          .from('leads')
          .select()
          .eq('developer_id', developerId)
          .eq('priority', LeadModel.priorityToString(priority))
          .order('created_at', ascending: false);

      return response.map((lead) => LeadModel.fromMap(lead)).toList();
    } catch (e) {
      debugPrint('Error getting leads by priority: $e');
      rethrow;
    }
  }

  /// Search leads by name or email
  Future<List<LeadModel>> searchLeads(String developerId, String query) async {
    try {
      final response = await _client
          .from('leads')
          .select()
          .eq('developer_id', developerId)
          .or('name.ilike.%$query%,email.ilike.%$query%')
          .order('created_at', ascending: false);

      return response.map((lead) => LeadModel.fromMap(lead)).toList();
    } catch (e) {
      debugPrint('Error searching leads: $e');
      rethrow;
    }
  }
}
