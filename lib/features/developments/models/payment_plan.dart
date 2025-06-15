enum PlanType { outright, installmental, construction_linked }

enum InstallmentFrequency { monthly, quarterly, milestone }

class PaymentPlan {
  final String? id;
  final String projectId;
  final String? unitTypeId;
  final String planName;
  final PlanType planType;
  final double? initialDepositPercentage;
  final int? installmentCount;
  final InstallmentFrequency? installmentFrequency;
  final String? termsDescription;
  final DateTime createdAt;

  PaymentPlan({
    this.id,
    required this.projectId,
    this.unitTypeId,
    required this.planName,
    required this.planType,
    this.initialDepositPercentage,
    this.installmentCount,
    this.installmentFrequency,
    this.termsDescription,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['id'],
      projectId: json['project_id'],
      unitTypeId: json['unit_type_id'],
      planName: json['plan_name'],
      planType: PlanType.values.firstWhere(
        (type) => type.toString().split('.').last == json['plan_type'],
        orElse: () => PlanType.outright,
      ),
      initialDepositPercentage: json['initial_deposit_percentage'] != null
          ? double.parse(json['initial_deposit_percentage'].toString())
          : null,
      installmentCount: json['installment_count'],
      installmentFrequency: json['installment_frequency'] != null
          ? InstallmentFrequency.values.firstWhere(
              (freq) =>
                  freq.toString().split('.').last ==
                  json['installment_frequency'],
              orElse: () => InstallmentFrequency.monthly,
            )
          : null,
      termsDescription: json['terms_description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'project_id': projectId,
      'unit_type_id': unitTypeId,
      'plan_name': planName,
      'plan_type': planType.toString().split('.').last,
      'initial_deposit_percentage': initialDepositPercentage,
      'installment_count': installmentCount,
      'installment_frequency': installmentFrequency?.toString().split('.').last,
      'terms_description': termsDescription,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PaymentPlan copyWith({
    String? id,
    String? projectId,
    String? unitTypeId,
    String? planName,
    PlanType? planType,
    double? initialDepositPercentage,
    int? installmentCount,
    InstallmentFrequency? installmentFrequency,
    String? termsDescription,
    DateTime? createdAt,
  }) {
    return PaymentPlan(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      unitTypeId: unitTypeId ?? this.unitTypeId,
      planName: planName ?? this.planName,
      planType: planType ?? this.planType,
      initialDepositPercentage:
          initialDepositPercentage ?? this.initialDepositPercentage,
      installmentCount: installmentCount ?? this.installmentCount,
      installmentFrequency: installmentFrequency ?? this.installmentFrequency,
      termsDescription: termsDescription ?? this.termsDescription,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
