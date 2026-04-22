import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isAdd;
  final String? type;

  const FilterButton({
    super.key,
    this.isAdd = false,
    this.onTap,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      maintainBottomViewPadding: true,
      minimum: EdgeInsets.only(bottom: 50.h),
      child: FloatingActionButton(
        onPressed: onTap,
        elevation: 0.0,
        backgroundColor: transparent,
        child: Container(
          height: 55.h,
          width: 55.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // gradient: filterGradient,
            color: primaryText,
          ),
          child: isAdd
              ? Icon(Icons.add, color: white, size: 30.h)
              : SizedBox(
                  height: 10.h,
                  child: Icon(
                    Icons.filter_alt_rounded,
                    color: white,
                    // fit: BoxFit.cover,
                    size: 40.h,
                  ),
                ),
        ),
      ),
    );
  }
}
