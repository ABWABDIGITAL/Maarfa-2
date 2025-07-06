import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/model/common/courses/course_model.dart';
import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';

import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/space/space.dart';

class SubjectAcademinScreen extends StatelessWidget {
  const SubjectAcademinScreen(
      {super.key, required this.data, required this.onTap});
  final CourseModel data;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        width: 80.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r)),
                        child: CachedImage(
                          imageUrl: data.image!,
                          width: screenWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Space(
                        boxHeight: 5,
                      ),
                      Text(data.id.toString(),
                          style: TextStyles.errorStyle
                              .copyWith(color: textfieldColor)),
                    ],
                  ),
                ),
                const Space(
                  boxWidth: 10,
                ),
                SizedBox(
                  width: screenWidth - 190.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.3,
                            child: Text(data.name!,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.appBarStyle.copyWith(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const Spacer(),
                          Container(
                            height: 30.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: inProgressColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: inProgressColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                data.type == 1
                                    ? e.tr("offline")
                                    : e.tr("online"),
                                style: TextStyles.errorStyle
                                    .copyWith(color: inProgressColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        data.specialization!.name!,
                        // e.tr("academic_year"),
                        style: TextStyles.errorStyle.copyWith(color: secColor),
                      ),
                      Row(
                        children: [
                          // Image.asset(userSolid,
                          //     height: 20.h, fit: BoxFit.contain),
                          // const Space(
                          //   boxWidth: 5,
                          // ),
                          Text(
                            "${data.subscriptions} ${e.tr("subscriber")}",
                            style: TextStyles.hintStyle.copyWith(
                                color: mainColor,
                                decoration: TextDecoration.underline
                                //fontSize: 16,
                                ),
                          ),
                          const Spacer(),
                          Image.asset(tableCells,
                              height: 20.h, fit: BoxFit.contain),
                          const Space(
                            boxWidth: 5,
                          ),
                          Text(
                            data.nextTime == ""
                                ? ""
                                : e.DateFormat("d/MM/yy h:m:s", "en")
                                    .format(DateTime.parse(data.nextTime!)),
                            style: TextStyles.contentStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(e.tr("view_subscribers"), style: TextStyles.subTitleStyle),
            //       const Space(
            //         boxWidth: 5,
            //       ),
            //       Image.asset(moreInfo, height: 10.h, fit: BoxFit.contain),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
