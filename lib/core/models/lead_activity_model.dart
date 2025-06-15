import 'base_model.dart';

/// Lead activity types
enum ActivityType {
  call,
  email,
  meeting,
  site_visit,
  document_sent,
}

/// Lead activity model extending the base model
class LeadActivityModel extends BaseModel {
  final String leadId;
  final ActivityType activityType;
  final String? description;
  final DateTime? scheduledAt;
  final DateTime? completedAt;
  final String createdById;

  LeadActivityModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.leadId,
    required this.activityType,
    this.description,
    this.scheduledAt,
    this.completedAt,
    required this.createdById,
  });

  /// Convert activity type to string
  static String activityTypeToString(ActivityType type) {
    switch (type) {
      case ActivityType.call:
        return 'call';
      case ActivityType.email:
        return 'email';
      case ActivityType.meeting:
        return 'meeting';
      case ActivityType.site_visit:
        return 'site_visit';
      case ActivityType.document_sent:
        return 'document_sent';
      default:
        return 'call';
    }
  }

  /// Convert string to activity type
  static ActivityType stringToActivityType(String? typeStr) {
    switch (typeStr) {
      case 'call':
        return ActivityType.call;
      case 'email':
        return ActivityType.email;
      case 'meeting':
        return ActivityType.meeting;
      case 'site_visit':
        return ActivityType.site_visit;
      case 'document_sent':
        return ActivityType.document_sent;
      default:
        return ActivityType.call;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'lead_id': leadId,
      'activity_type': activityTypeToString(activityType),
      'description': description ?? '',
      'scheduled_at': scheduledAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_by': createdById,
      'updated_at':
          DateTime.now().toIso8601String(), // Always set updated_at on changes
    });
    return map;
  }

  /// Create a lead activity model from a map
  factory LeadActivityModel.fromMap(Map<String, dynamic> map) {
    return LeadActivityModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      leadId: map['lead_id'] ?? '',
      activityType: stringToActivityType(
          map['activity_type'] ?? 'call'), // Provide default value
      description: map['description'] ?? '',
      scheduledAt: map['scheduled_at'] != null
          ? DateTime.parse(map['scheduled_at'])
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      createdById: map['created_by'] ?? '',
    );
  }

  /// Create a copy of the lead activity model with updated fields
  LeadActivityModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? leadId,
    ActivityType? activityType,
    String? description,
    DateTime? scheduledAt,
    DateTime? completedAt,
    String? createdById,
  }) {
    return LeadActivityModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      leadId: leadId ?? this.leadId,
      activityType: activityType ?? this.activityType,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      createdById: createdById ?? this.createdById,
    );
  }
}
