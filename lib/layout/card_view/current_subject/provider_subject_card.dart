import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/drawable/image/images.dart';
import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';

import '../../../model/common/courses/course_model.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/space/space.dart';

class SubjectCardScreen extends StatelessWidget {
  const SubjectCardScreen({super.key, required this.data, required this.onTap});
  final CourseModel data;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: textfieldColor,
        ),
      ),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r)),
                        child: CachedImage(
                          imageUrl: data.image!,
                          width: 80.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                        )),
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
                              data.type == 1 ? tr("offline") : tr("live"),
                              style: TextStyles.errorStyle
                                  .copyWith(color: inProgressColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data.specialization!.name!,
                      // tr("the_specialty"),
                      style: TextStyles.errorStyle.copyWith(color: secColor),
                    ),
                    Text(
                      data.nextTime == ""
                          ? ""
                          : DateFormat("yyyy-MM-dd HH:mm")
                              .format(DateTime.parse(data.nextTime!)),
                      style: TextStyles.contentStyle,
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Row(
                        children: [
                          Text(tr("view_requests"),
                              style: TextStyles.subTitleStyle),
                          const Space(
                            boxWidth: 5,
                          ),
                          Image.asset(moreInfo,
                              height: 10.h, fit: BoxFit.contain),
                          const Spacer(),
                          Container(
                            height: 30.h,
                            width: 30.w,
                            decoration: const BoxDecoration(
                                color: circleColor, shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                data.requestsCount!.toString(),
                                style: TextStyles.subTitleStyle
                                    .copyWith(color: white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
