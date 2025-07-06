class GetAllSpecializationsDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  List<SpecializationData>? data;

  GetAllSpecializationsDataModel(
      {this.success,
      this.errorCode,
      this.status,
      this.notificationsCount,
      this.messages,
      this.data});

  GetAllSpecializationsDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    notificationsCount = json['notificationsCount'];
    messages = json['messages'];
    if (json['data'] != null) {
      data = <SpecializationData>[];
      json['data'].forEach((v) {
        data!.add(SpecializationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['errorCode'] = errorCode;
    data['status'] = status;
    data['notificationsCount'] = notificationsCount;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecializationData {
  int? id;
  String? name;
  String? image;

  SpecializationData({this.id, this.name, this.image});

  SpecializationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
