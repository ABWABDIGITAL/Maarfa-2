import 'package:my_academy/model/common/video_courses/video_course_model.dart';

class VideoCoursesDbResponse {
  VideoCoursesDbResponse({
    this.success,
    this.errorCode,
    this.status,
    this.notificationsCount,
    this.messages,
    this.data,
  });

  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  dynamic messages;
  VideoCoursesData? data;

  factory VideoCoursesDbResponse.fromJson(Map<String, dynamic> json) =>
      VideoCoursesDbResponse(
        success: json["success"],
        errorCode: json["errorCode"],
        status: json["status"],
        notificationsCount: json["notificationsCount"],
        messages: json["messages"],
        data: json["data"] != null
            ? VideoCoursesData.fromJson(json["data"])
            : null,
      );
}

class VideoCoursesData {
  VideoCoursesData({this.videoCourses});

  List<VideoCourseModel>? videoCourses;

  factory VideoCoursesData.fromJson(Map<String, dynamic> json) =>
      VideoCoursesData(
        videoCourses: json["video_courses"] != null
            ? List<VideoCourseModel>.from(json["video_courses"]
                .map((x) => VideoCourseModel.fromJson(x)))
            : null,
      );
}

class VideoCourseDetailsDbResponse {
  VideoCourseDetailsDbResponse({
    this.success,
    this.errorCode,
    this.status,
    this.notificationsCount,
    this.messages,
    this.data,
  });

  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  dynamic messages;
  VideoCourseModel? data;

  List<int>? purchasedUnitIds;
  bool? hasCoursePurchase;

  factory VideoCourseDetailsDbResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];
    VideoCourseModel? course;

    if (rawData != null) {
      final courseJson = rawData["video_course"] ?? rawData;
      course = VideoCourseModel.fromJson(courseJson);

      // Mark purchased units based on API response
      final purchasedIds = rawData["purchased_unit_ids"];
      final hasFull = rawData["has_course_purchase"] == true;
      if (course.units != null && (purchasedIds != null || hasFull)) {
        for (var unit in course.units!) {
          if (hasFull || (purchasedIds is List && purchasedIds.contains(unit.id))) {
            unit.isPurchased = true;
          }
        }
      }
    }

    return VideoCourseDetailsDbResponse(
      success: json["success"],
      errorCode: json["errorCode"],
      status: json["status"],
      notificationsCount: json["notificationsCount"],
      messages: json["messages"],
      data: course,
    );
  }
}
