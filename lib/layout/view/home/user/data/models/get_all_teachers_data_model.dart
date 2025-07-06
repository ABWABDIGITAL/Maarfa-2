class GetAllTeachersDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  Data? data;

  GetAllTeachersDataModel(
      {this.success,
      this.errorCode,
      this.status,
      this.notificationsCount,
      this.messages,
      this.data});

  GetAllTeachersDataModel.fromJson(Map<String, dynamic> json) {
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
  Specialization? specialization;
  List<Providers>? providers;

  Data({this.specialization, this.providers});

  Data.fromJson(Map<String, dynamic> json) {
    specialization = json['specialization'] != null
        ? Specialization.fromJson(json['specialization'])
        : null;
    if (json['providers'] != null) {
      providers = <Providers>[];
      json['providers'].forEach((v) {
        providers!.add(Providers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (specialization != null) {
      data['specialization'] = specialization!.toJson();
    }
    if (providers != null) {
      data['providers'] = providers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialization {
  int? id;
  String? name;
  String? image;

  Specialization({this.id, this.name, this.image});

  Specialization.fromJson(Map<String, dynamic> json) {
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

class Providers {
  int? id;
  String? title;
  String? degree;
  String? firstName;
  String? lastName;
  int? rate;
  int? rateCount;
  String? imagePath;

  Providers(
      {this.id,
      this.title,
      this.degree,
      this.firstName,
      this.lastName,
      this.rate,
      this.rateCount,
      this.imagePath});

  Providers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    degree = json['degree'];
    firstName = json['first_name'];
    lastName = json['last_name'];
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
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['image_path'] = imagePath;
    return data;
  }
}
