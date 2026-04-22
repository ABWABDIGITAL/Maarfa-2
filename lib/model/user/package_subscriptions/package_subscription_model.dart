import 'package:my_academy/model/common/packages/package_model.dart';

class PackageSubscriptionModel {
  PackageSubscriptionModel({
    this.id,
    this.package,
    this.clientId,
    this.providerId,
    this.sessionsRemaining,
    this.sessionsUsed,
    this.status,
    this.expiresAt,
    this.createdAt,
  });

  int? id;
  PackageModel? package;
  int? clientId;
  int? providerId;
  int? sessionsRemaining;
  int? sessionsUsed;
  String? status;
  String? expiresAt;
  String? createdAt;

  factory PackageSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      PackageSubscriptionModel(
        id: json["id"],
        package: json["package"] != null
            ? PackageModel.fromJson(json["package"])
            : null,
        clientId: json["client_id"],
        providerId: json["provider_id"],
        sessionsRemaining: json["sessions_remaining"],
        sessionsUsed: json["sessions_used"],
        status: json["status"],
        expiresAt: json["expires_at"],
        createdAt: json["created_at"],
      );

  /// Check if subscription is active
  bool get isActive => status == 'active';

  /// Get display label for status
  String get statusLabel {
    switch (status) {
      case 'active':
        return 'Active';
      case 'expired':
        return 'Expired';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status ?? '';
    }
  }
}
