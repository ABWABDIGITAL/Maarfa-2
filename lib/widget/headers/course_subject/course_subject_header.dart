import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';

/// Pill-style tab switcher — Airbnb/Apple language.
/// Drop-in replacement for the old underline-indicator header.
class CourseSubjectHeader extends StatelessWidget {
  final VoidCallback? courseTap;
  final VoidCallback? subjectTap;
  final bool isSubject;

  const CourseSubjectHeader({
    super.key,
    this.courseTap,
    this.subjectTap,
    required this.isSubject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 12.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E8E8), width: 1),
        ),
      ),
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            _Tab(
              label: tr('course'),
              isSelected: !isSubject,
              onTap: courseTap,
            ),
            _Tab(
              label: tr('subject'),
              isSelected: isSubject,
              onTap: subjectTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _Tab({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Shamel',
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? mainColor : const Color(0xFF707070),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
