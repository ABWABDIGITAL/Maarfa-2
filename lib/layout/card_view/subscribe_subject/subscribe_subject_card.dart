import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/drawable/icon/icons.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';

import '../../../res/drawable/image/images.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/logo/logo/logo.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';

class SubscribeSubjectCard extends StatelessWidget {
  const SubscribeSubjectCard(
      {super.key,
      this.onTap,
      this.image = "",
      required this.status,
      required this.id,
      required this.title,
      required this.price,
      required this.name});
  final String status;
  final int id;
  final String title;
  final String price;
  final String name;
  final String? image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 15,
      child: Container(
        width: screenWidth,
        height: 120.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5.r),
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
                        children: [
                          SizedBox(
                            height: 75.h,
                            child: Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                  // color: white,
                                  gradient: blueGradient,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: const BoxDecoration(
                                      color: white, shape: BoxShape.circle),
                                  child: const Logo(
                                    logoHeight: 60,
                                    logoWidth: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50.h,
                            right: 5.w,
                            child: Container(
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
                        child: Text(title,
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
                            Text(name, style: TextStyles.hintStyle),
                            const Spacer(),
                            Image.asset(money,
                                height: 15.h, fit: BoxFit.contain),
                            const Space(
                              boxWidth: 5,
                            ),
                            Text("$price ${tr("sar")}",
                                style: TextStyles.hintStyle),
                          ],
                        ),
                      ),
                      const Space(
                        boxWidth: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: onTap,
                            child: Text(tr("subject_details"),
                                style: TextStyles.subTitleStyle),
                          ),
                          const Space(
                            boxWidth: 5,
                          ),
                          Image.asset(moreInfo,
                              height: 10.h, fit: BoxFit.contain),
                        ],
                      ),
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
