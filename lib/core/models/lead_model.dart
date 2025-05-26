import 'base_model.dart';

/// Lead status types
enum LeadStatus {
  new_lead,
  interested,
  viewingScheduled,
  offerMade,
  converted,
  lost,
}

/// Lead priority levels
enum LeadPriority {
  low,
  medium,
  high,
}

/// Lead model extending the base model
class LeadModel extends BaseModel {
  final String name;
  final String email;
  final String? phone;
  final String? propertyId;
  final String? propertyName;
  final String developerId;
  final LeadStatus status;
  final LeadPriority priority;
  final String? budget;
  final String? notes;
  final DateTime? lastContactDate;
  final List<String>? tags;

  LeadModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.name,
    required this.email,
    this.phone,
    this.propertyId,
    this.propertyName,
    required this.developerId,
    required this.status,
    required this.priority,
    this.budget,
    this.notes,
    this.lastContactDate,
    this.tags,
  });

  /// Convert lead status to string
  static String statusToString(LeadStatus status) {
    switch (status) {
      case LeadStatus.new_lead:
        return 'new_lead';
      case LeadStatus.interested:
        return 'interested';
      case LeadStatus.viewingScheduled:
        return 'viewing_scheduled';
      case LeadStatus.offerMade:
        return 'offer_made';
      case LeadStatus.converted:
        return 'converted';
      case LeadStatus.lost:
        return 'lost';
      default:
        return 'new_lead';
    }
  }

  /// Convert string to lead status
  static LeadStatus stringToStatus(String? statusStr) {
    switch (statusStr) {
      case 'new_lead':
        return LeadStatus.new_lead;
      case 'interested':
        return LeadStatus.interested;
      case 'viewing_scheduled':
        return LeadStatus.viewingScheduled;
      case 'offer_made':
        return LeadStatus.offerMade;
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
      default:
        return LeadPriority.medium;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'name': name,
      'email': email,
      'phone': phone,
      'property_id': propertyId,
      'property_name': propertyName,
      'developer_id': developerId,
      'status': statusToString(status),
      'priority': priorityToString(priority),
      'budget': budget,
      'notes': notes,
      'last_contact_date': lastContactDate?.toIso8601String(),
      'tags': tags,
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
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      propertyId: map['property_id'],
      propertyName: map['property_name'],
      developerId: map['developer_id'] ?? '',
      status: stringToStatus(map['status']),
      priority: stringToPriority(map['priority']),
      budget: map['budget'],
      notes: map['notes'],
      lastContactDate: map['last_contact_date'] != null
          ? DateTime.parse(map['last_contact_date'])
          : null,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
    );
  }

  /// Create a copy of the lead model with updated fields
  LeadModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? email,
    String? phone,
    String? propertyId,
    String? propertyName,
    String? developerId,
    LeadStatus? status,
    LeadPriority? priority,
    String? budget,
    String? notes,
    DateTime? lastContactDate,
    List<String>? tags,
  }) {
    return LeadModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      developerId: developerId ?? this.developerId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      budget: budget ?? this.budget,
      notes: notes ?? this.notes,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      tags: tags ?? this.tags,
    );
  }
}
