import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/value/color/color.dart';
import '../../res/value/dimenssion/dimenssions.dart';
import '../../res/value/style/textstyles.dart';
import '../side_padding/side_padding.dart';

class CourseCategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CourseCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        border: Border.all(color: textfieldColor),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: SidePadding(
        sidePadding: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text(
              tr("course_category"),
              style: TextStyles.appBarStyle.copyWith(color: mainColor),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Radio<String>(
                  value: 'regular',
                  groupValue: selectedCategory,
                  onChanged: (v) => onCategoryChanged(v!),
                ),
                Text(
                  tr("regular"),
                  style: selectedCategory == 'regular'
                      ? TextStyles.textView14SemiBold
                          .copyWith(color: sufixtextColor)
                      : TextStyles.hintStyle,
                ),
                Radio<String>(
                  value: 'qudrat',
                  groupValue: selectedCategory,
                  onChanged: (v) => onCategoryChanged(v!),
                ),
                Text(
                  tr("qudrat"),
                  style: selectedCategory == 'qudrat'
                      ? TextStyles.textView14SemiBold
                          .copyWith(color: sufixtextColor)
                      : TextStyles.hintStyle,
                ),
                Radio<String>(
                  value: 'tahsili',
                  groupValue: selectedCategory,
                  onChanged: (v) => onCategoryChanged(v!),
                ),
                Text(
                  tr("tahsili"),
                  style: selectedCategory == 'tahsili'
                      ? TextStyles.textView14SemiBold
                          .copyWith(color: sufixtextColor)
                      : TextStyles.hintStyle,
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

class CourseSubTypeSelector extends StatelessWidget {
  final String? selectedSubType;
  final ValueChanged<String> onSubTypeChanged;

  const CourseSubTypeSelector({
    super.key,
    required this.selectedSubType,
    required this.onSubTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: 65.h,
      decoration: BoxDecoration(
        border: Border.all(color: textfieldColor),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: SidePadding(
        sidePadding: 10,
        child: Row(
          children: [
            Text(
              tr("course_sub_type"),
              style: TextStyles.appBarStyle.copyWith(color: mainColor),
            ),
            Radio<String>(
              value: 'foundation',
              groupValue: selectedSubType,
              onChanged: (v) => onSubTypeChanged(v!),
            ),
            Text(
              tr("foundation"),
              style: selectedSubType == 'foundation'
                  ? TextStyles.textView14SemiBold
                      .copyWith(color: sufixtextColor)
                  : TextStyles.hintStyle,
            ),
            Radio<String>(
              value: 'training',
              groupValue: selectedSubType,
              onChanged: (v) => onSubTypeChanged(v!),
            ),
            Text(
              tr("training"),
              style: selectedSubType == 'training'
                  ? TextStyles.textView14SemiBold
                      .copyWith(color: sufixtextColor)
                  : TextStyles.hintStyle,
            ),
          ],
        ),
      ),
    );
  }
}
