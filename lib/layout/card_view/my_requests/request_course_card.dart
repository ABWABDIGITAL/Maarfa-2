import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/res/drawable/icon/icons.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';

import '../../../res/value/style/textstyles.dart';
import '../../../widget/logo/logo/logo.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../activity/user_screens/request/course_pay/pay_screen.dart';

class RequestCourseCard extends StatelessWidget {
  final String courseTitle;
  final String? image;
  final int id, courseId;
  final String name;
  final String price;
  final String attendance;
  final String acceptanceCheck;
  const RequestCourseCard({
    super.key,
    required this.courseTitle,
    required this.courseId,
    this.image,
    required this.acceptanceCheck,
    required this.price,
    required this.name,
    required this.id,
    required this.attendance,
    // required this.onlineCheck
    // required this.onlineCheck
    // required this.finishPercent
  });

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 15,
      // child: GestureDetector(
      //   onTap: () {
      //     Get.to(const RequsetAndDownload());
      //   },
      child: InkWell(
        onTap: () => Get.to(() => PayScreen(
              type: "course",
              id: courseId,
              isRequest: true,
              requestId: id,
            )),
        child: Container(
          padding: const EdgeInsets.all(5),
          width: screenWidth,
          decoration: BoxDecoration(
            color: white,
            // height: 110.h,
            // decoration: BoxDecoration(
            //   color:
            //   finishPercent == 1 ? inProgressColor.withValues(alpha:0.1) : white,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              color:
                  //     finishPercent == 1 ? inProgressBorderColor :
                  textfieldColor,
            ),
          ),
          child: SidePadding(
            sidePadding: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: FractionalOffset.center,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r)),
                          child: CachedNetworkImage(
                              imageUrl: image ?? "",
                              width: 75.w,
                              height: 65.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Logo(
                                    logoHeight: 50,
                                    logoWidth: 50,
                                  )),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          width: 55.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                              color: black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Center(
                              child: Text(attendance,
                                  style: TextStyles.errorStyle
                                      .copyWith(color: white))),
                        ),
                      ],
                    ),
                    const Space(
                      boxHeight: 5,
                    ),
                    Text("#$id",
                        style: TextStyles.errorStyle
                            .copyWith(color: textfieldColor)),
                  ],
                ),
                const Space(
                  boxWidth: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(courseTitle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.appBarStyle.copyWith(
                              color: blackColor, fontWeight: FontWeight.bold)),
                      const Space(
                        boxHeight: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            profile,
                            height: 15.h,
                            fit: BoxFit.contain,
                            color: textfieldColor,
                          ),
                          const Space(
                            boxWidth: 5,
                          ),
                          Expanded(
                              child: Text(name, style: TextStyles.hintStyle)),
                        ],
                      ),
                      const Space(
                        boxHeight: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(money, height: 15.h, fit: BoxFit.contain),
                          const Space(
                            boxWidth: 5,
                          ),
                          Text("$price ${tr("sar")}",
                              style: TextStyles.hintStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(acceptanceCheck,
                                  style: TextStyles.hintStyle
                                      .copyWith(color: blackColor)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
