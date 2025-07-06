import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';

class CourseTypeCard extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CourseTypeCard({
    super.key,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 4,
      child: Container(
        height: 35.h,
        decoration: BoxDecoration(
          color:
              isSelected ? mainColor.withValues(alpha: 0.1) : courseTypeColor,
          border: Border.all(color: isSelected ? mainColor : textfieldColor),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: SidePadding(
            sidePadding: 20,
            child: Text(title,
                style: isSelected
                    ? TextStyles.errorStyle.copyWith(color: mainColor)
                    : TextStyles.errorStyle.copyWith(color: grey)),
          ),
        ),
      ),
    );
  }
}
