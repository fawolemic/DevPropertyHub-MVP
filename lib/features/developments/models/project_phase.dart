enum PhaseStatus { planning, in_progress, completed }

class ProjectPhase {
  final String? id;
  final String projectId;
  final int phaseNumber;
  final String phaseName;
  final String? description;
  final int unitsCount;
  final double completionPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final PhaseStatus status;
  final DateTime createdAt;

  ProjectPhase({
    this.id,
    required this.projectId,
    required this.phaseNumber,
    required this.phaseName,
    this.description,
    required this.unitsCount,
    this.completionPercentage = 0.0,
    this.startDate,
    this.endDate,
    this.status = PhaseStatus.planning,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory ProjectPhase.fromJson(Map<String, dynamic> json) {
    return ProjectPhase(
      id: json['id'],
      projectId: json['project_id'],
      phaseNumber: json['phase_number'],
      phaseName: json['phase_name'],
      description: json['description'],
      unitsCount: json['units_count'],
      completionPercentage: json['completion_percentage'] != null
          ? double.parse(json['completion_percentage'].toString())
          : 0.0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: PhaseStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => PhaseStatus.planning,
      ),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'project_id': projectId,
      'phase_number': phaseNumber,
      'phase_name': phaseName,
      'description': description,
      'units_count': unitsCount,
      'completion_percentage': completionPercentage,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProjectPhase copyWith({
    String? id,
    String? projectId,
    int? phaseNumber,
    String? phaseName,
    String? description,
    int? unitsCount,
    double? completionPercentage,
    DateTime? startDate,
    DateTime? endDate,
    PhaseStatus? status,
    DateTime? createdAt,
  }) {
    return ProjectPhase(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      phaseNumber: phaseNumber ?? this.phaseNumber,
      phaseName: phaseName ?? this.phaseName,
      description: description ?? this.description,
      unitsCount: unitsCount ?? this.unitsCount,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
