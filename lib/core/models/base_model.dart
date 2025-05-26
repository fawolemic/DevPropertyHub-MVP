/// Base model class for all models in the application
class BaseModel {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BaseModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert model to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a model from a map
  factory BaseModel.fromMap(Map<String, dynamic> map) {
    return BaseModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }
}
