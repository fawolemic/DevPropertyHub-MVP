import 'base_model.dart';

/// Development status types
enum DevelopmentStatus {
  planning,
  underConstruction,
  completed,
  selling,
  soldOut,
}

/// Development model extending the base model
class DevelopmentModel extends BaseModel {
  final String name;
  final String description;
  final String developerId;
  final DevelopmentStatus status;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime? startDate;
  final DateTime? completionDate;
  final int totalUnits;
  final int availableUnits;
  final List<String>? imageUrls;
  final List<String>? amenities;
  final Map<String, dynamic>? additionalDetails;

  DevelopmentModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.name,
    required this.description,
    required this.developerId,
    required this.status,
    required this.location,
    this.latitude,
    this.longitude,
    this.startDate,
    this.completionDate,
    required this.totalUnits,
    required this.availableUnits,
    this.imageUrls,
    this.amenities,
    this.additionalDetails,
  });

  /// Convert development status to string
  static String statusToString(DevelopmentStatus status) {
    switch (status) {
      case DevelopmentStatus.planning:
        return 'planning';
      case DevelopmentStatus.underConstruction:
        return 'under_construction';
      case DevelopmentStatus.completed:
        return 'completed';
      case DevelopmentStatus.selling:
        return 'selling';
      case DevelopmentStatus.soldOut:
        return 'sold_out';
      default:
        return 'planning';
    }
  }

  /// Convert string to development status
  static DevelopmentStatus stringToStatus(String? statusStr) {
    switch (statusStr) {
      case 'planning':
        return DevelopmentStatus.planning;
      case 'under_construction':
        return DevelopmentStatus.underConstruction;
      case 'completed':
        return DevelopmentStatus.completed;
      case 'selling':
        return DevelopmentStatus.selling;
      case 'sold_out':
        return DevelopmentStatus.soldOut;
      default:
        return DevelopmentStatus.planning;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'name': name,
      'description': description,
      'developer_id': developerId,
      'status': statusToString(status),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'start_date': startDate?.toIso8601String(),
      'completion_date': completionDate?.toIso8601String(),
      'total_units': totalUnits,
      'available_units': availableUnits,
      'image_urls': imageUrls,
      'amenities': amenities,
      'additional_details': additionalDetails,
    });
    return map;
  }

  /// Create a development model from a map
  factory DevelopmentModel.fromMap(Map<String, dynamic> map) {
    return DevelopmentModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      developerId: map['developer_id'] ?? '',
      status: stringToStatus(map['status']),
      location: map['location'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      startDate:
          map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      completionDate: map['completion_date'] != null
          ? DateTime.parse(map['completion_date'])
          : null,
      totalUnits: map['total_units'] ?? 0,
      availableUnits: map['available_units'] ?? 0,
      imageUrls: map['image_urls'] != null
          ? List<String>.from(map['image_urls'])
          : null,
      amenities:
          map['amenities'] != null ? List<String>.from(map['amenities']) : null,
      additionalDetails: map['additional_details'],
    );
  }

  /// Create a copy of the development model with updated fields
  DevelopmentModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? description,
    String? developerId,
    DevelopmentStatus? status,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? startDate,
    DateTime? completionDate,
    int? totalUnits,
    int? availableUnits,
    List<String>? imageUrls,
    List<String>? amenities,
    Map<String, dynamic>? additionalDetails,
  }) {
    return DevelopmentModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      developerId: developerId ?? this.developerId,
      status: status ?? this.status,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      totalUnits: totalUnits ?? this.totalUnits,
      availableUnits: availableUnits ?? this.availableUnits,
      imageUrls: imageUrls ?? this.imageUrls,
      amenities: amenities ?? this.amenities,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }
}
