import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/drawable/icon/icons.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';

import '../../../res/value/style/textstyles.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
// import '../../activity/auth/register/user/request_download.dart';

class SubscribeCourseCard extends StatelessWidget {
  final double finishPercent;
  final String status;
  final int id;
  final String providerName;
  final String courseTitle;
  final String price;
  final String? image;
  const SubscribeCourseCard(
      {super.key,
      required this.finishPercent,
      required this.status,
      required this.id,
      required this.providerName,
      required this.courseTitle,
      required this.price,
      this.image});

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 15,
      child: Container(
        width: screenWidth,
        height: 130.h,
        decoration: BoxDecoration(
          color: finishPercent == 1
              ? inProgressColor.withValues(alpha: 0.1)
              : white,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: finishPercent == 1 ? inProgressBorderColor : textfieldColor,
          ),
        ),
        child: Column(
          children: [
            SidePadding(
              sidePadding: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
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
                              child: CachedImage(
                                imageUrl: image!,
                                width: 75.w,
                                height: 65.h,
                                fit: BoxFit.cover,
                              )),
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            width: 55.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                                color: black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Center(
                                child: Text(status,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth / 2,
                        child: Text(courseTitle,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.appBarStyle.copyWith(
                                color: blackColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: screenWidth / 2,
                        child: Row(
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
                            Text(providerName, style: TextStyles.hintStyle),
                          ],
                        ),
                      ),
                      const Space(
                        boxWidth: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(money, height: 15.h, fit: BoxFit.contain),
                          const Space(
                            boxWidth: 5,
                          ),
                          Text("$price ${tr("sar")}",
                              style: TextStyles.hintStyle),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     LinearPercentIndicator(
                      //       backgroundColor: finishPercent == 1
                      //           ? inProgressColor
                      //           : mainColor.withValues(alpha:0.1),
                      //       progressColor: finishPercent == 1
                      //           ? inProgressColor
                      //           : mainColor,
                      //       percent: finishPercent,
                      //       barRadius: Radius.circular(5.r),
                      //       lineHeight: 5.h,
                      //       width: screenWidth / 2,
                      //     ),
                      //     Text("${(finishPercent * 100).toInt()} %",
                      //         style: finishPercent == 1
                      //             ? TextStyles.subTitleStyle
                      //                 .copyWith(color: inProgressColor)
                      //             : TextStyles.subTitleStyle),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
