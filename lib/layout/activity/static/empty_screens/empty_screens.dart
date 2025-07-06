import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../../res/value/color/color.dart';

class EmptyScreen extends StatelessWidget {
  final String title, image;
  final double width, height;
  final Color? color;

  const EmptyScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.width,
      required this.height,
      this.color});

  // @override
  // Widget build(BuildContext context) {
  //   return SidePadding(
  //     sidePadding: 40,
  //     child: SizedBox(
  //       height: height,
  //       width: width,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Image.asset(image,
  //               height: height / 2,
  //               fit: BoxFit.contain,
  //               color: color ?? mainColor.withValues(alpha:0.1)),
  //           Space(
  //             boxHeight: 30.h,
  //           ),
  //           Text(
  //             tr(title),
  //             style: TextStyles.titleStyle.copyWith(color: color ?? blackColor),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 10,
      child: Container(
        height: height,
        // width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withValues(alpha:0.03),
          //     blurRadius: 6,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: height / 2,
                  fit: BoxFit.contain,
                  color: color ?? grey.withValues(alpha: 0.1),
                ),
              ),
              Space(boxHeight: 30.h),
              Text(
                tr(title),
                style: TextStyles.titleStyle.copyWith(color: color ?? grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
