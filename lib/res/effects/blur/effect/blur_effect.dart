import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../value/color/color.dart';
import '../../../value/dimenssion/dimenssions.dart';

class BlurEffect extends StatelessWidget {
  final double? boxHeight;
  final double? boxWidth;
  final double? radius;
  final Color? radiusColor;
  final Widget child;
  const BlurEffect(
      {super.key,
      this.boxHeight,
      this.boxWidth,
      this.radius,
      this.radiusColor,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: boxHeight,
        width: boxWidth ?? screenWidth,
        decoration: BoxDecoration(
          color: black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(radius == null ? 4.r : radius!.r),
          border:
              Border.all(color: radiusColor ?? white.withValues(alpha: 0.5)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: -10.0),
          child: Container(color: black.withValues(alpha: 0.08), child: child),
        ),
      ),
    );
  }
}
