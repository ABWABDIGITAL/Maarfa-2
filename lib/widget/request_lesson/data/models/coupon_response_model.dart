class CouponResponseDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  Data? data;

  CouponResponseDataModel(
      {this.success,
      this.errorCode,
      this.status,
      this.notificationsCount,
      this.messages,
      this.data});

  CouponResponseDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    notificationsCount = json['notificationsCount'];
    messages = json['messages'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['errorCode'] = errorCode;
    data['status'] = status;
    data['notificationsCount'] = notificationsCount;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic originalPrice;
  dynamic discountValue;
  dynamic finalPrice;
  String? coupon;

  Data({this.originalPrice, this.discountValue, this.finalPrice});

  Data.fromJson(Map<String, dynamic> json) {
    originalPrice = json['original_price'];
    discountValue = json['discount_value'];
    finalPrice = json['final_price'];
    coupon = json['coupon_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['original_price'] = originalPrice;
    data['discount_value'] = discountValue;
    data['final_price'] = finalPrice;
    data['coupon_code'] = coupon;
    return data;
  }
}
