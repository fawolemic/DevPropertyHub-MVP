import 'base_model.dart';

/// User roles in the application
enum UserRole {
  developer,
  buyer,
  viewer,
  admin,
}

/// User model extending the base model
class UserModel extends BaseModel {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatarUrl;
  final String? companyName;
  final String? bio;
  final UserRole role;
  final bool isVerified;
  final DateTime? lastLogin;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? profileData;

  UserModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
    this.companyName,
    this.bio,
    required this.role,
    this.isVerified = false,
    this.lastLogin,
    this.preferences,
    this.profileData,
  });

  /// Convert role to string for database storage (user_type field)
  static String roleToString(UserRole role) {
    switch (role) {
      case UserRole.developer:
        return 'developer';
      case UserRole.buyer:
        return 'buyer';
      case UserRole.admin:
        return 'admin';
      case UserRole.viewer:
        return 'viewer';
      default:
        return 'viewer';
    }
  }

  /// Convert string from database (user_type field) to role enum
  static UserRole stringToRole(String? roleStr) {
    switch (roleStr) {
      case 'developer':
        return UserRole.developer;
      case 'buyer':
        return UserRole.buyer;
      case 'admin':
        return UserRole.admin;
      case 'viewer':
        return UserRole.viewer;
      default:
        return UserRole.viewer;
    }
  }

  /// Get database field name for role
  static String get roleFieldName => 'user_type';

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'company_name': companyName,
      'bio': bio,
      'user_type': roleToString(role),
      'is_verified': isVerified,
      'last_login': lastLogin?.toIso8601String(),
      'preferences': preferences ?? {},
      'profile_data': profileData ?? {},
      'updated_at':
          DateTime.now().toIso8601String(), // Always set updated_at on changes
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
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      email: map['email'] ?? '',
      firstName: map['first_name'],
      lastName: map['last_name'],
      phone: map['phone'],
      avatarUrl: map['avatar_url'],
      companyName: map['company_name'],
      bio: map['bio'],
      role: stringToRole(map['user_type'] ?? 'buyer'), // Provide default value
      isVerified: map['is_verified'] ?? false,
      lastLogin:
          map['last_login'] != null ? DateTime.parse(map['last_login']) : null,
      preferences: map['preferences'] != null
          ? Map<String, dynamic>.from(map['preferences'])
          : {}, // Safe conversion with empty default
      profileData: map['profile_data'] != null
          ? Map<String, dynamic>.from(map['profile_data'])
          : {}, // Safe conversion with empty default
    );
  }

  /// Create a copy of the user model with updated fields
  UserModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? companyName,
    String? bio,
    UserRole? role,
    bool? isVerified,
    DateTime? lastLogin,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? profileData,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      companyName: companyName ?? this.companyName,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      lastLogin: lastLogin ?? this.lastLogin,
      preferences: preferences ?? this.preferences,
      profileData: profileData ?? this.profileData,
    );
  }
}
