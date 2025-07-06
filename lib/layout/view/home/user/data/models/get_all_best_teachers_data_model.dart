class GetAllBestTeacherDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  Dataaaa? data;

  GetAllBestTeacherDataModel(
      {this.success,
      this.errorCode,
      this.status,
      this.notificationsCount,
      this.messages,
      this.data});

  GetAllBestTeacherDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    notificationsCount = json['notificationsCount'];
    messages = json['messages'];
    data = json['data'] != null ? Dataaaa.fromJson(json['data']) : null;
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

class Dataaaa {
  List<ProvidersMM>? providers;

  Dataaaa({this.providers});

  Dataaaa.fromJson(Map<String, dynamic> json) {
    if (json['providers'] != null) {
      providers = <ProvidersMM>[];
      json['providers'].forEach((v) {
        providers!.add(ProvidersMM.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (providers != null) {
      data['providers'] = providers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProvidersMM {
  int? id;
  String? title;
  String? degree;
  String? firstName;
  String? lastName;
  String? specialization;
  int? rate;
  int? rateCount;
  String? imagePath;

  ProvidersMM(
      {this.id,
      this.title,
      this.degree,
      this.firstName,
      this.lastName,
      this.specialization,
      this.rate,
      this.rateCount,
      this.imagePath});

  ProvidersMM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    degree = json['degree'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    specialization = json['specialization'];
    rate = json['rate'];
    rateCount = json['rate_count'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['degree'] = degree;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['specialization'] = specialization;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['image_path'] = imagePath;
    return data;
  }
}
