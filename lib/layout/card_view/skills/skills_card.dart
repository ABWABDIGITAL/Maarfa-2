import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../../../res/value/style/textstyles.dart';
import '../../../widget/side_padding/side_padding.dart';

class SkillsCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const SkillsCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SidePadding(
          sidePadding: 8,
          child: Container(
            height: 35.h,
            decoration: BoxDecoration(
                color: profileIconCardColor.withValues(alpha: 0.5),
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(20.r)),
            child: SidePadding(
              sidePadding: 15,
              child: Text(title, style: TextStyles.subTitleStyle),
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Icon(
            CupertinoIcons.clear_circled_solid,
            size: 20.h,
            color: mainColor,
          ),
        ),
      ],
    );
  }
}
