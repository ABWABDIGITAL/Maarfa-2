class PackageModel {
  PackageModel({
    this.id,
    this.providerId,
    this.providerName,
    this.type,
    this.sessionCount,
    this.price,
    this.subjectId,
    this.subjectName,
    this.educationalStageId,
    this.educationalStageName,
    this.description,
    this.isActive,
    this.subscriptionsCount,
    this.createdAt,
  });

  int? id;
  int? providerId;
  String? providerName;
  String? type;
  int? sessionCount;
  double? price;
  int? subjectId;
  String? subjectName;
  int? educationalStageId;
  String? educationalStageName;
  String? description;
  bool? isActive;
  int? subscriptionsCount;
  String? createdAt;

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        id: json["id"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        type: json["type"],
        sessionCount: json["session_count"],
        price: json["price"] != null ? (json["price"] as num).toDouble() : null,
        subjectId: json["subject_id"],
        subjectName: json["subject_name"],
        educationalStageId: json["educational_stage_id"],
        educationalStageName: json["educational_stage_name"],
        description: json["description"],
        isActive: json["is_active"],
        subscriptionsCount: json["subscriptions_count"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "price": price,
        "subject_id": subjectId,
        "educational_stage_id": educationalStageId,
        "description": description,
        "is_active": isActive,
      };

  /// Get the display label for the package type
  String get typeLabel {
    switch (type) {
      case '4_sessions':
        return '4 Sessions';
      case '8_sessions':
        return '8 Sessions';
      case '12_sessions':
        return '12 Sessions';
      case 'full_term':
        return 'Full Term';
      default:
        return type ?? '';
    }
  }
}
