import 'package:flutter/foundation.dart';

enum ProjectType { residential, commercial, mixed_use, estate }

enum ProjectStatus { draft, published, completed, cancelled }

class Project {
  final String? id;
  final String developerId;
  final String name;
  final String slug;
  final String? description;
  final String locationState;
  final String locationLga;
  final String? locationAddress;
  final Map<String, double>? coordinates; // {latitude, longitude}
  final ProjectType projectType;
  final ProjectStatus status;
  final int? totalUnits;
  final int totalPhases;
  final DateTime? estimatedCompletionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    this.id,
    required this.developerId,
    required this.name,
    required this.slug,
    this.description,
    required this.locationState,
    required this.locationLga,
    this.locationAddress,
    this.coordinates,
    required this.projectType,
    this.status = ProjectStatus.draft,
    this.totalUnits,
    this.totalPhases = 1,
    this.estimatedCompletionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    this.createdAt = createdAt ?? DateTime.now(),
    this.updatedAt = updatedAt ?? DateTime.now();
    
  // Convenience getter for location display
  String get location {
    if (locationAddress != null && locationAddress!.isNotEmpty) {
      return locationAddress!;
    }
    return '$locationLga, $locationState';
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      developerId: json['developer_id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      locationState: json['location_state'],
      locationLga: json['location_lga'],
      locationAddress: json['location_address'],
      coordinates: json['coordinates'] != null 
        ? {
            'latitude': json['coordinates']['latitude'],
            'longitude': json['coordinates']['longitude'],
          }
        : null,
      projectType: ProjectType.values.firstWhere(
        (type) => type.toString().split('.').last == json['project_type'],
        orElse: () => ProjectType.residential,
      ),
      status: ProjectStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => ProjectStatus.draft,
      ),
      totalUnits: json['total_units'],
      totalPhases: json['total_phases'] ?? 1,
      estimatedCompletionDate: json['estimated_completion_date'] != null
        ? DateTime.parse(json['estimated_completion_date'])
        : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'developer_id': developerId,
      'name': name,
      'slug': slug,
      'description': description,
      'location_state': locationState,
      'location_lga': locationLga,
      'location_address': locationAddress,
      'coordinates': coordinates,
      'project_type': projectType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'total_units': totalUnits,
      'total_phases': totalPhases,
      'estimated_completion_date': estimatedCompletionDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Project copyWith({
    String? id,
    String? developerId,
    String? name,
    String? slug,
    String? description,
    String? locationState,
    String? locationLga,
    String? locationAddress,
    Map<String, double>? coordinates,
    ProjectType? projectType,
    ProjectStatus? status,
    int? totalUnits,
    int? totalPhases,
    DateTime? estimatedCompletionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      developerId: developerId ?? this.developerId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      locationState: locationState ?? this.locationState,
      locationLga: locationLga ?? this.locationLga,
      locationAddress: locationAddress ?? this.locationAddress,
      coordinates: coordinates ?? this.coordinates,
      projectType: projectType ?? this.projectType,
      status: status ?? this.status,
      totalUnits: totalUnits ?? this.totalUnits,
      totalPhases: totalPhases ?? this.totalPhases,
      estimatedCompletionDate: estimatedCompletionDate ?? this.estimatedCompletionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
