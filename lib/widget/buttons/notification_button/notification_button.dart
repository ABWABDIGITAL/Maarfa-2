import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';

class NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const NotificationButton({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 45.w,
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              count > 0
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_outlined,
              color: count > 0 ? mainColor : const Color(0xFF9E9E9E),
              size: 24.r,
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: count > 9 ? 4.w : 5.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: circleColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
