enum MediaType { image, video, floor_plan, virtual_tour, document }

class ProjectMedia {
  final String? id;
  final String projectId;
  final MediaType mediaType;
  final String fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final bool isHero;
  final int displayOrder;
  final String? altText;
  final DateTime createdAt;

  ProjectMedia({
    this.id,
    required this.projectId,
    required this.mediaType,
    required this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.isHero = false,
    this.displayOrder = 0,
    this.altText,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory ProjectMedia.fromJson(Map<String, dynamic> json) {
    return ProjectMedia(
      id: json['id'],
      projectId: json['project_id'],
      mediaType: MediaType.values.firstWhere(
        (type) => type.toString().split('.').last == json['media_type'],
        orElse: () => MediaType.image,
      ),
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
      mimeType: json['mime_type'],
      isHero: json['is_hero'] ?? false,
      displayOrder: json['display_order'] ?? 0,
      altText: json['alt_text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'project_id': projectId,
      'media_type': mediaType.toString().split('.').last,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'mime_type': mimeType,
      'is_hero': isHero,
      'display_order': displayOrder,
      'alt_text': altText,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProjectMedia copyWith({
    String? id,
    String? projectId,
    MediaType? mediaType,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    bool? isHero,
    int? displayOrder,
    String? altText,
    DateTime? createdAt,
  }) {
    return ProjectMedia(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      mediaType: mediaType ?? this.mediaType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      isHero: isHero ?? this.isHero,
      displayOrder: displayOrder ?? this.displayOrder,
      altText: altText ?? this.altText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
