import 'base_model.dart';
import 'lead_activity_model.dart';

/// Lead status types
enum LeadStatus {
  new_lead,
  contacted,
  interested,
  viewing_scheduled,
  negotiating,
  converted,
  lost,
}

/// Lead priority levels
enum LeadPriority {
  low,
  medium,
  high,
  urgent,
}

/// Lead model extending the base model
class LeadModel extends BaseModel {
  final String? propertyId;
  final String? buyerId;
  final String developerId;
  final LeadStatus status;
  final LeadPriority priority;
  final Map<String, dynamic>? budgetRange;
  final Map<String, dynamic>? requirements;
  final String? source;
  final String? notes;
  final List<LeadActivityModel>? activities;

  LeadModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    this.propertyId,
    this.buyerId,
    required this.developerId,
    required this.status,
    required this.priority,
    this.budgetRange,
    this.requirements,
    this.source,
    this.notes,
    this.activities,
  });

  /// Convert lead status to string
  static String statusToString(LeadStatus status) {
    switch (status) {
      case LeadStatus.new_lead:
        return 'new';
      case LeadStatus.contacted:
        return 'contacted';
      case LeadStatus.interested:
        return 'interested';
      case LeadStatus.viewing_scheduled:
        return 'viewing_scheduled';
      case LeadStatus.negotiating:
        return 'negotiating';
      case LeadStatus.converted:
        return 'converted';
      case LeadStatus.lost:
        return 'lost';
      default:
        return 'new';
    }
  }

  /// Convert string to lead status
  static LeadStatus stringToStatus(String? statusStr) {
    switch (statusStr) {
      case 'new':
        return LeadStatus.new_lead;
      case 'contacted':
        return LeadStatus.contacted;
      case 'interested':
        return LeadStatus.interested;
      case 'viewing_scheduled':
        return LeadStatus.viewing_scheduled;
      case 'negotiating':
        return LeadStatus.negotiating;
      case 'converted':
        return LeadStatus.converted;
      case 'lost':
        return LeadStatus.lost;
      default:
        return LeadStatus.new_lead;
    }
  }

  /// Convert lead priority to string
  static String priorityToString(LeadPriority priority) {
    switch (priority) {
      case LeadPriority.low:
        return 'low';
      case LeadPriority.medium:
        return 'medium';
      case LeadPriority.high:
        return 'high';
      case LeadPriority.urgent:
        return 'urgent';
      default:
        return 'medium';
    }
  }

  /// Convert string to lead priority
  static LeadPriority stringToPriority(String? priorityStr) {
    switch (priorityStr) {
      case 'low':
        return LeadPriority.low;
      case 'medium':
        return LeadPriority.medium;
      case 'high':
        return LeadPriority.high;
      case 'urgent':
        return LeadPriority.urgent;
      default:
        return LeadPriority.medium;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'property_id': propertyId,
      'buyer_id': buyerId,
      'developer_id': developerId,
      'status': statusToString(status),
      'priority': priorityToString(priority),
      'budget_range': budgetRange ?? {}, // Ensure we don't send null
      'requirements': requirements ?? {}, // Ensure we don't send null
      'source': source,
      'notes': notes,
      'updated_at': DateTime.now().toIso8601String(), // Always set updated_at on changes
    });
    return map;
  }

  /// Create a lead model from a map
  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      propertyId: map['property_id'],
      buyerId: map['buyer_id'],
      developerId: map['developer_id'] ?? '',
      status: stringToStatus(map['status'] ?? 'new'), // Provide default value
      priority: stringToPriority(map['priority'] ?? 'medium'), // Provide default value
      budgetRange: map['budget_range'] != null 
          ? Map<String, dynamic>.from(map['budget_range'])
          : {}, // Safe conversion with empty default
      requirements: map['requirements'] != null 
          ? Map<String, dynamic>.from(map['requirements'])
          : {}, // Safe conversion with empty default
      source: map['source'],
      notes: map['notes'],
      activities: null, // Activities need to be loaded separately
    );
  }

  /// Create a copy of the lead model with updated fields
  LeadModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? propertyId,
    String? buyerId,
    String? developerId,
    LeadStatus? status,
    LeadPriority? priority,
    Map<String, dynamic>? budgetRange,
    Map<String, dynamic>? requirements,
    String? source,
    String? notes,
    List<LeadActivityModel>? activities,
  }) {
    return LeadModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      propertyId: propertyId ?? this.propertyId,
      buyerId: buyerId ?? this.buyerId,
      developerId: developerId ?? this.developerId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      budgetRange: budgetRange ?? this.budgetRange,
      requirements: requirements ?? this.requirements,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      activities: activities ?? this.activities,
    );
  }
}
