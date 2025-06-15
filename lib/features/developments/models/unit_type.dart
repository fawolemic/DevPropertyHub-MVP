class UnitType {
  final String? id;
  final String projectId;
  final String? phaseId;
  final String name;
  final int? bedrooms;
  final int? bathrooms;
  final double? squareFootage;
  final int unitCount;
  final double priceMin;
  final double priceMax;
  final String currency;
  final List<String> features;
  final DateTime createdAt;

  UnitType({
    this.id,
    required this.projectId,
    this.phaseId,
    required this.name,
    this.bedrooms,
    this.bathrooms,
    this.squareFootage,
    required this.unitCount,
    required this.priceMin,
    required this.priceMax,
    this.currency = 'NGN',
    this.features = const [],
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory UnitType.fromJson(Map<String, dynamic> json) {
    return UnitType(
      id: json['id'],
      projectId: json['project_id'],
      phaseId: json['phase_id'],
      name: json['name'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      squareFootage: json['square_footage'] != null
          ? double.parse(json['square_footage'].toString())
          : null,
      unitCount: json['unit_count'],
      priceMin: double.parse(json['price_min'].toString()),
      priceMax: double.parse(json['price_max'].toString()),
      currency: json['currency'] ?? 'NGN',
      features:
          json['features'] != null ? List<String>.from(json['features']) : [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'project_id': projectId,
      'phase_id': phaseId,
      'name': name,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'square_footage': squareFootage,
      'unit_count': unitCount,
      'price_min': priceMin,
      'price_max': priceMax,
      'currency': currency,
      'features': features,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UnitType copyWith({
    String? id,
    String? projectId,
    String? phaseId,
    String? name,
    int? bedrooms,
    int? bathrooms,
    double? squareFootage,
    int? unitCount,
    double? priceMin,
    double? priceMax,
    String? currency,
    List<String>? features,
    DateTime? createdAt,
  }) {
    return UnitType(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      phaseId: phaseId ?? this.phaseId,
      name: name ?? this.name,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      squareFootage: squareFootage ?? this.squareFootage,
      unitCount: unitCount ?? this.unitCount,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      currency: currency ?? this.currency,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
