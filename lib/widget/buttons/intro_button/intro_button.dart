import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';

class IntroButton extends StatelessWidget {
  final double percent;
  final Color color;
  final VoidCallback? onPressed;
  const IntroButton(
      {super.key, required this.percent, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: CircularPercentIndicator(
        radius: 45.r,
        lineWidth: 2.w,
        percent: percent,
        backgroundColor: color,
        center: Container(
          //  alignment: Alignment.center,
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(
                color: grey.withValues(alpha: 0.1),
              ),
              const BoxShadow(
                color: white,
                spreadRadius: -5.0,
                blurRadius: 5.0,
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Center(
              child: Image.asset(arrow,
                  color: cvColor, width: 60.w, fit: BoxFit.contain),
            ),
          ),
        ),
        progressColor: percent == 1 ? mainColor : white,
      ),
    );
  }
}
