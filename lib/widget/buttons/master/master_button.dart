import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../side_padding/side_padding.dart';

class MasterButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? buttonRadius;
  final double? sidePadding;
  final double? iconSize;
  final String? icon;
  final String buttonText;
  final TextStyle? buttonStyle;
  final VoidCallback? onPressed;
  const MasterButton(
      {super.key,
      required this.buttonText,
      this.buttonColor,
      this.borderColor,
      this.buttonHeight,
      this.buttonRadius,
      this.buttonWidth,
      this.buttonStyle,
      this.onPressed,
      this.sidePadding,
      this.icon,
      this.iconColor,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: sidePadding ?? 0,
      child: SizedBox(
        height: buttonHeight == null ? 70.h : buttonHeight!.h,
        child: TextButton(
          
          onPressed: onPressed,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          style: ElevatedButton.styleFrom(
            
            foregroundColor: white, backgroundColor: buttonColor ?? mainColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? mainColor),
              borderRadius: BorderRadius.all(Radius.circular(
                  buttonRadius == null ? 5.r : buttonRadius!.r)),
            ),
          ),
          child: SizedBox(
            height: buttonHeight == null ? 70.h : buttonHeight!.h,
            width: buttonWidth == null ? screenWidth : buttonWidth!.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: buttonStyle ??
                      TextStyles.appBarStyle.copyWith(color: white),
                ),
                icon != null
                    ? Image.asset(
                        icon!,
                        height: iconSize,
                        color: iconColor,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
