import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/common/courses/course_details/course_details_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseDetailsModel data;
  final String courseTitle;
  final String specialization;
  // const CourseCard2({Key? key, this.isBlue = false}) : super(key: key);
  const CourseInfoCard({
    super.key,
    required this.courseTitle,
    required this.specialization,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: 425.h,
      color: textfieldColor.withValues(alpha: 0.1),
      child: Column(
        children: [
          Stack(
            alignment: FractionalOffset.topRight,
            children: [
              SizedBox(
                width: screenWidth,
                child: CachedImage(
                  imageUrl: data.image ?? "",
                  width: screenWidth,
                  height: 300.h,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        //padding: EdgeInsets.only(top: 40, right: 30),
                        height: 40.h,
                        width: 50.w,
                        // clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(
                          color: white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  Space(
                    boxHeight: 30.h,
                  ),
                  _courseInformation(courseTitle),
                ],
              ),
            ],
          ),
          Space(
            boxHeight: 15.h,
          ),
          _courseInfo(specialization),
        ],
      ),
    );
  }

  _courseInfo(String specialization) {
    return SidePadding(
      sidePadding: 20,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                specialization,
                style: TextStyles.hintStyle
                    .copyWith(color: grey, fontWeight: FontWeight.bold),
              ),
            ]),
            Space(
              boxHeight: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.type == 1 ? tr("offline") : tr("online"),
                  style: TextStyles.contentStyle
                      .copyWith(color: mainColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Space(
              boxHeight: 10,
            ),
            Row(
              children: [
                Text(
                  data.priceWithoutTax.toString(),
                  style: TextStyles.priceStyle,
                ),
                Text(
                  tr("sar"),
                  style: TextStyles.selectedStyle.copyWith(
                    color: black,
                  ),
                ),
                Text(
                  "/",
                  style: TextStyles.titleStyle.copyWith(color: black),
                ),
                Text(
                  data.numberOfHours.toString(),
                  style: TextStyles.selectedStyle,
                ),
                Text(
                  tr("hour"),
                  style: TextStyles.contentStyle.copyWith(color: mainColor),
                ),
              ],
            ),
            const Space(
              boxHeight: 10,
            ),
          ]),
    );
  }

  _courseInformation(String title) {
    return SidePadding(
      sidePadding: 20,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LimitedBox(
                  maxWidth: 300.w,
                  child: Text(
                    title,
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyles.introStyle
                        .copyWith(color: white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Space(
              boxHeight: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  star,
                  height: 15.h,
                  fit: BoxFit.contain,
                ),
                Text(
                  data.provider?.rate.toString() ?? '',
                  style: TextStyles.subTitleStyle.copyWith(
                      color: Colors.yellow, fontWeight: FontWeight.w700),
                ),
                Text(
                  "(${data.provider?.rateCount} ${tr("rater")})",
                  style: TextStyles.smallStyle.copyWith(color: white),
                ),
              ],
            ),
          ]),
    );
  }
}
