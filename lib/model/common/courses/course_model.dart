import 'package:my_academy/model/common/courses/course_details/course_details_model.dart';
import 'package:my_academy/model/common/specializations/specializations_model.dart';

class CourseModel {
  CourseModel(
      {this.id,
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
      this.price,
      this.subscriptions,
      this.isBookmarked,
      this.createdAt,
      this.nextTime,
      this.requestsCount,
      this.provider});

  int? id;
  String? name;
  String? content;
  SpecializationsModel? specialization;
  int? type;
  String? courseCategory;
  String? courseSubType;
  int? attendanceType;
  int? maxStudents;
  int? requestsCount;
  String? location;
  String? videoUrl;
  String? image;
  double? rate;
  int? rateCount;
  int? numberOfHours;
  String? price;
  int? subscriptions;
  bool? isBookmarked;
  DateTime? createdAt;
  String? nextTime;
  CourseProvider? provider;

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        provider: CourseProvider.fromJson(json["provider"]),
        id: json["id"],
        name: json["name"],
        content: json["content"],
        specialization: SpecializationsModel.fromJson(json["specialization"]),
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
        requestsCount: json["requests_count"],
        numberOfHours: json["number_of_hours"],
        price: json["price"],
        subscriptions: json["subscriptions"],
        isBookmarked: json["is_bookmarked"],
        createdAt: DateTime.parse(json["created_at"]),
        nextTime: json["nextTime"],
      );
}
