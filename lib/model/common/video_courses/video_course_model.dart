import 'package:my_academy/model/common/courses/course_details/course_details_model.dart';
import 'package:my_academy/model/common/video_courses/video_unit_model.dart';

class VideoCourseModel {
  VideoCourseModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.totalPrice,
    this.rate,
    this.rateCount,
    this.isActive,
    this.provider,
    this.units,
  });

  int? id;
  String? title;
  String? description;
  String? image;
  double? totalPrice;
  double? rate;
  int? rateCount;
  bool? isActive;
  CourseProvider? provider;
  List<VideoUnitModel>? units;

  factory VideoCourseModel.fromJson(Map<String, dynamic> json) =>
      VideoCourseModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        totalPrice: json["total_price"] != null
            ? (json["total_price"] as num).toDouble()
            : null,
        rate: json["rate"] != null ? (json["rate"] as num).toDouble() : null,
        rateCount: json["rate_count"],
        isActive: json["is_active"],
        provider: json["provider"] != null
            ? CourseProvider.fromJson(json["provider"])
            : null,
        units: json["units"] != null
            ? List<VideoUnitModel>.from(
                json["units"].map((x) => VideoUnitModel.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "total_price": totalPrice,
        "rate": rate,
        "rate_count": rateCount,
        "is_active": isActive,
        "provider": provider?.toJson(),
        "units": units != null
            ? List<dynamic>.from(units!.map((x) => x.toJson()))
            : null,
      };
}
