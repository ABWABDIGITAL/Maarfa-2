import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 140.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              height: 35.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: mainColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  tr("every_saturday"),
                  style: TextStyles.subTitleStyle.copyWith(color: mainColor),
                ),
              )),
          Positioned(
            top: 8.h,
            left: 18.w,
            child: CircleAvatar(
              radius: 10.r,
              child: Icon(
                Icons.close,
                size: 15.h,
                color: white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
