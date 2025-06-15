class ProjectUpdate {
  final String? id;
  final String projectId;
  final String title;
  final String content;
  final DateTime updateDate;
  final List<String> mediaUrls;
  final bool isPublished;
  final DateTime createdAt;

  ProjectUpdate({
    this.id,
    required this.projectId,
    required this.title,
    required this.content,
    required this.updateDate,
    this.mediaUrls = const [],
    this.isPublished = true,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory ProjectUpdate.fromJson(Map<String, dynamic> json) {
    return ProjectUpdate(
      id: json['id'],
      projectId: json['project_id'],
      title: json['title'],
      content: json['content'],
      updateDate: DateTime.parse(json['update_date']),
      mediaUrls: json['media_urls'] != null
          ? List<String>.from(json['media_urls'])
          : [],
      isPublished: json['is_published'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'project_id': projectId,
      'title': title,
      'content': content,
      'update_date': updateDate.toIso8601String(),
      'media_urls': mediaUrls,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProjectUpdate copyWith({
    String? id,
    String? projectId,
    String? title,
    String? content,
    DateTime? updateDate,
    List<String>? mediaUrls,
    bool? isPublished,
    DateTime? createdAt,
  }) {
    return ProjectUpdate(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      content: content ?? this.content,
      updateDate: updateDate ?? this.updateDate,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
