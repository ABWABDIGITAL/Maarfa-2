class VideoPurchaseModel {
  VideoPurchaseModel({
    this.id,
    this.purchaseableType,
    this.purchaseableId,
    this.pricePaid,
    this.purchasedAt,
  });

  int? id;
  String? purchaseableType;
  int? purchaseableId;
  double? pricePaid;
  String? purchasedAt;

  factory VideoPurchaseModel.fromJson(Map<String, dynamic> json) =>
      VideoPurchaseModel(
        id: json["id"],
        purchaseableType: json["purchaseable_type"],
        purchaseableId: json["purchaseable_id"],
        pricePaid: json["price_paid"] != null
            ? (json["price_paid"] as num).toDouble()
            : null,
        purchasedAt: json["purchased_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purchaseable_type": purchaseableType,
        "purchaseable_id": purchaseableId,
        "price_paid": pricePaid,
        "purchased_at": purchasedAt,
      };
}

class VideoPurchasesDbResponse {
  VideoPurchasesDbResponse({
    this.success,
    this.status,
    this.messages,
    this.data,
  });

  bool? success;
  int? status;
  dynamic messages;
  List<VideoPurchaseModel>? data;

  factory VideoPurchasesDbResponse.fromJson(Map<String, dynamic> json) =>
      VideoPurchasesDbResponse(
        success: json["success"],
        status: json["status"],
        messages: json["messages"],
        data: json["data"] != null
            ? List<VideoPurchaseModel>.from(
                json["data"].map((x) => VideoPurchaseModel.fromJson(x)))
            : null,
      );
}
