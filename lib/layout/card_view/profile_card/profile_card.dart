import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key, required this.title, this.subTitle, required this.pressed});
  final String title;
  final String? subTitle;
  final VoidCallback pressed;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // color: profileCardColor,

        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ListTile(
            onTap: pressed,
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              title,
              style: TextStyles.appBarStyle.copyWith(color: blackColor),
            ),
            subtitle: subTitle == null
                ? null
                : Text(
                    subTitle!,
                    style: TextStyles.contentStyle,
                  ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: mainColor,
            )));
  }
}
