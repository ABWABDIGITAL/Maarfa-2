import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/drawable/icon/icons.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/space/space.dart';

class ConsultationCard extends StatelessWidget {
  const ConsultationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: textfieldColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("استشارة قانونية",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.appBarStyle.copyWith(
                      color: blackColor, fontWeight: FontWeight.bold)),
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: smallTextColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: smallTextColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    tr("advice"),
                    style:
                        TextStyles.errorStyle.copyWith(color: smallTextColor),
                  ),
                ),
              ),
            ],
          ),
          Text(
            tr("legal_advice"),
            style: TextStyles.errorStyle.copyWith(color: secColor),
          ),
          Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("#123456",
                  style: TextStyles.errorStyle.copyWith(color: textfieldColor)),
              const Spacer(),
              Image.asset(userSolid, height: 20.h, fit: BoxFit.contain),
              const Space(
                boxWidth: 5,
              ),
              Text(
                "أ/ عادل السيد",
                style: TextStyles.hintStyle.copyWith(
                  color: black,
                  //fontSize: 16,
                ),
              ),
              const Spacer(),
              Image.asset(tableCells, height: 20.h, fit: BoxFit.contain),
              const Space(
                boxWidth: 5,
              ),
              Text(
                "22-2-2020 . 02:00",
                style: TextStyles.contentStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
