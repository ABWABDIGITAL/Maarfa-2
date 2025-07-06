import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../space/space.dart';

class NextPreviousHeader extends StatelessWidget {
  final VoidCallback? nextTap;
  final VoidCallback? previousTap;
  final bool isPrevious;
  const NextPreviousHeader(
      {super.key, this.nextTap, this.previousTap, required this.isPrevious});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      shadowColor: borderColor.withValues(alpha: 0.15),
      child: Container(
        width: screenWidth,
        height: 100.h,
        color: white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: nextTap,
              child: Stack(
                alignment: FractionalOffset.bottomCenter,
                children: [
                  Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: !isPrevious ? mainColor : white,
                                  width: 2.h))),
                      child: Center(
                          child: Text(
                        tr("previous"),
                        style: !isPrevious
                            ? TextStyles.selectedStyle
                            : TextStyles.unselectedStyle,
                      ))),
                  !isPrevious
                      ? Container(
                          height: 15.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const Space(
              boxWidth: 100,
            ),
            InkWell(
              onTap: previousTap,
              child: Stack(
                alignment: FractionalOffset.bottomCenter,
                children: [
                  Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: isPrevious ? mainColor : white,
                                  width: 2.h))),
                      child: Center(
                          child: Text(
                        tr("finished"),
                        style: isPrevious
                            ? TextStyles.selectedStyle
                            : TextStyles.unselectedStyle,
                      ))),
                  isPrevious
                      ? Container(
                          height: 15.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
