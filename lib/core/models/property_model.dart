import 'base_model.dart';

/// Property status types
enum PropertyStatus {
  available,
  reserved,
  sold,
  underConstruction,
  comingSoon,
}

/// Property type categories
enum PropertyType {
  apartment,
  house,
  villa,
  land,
  commercial,
  other,
}

/// Property model extending the base model
class PropertyModel extends BaseModel {
  final String title;
  final String description;
  final String developerId;
  final String? developmentId;
  final PropertyType type;
  final PropertyStatus status;
  final double price;
  final String? priceUnit; // e.g., USD, EUR, GBP
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String? areaUnit; // e.g., sqft, sqm
  final String location;
  final double? latitude;
  final double? longitude;
  final List<String>? features;
  final List<String>? imageUrls;
  final Map<String, dynamic>? additionalDetails;

  PropertyModel({
    required super.id,
    required super.createdAt,
    super.updatedAt,
    required this.title,
    required this.description,
    required this.developerId,
    this.developmentId,
    required this.type,
    required this.status,
    required this.price,
    this.priceUnit = 'USD',
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    this.areaUnit = 'sqft',
    required this.location,
    this.latitude,
    this.longitude,
    this.features,
    this.imageUrls,
    this.additionalDetails,
  });

  /// Convert property status to string
  static String statusToString(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.available:
        return 'available';
      case PropertyStatus.reserved:
        return 'reserved';
      case PropertyStatus.sold:
        return 'sold';
      case PropertyStatus.underConstruction:
        return 'under_construction';
      case PropertyStatus.comingSoon:
        return 'coming_soon';
      default:
        return 'available';
    }
  }

  /// Convert string to property status
  static PropertyStatus stringToStatus(String? statusStr) {
    switch (statusStr) {
      case 'available':
        return PropertyStatus.available;
      case 'reserved':
        return PropertyStatus.reserved;
      case 'sold':
        return PropertyStatus.sold;
      case 'under_construction':
        return PropertyStatus.underConstruction;
      case 'coming_soon':
        return PropertyStatus.comingSoon;
      default:
        return PropertyStatus.available;
    }
  }

  /// Convert property type to string
  static String typeToString(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return 'apartment';
      case PropertyType.house:
        return 'house';
      case PropertyType.villa:
        return 'villa';
      case PropertyType.land:
        return 'land';
      case PropertyType.commercial:
        return 'commercial';
      case PropertyType.other:
        return 'other';
      default:
        return 'apartment';
    }
  }

  /// Convert string to property type
  static PropertyType stringToType(String? typeStr) {
    switch (typeStr) {
      case 'apartment':
        return PropertyType.apartment;
      case 'house':
        return PropertyType.house;
      case 'villa':
        return PropertyType.villa;
      case 'land':
        return PropertyType.land;
      case 'commercial':
        return PropertyType.commercial;
      case 'other':
        return PropertyType.other;
      default:
        return PropertyType.apartment;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'title': title,
      'description': description,
      'developer_id': developerId,
      'development_id': developmentId,
      'type': typeToString(type),
      'status': statusToString(status),
      'price': price,
      'price_unit': priceUnit,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'area_unit': areaUnit,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'features': features,
      'image_urls': imageUrls,
      'additional_details': additionalDetails,
    });
    return map;
  }

  /// Create a property model from a map
  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      developerId: map['developer_id'] ?? '',
      developmentId: map['development_id'],
      type: stringToType(map['type']),
      status: stringToStatus(map['status']),
      price: (map['price'] ?? 0).toDouble(),
      priceUnit: map['price_unit'] ?? 'USD',
      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      area: (map['area'] ?? 0).toDouble(),
      areaUnit: map['area_unit'] ?? 'sqft',
      location: map['location'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      features: map['features'] != null ? List<String>.from(map['features']) : null,
      imageUrls: map['image_urls'] != null ? List<String>.from(map['image_urls']) : null,
      additionalDetails: map['additional_details'],
    );
  }

  /// Create a copy of the property model with updated fields
  PropertyModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? description,
    String? developerId,
    String? developmentId,
    PropertyType? type,
    PropertyStatus? status,
    double? price,
    String? priceUnit,
    int? bedrooms,
    int? bathrooms,
    double? area,
    String? areaUnit,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? features,
    List<String>? imageUrls,
    Map<String, dynamic>? additionalDetails,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      developerId: developerId ?? this.developerId,
      developmentId: developmentId ?? this.developmentId,
      type: type ?? this.type,
      status: status ?? this.status,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      features: features ?? this.features,
      imageUrls: imageUrls ?? this.imageUrls,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }
}
