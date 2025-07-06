import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../res/value/color/color.dart';

class ProfileButton extends StatelessWidget {
  final String title, image;
  final VoidCallback? onTap;
  const ProfileButton(
      {super.key, required this.title, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      shadowColor: borderColor.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: FractionalOffset.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25.h, right: 5.w, left: 5.w),
              child: Container(
                height: 200.h,
                width: (screenWidth - 80.w) / 2,
                decoration: BoxDecoration(
                    color: profileColor,
                    borderRadius: BorderRadius.circular(5.r)),
              ),
            ),
            Column(
              children: [
                Image.asset(image,
                    height: 130.h, width: 100.w, fit: BoxFit.contain),
                const Space(
                  boxHeight: 30,
                ),
                Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyles.appBarStyle.copyWith(
                        color: mainColor, fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
