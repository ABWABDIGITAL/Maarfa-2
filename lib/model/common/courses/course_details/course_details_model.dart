import 'dart:core';

class CourseDetailsModel {
  CourseDetailsModel({
    this.id,
    this.name,
    this.content,
    this.specialization,
    this.type,
    this.courseCategory,
    this.courseSubType,
    this.attendanceType,
    this.maxStudents,
    this.location,
    this.videoUrl,
    this.image,
    this.rate,
    this.rateCount,
    this.numberOfHours,
    this.priceWithoutTax,
    this.subscriptions,
    this.tags,
    this.provider,
    this.isBookmarked,
    this.isRequested,
    this.createdAt,
    this.nextTime,
    this.priceWithTax,
    this.tax,
  });

  String get price => priceWithoutTax ?? '';

  int? id;
  String? name;
  String? content;
  Specialization? specialization;
  int? type;
  String? courseCategory;
  String? courseSubType;
  int? attendanceType;
  int? maxStudents;
  String? location;
  String? videoUrl;
  String? image;
  double? rate;
  int? rateCount;
  int? numberOfHours;
  String? priceWithoutTax;
  final String? priceWithTax;
  final String? tax;
  int? subscriptions;
  String? nextTime;

  List<TagsModel>? tags;
  CourseProvider? provider;
  bool? isBookmarked;
  bool? isRequested;
  DateTime? createdAt;

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailsModel(
        id: json["id"],
        name: json["name"],
        content: json["content"],
        specialization: Specialization.fromJson(json["specialization"]),
        type: json["type"],
        courseCategory: json["course_category"],
        courseSubType: json["course_sub_type"],
        attendanceType: json["attendance_type"],
        maxStudents: json["max_students"],
        location: json["location"],
        videoUrl: json["video_url"],
        image: json["image"],
        rate: (json["rate"] as num).toDouble(),
        rateCount: json["rate_count"],
        numberOfHours: json["number_of_hours"],
        priceWithoutTax: (json["price"] ?? '').toString(),
        tax: (json["tax"] ?? '').toString(),
        priceWithTax: (json["price_with_tax"] ?? '').toString(),
        subscriptions: json["subscriptions"],
        tags: List<TagsModel>.from(
            json["tags"].map((x) => TagsModel.fromJson(x))),
        provider: CourseProvider.fromJson(json["provider"]),
        isBookmarked: json["is_bookmarked"],
        isRequested: json["is_requested"],
        nextTime: json["nextTime"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "content": content,
        "specialization": specialization!.toJson(),
        "type": type,
        "course_category": courseCategory,
        "course_sub_type": courseSubType,
        "attendance_type": attendanceType,
        "max_students": maxStudents,
        "location": location,
        "video_url": videoUrl,
        "image": image,
        "rate": rate,
        "rate_count": rateCount,
        "number_of_hours": numberOfHours,
        "price": priceWithoutTax,
        "subscriptions": subscriptions,
        "tags": List<TagsModel>.from(tags!.map((x) => x)),
        "provider": provider!,
        "is_bookmarked": isBookmarked,
        "is_requested": isRequested,
        "nextTime": nextTime,
        "created_at":
            "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
      };
}

class TagsModel {
  TagsModel({
    this.id,
    this.name,
  });
  int? id;
  String? name;

  factory TagsModel.fromJson(Map<String, dynamic> json) => TagsModel(
        id: json["id"],
        name: json["name"],
      );
}

class CourseProvider {
  CourseProvider({
    this.id,
    this.title,
    this.firstName,
    this.lastName,
    this.imagePath,
    this.bio,
    this.rate,
    this.rateCount,
  });

  int? id;
  String? title;
  String? firstName;
  String? lastName;
  String? imagePath;
  String? bio;
  double? rate;
  int? rateCount;

  factory CourseProvider.fromJson(Map<String, dynamic> json) => CourseProvider(
        id: json["id"],
        title: json["title"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        imagePath: json["image_path"],
        bio: json["bio"],
        rate: (json["rate"] as num).toDouble(),
        rateCount: json["rate_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "first_name": firstName,
        "last_name": lastName,
        "image_path": imagePath,
        "bio": bio,
        "rate": rate,
        "rate_count": rateCount,
      };
}

class Specialization {
  Specialization({
    this.id,
    this.name,
    this.image,
  });
  int? id;
  String? name;
  String? image;

  factory Specialization.fromJson(Map<String, dynamic> json) => Specialization(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
