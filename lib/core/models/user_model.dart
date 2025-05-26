import 'base_model.dart';

/// User roles in the application
enum UserRole {
  developer,
  buyer,
  admin,
}

/// User model extending the base model
class UserModel extends BaseModel {
  final String email;
  final String? fullName;
  final String? photoUrl;
  final UserRole role;
  final bool isEmailVerified;
  final Map<String, dynamic>? metadata;

  UserModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.email,
    this.fullName,
    this.photoUrl,
    required this.role,
    this.isEmailVerified = false,
    this.metadata,
  });

  /// Convert the user role to a string
  static String roleToString(UserRole role) {
    switch (role) {
      case UserRole.developer:
        return 'developer';
      case UserRole.buyer:
        return 'buyer';
      case UserRole.admin:
        return 'admin';
      default:
        return 'buyer';
    }
  }

  /// Convert a string to a user role
  static UserRole stringToRole(String? roleStr) {
    switch (roleStr) {
      case 'developer':
        return UserRole.developer;
      case 'buyer':
        return UserRole.buyer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.buyer;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'email': email,
      'full_name': fullName,
      'photo_url': photoUrl,
      'role': roleToString(role),
      'is_email_verified': isEmailVerified,
      'metadata': metadata,
    });
    return map;
  }

  /// Create a user model from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      email: map['email'] ?? '',
      fullName: map['full_name'],
      photoUrl: map['photo_url'],
      role: stringToRole(map['role']),
      isEmailVerified: map['is_email_verified'] ?? false,
      metadata: map['metadata'],
    );
  }

  /// Create a copy of the user model with updated fields
  UserModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
    String? fullName,
    String? photoUrl,
    UserRole? role,
    bool? isEmailVerified,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      metadata: metadata ?? this.metadata,
    );
  }
}
