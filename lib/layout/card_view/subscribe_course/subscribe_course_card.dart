import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';

class SubscribeCourseCard extends StatelessWidget {
  final double finishPercent;
  final String status;
  final int id;
  final String providerName;
  final String courseTitle;
  final String price;
  final String? image;

  const SubscribeCourseCard({
    super.key,
    required this.finishPercent,
    required this.status,
    required this.id,
    required this.providerName,
    required this.courseTitle,
    required this.price,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Status type pill color
    final Color typeBg = _typeBgColor(status);
    final Color typeFg = _typeFgColor(status);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.r),
              bottomLeft: Radius.circular(14.r),
            ),
            child: SizedBox(
              width: 90.w,
              height: 100.h,
              child: image != null && image!.isNotEmpty
                  ? CachedImage(
                      imageUrl: image!,
                      fit: BoxFit.cover,
                      width: 90.w,
                      height: 100.h,
                    )
                  : Container(
                      color: accentColor.withValues(alpha: 0.08),
                      child: const Center(
                        child: Icon(Icons.school_outlined,
                            color: accentColor, size: 30),
                      ),
                    ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row + ID badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          courseTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727),
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                              color: const Color(0xFFE8E8E8), width: 1),
                        ),
                        child: Text(
                          '#$id',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF707070),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Teacher name
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded,
                          size: 13, color: Color(0xFF9E9E9E)),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          providerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF707070),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Bottom row: status pill + price
                  Row(
                    children: [
                      // Status/type pill
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: typeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: typeFg,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Price
                      Text(
                        '$price ${tr("sar")}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _typeBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return const Color(0xFFFFE4E6);
      case 'online':
        return const Color(0xFFD1FAE5);
      case 'offline':
        return const Color(0xFFFFF3CD);
      default:
        return const Color(0xFFEEF2FF);
    }
  }

  Color _typeFgColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return const Color(0xFF9F1239);
      case 'online':
        return const Color(0xFF065F46);
      case 'offline':
        return const Color(0xFF856404);
      default:
        return const Color(0xFF3F2571);
    }
  }
}
