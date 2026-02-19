import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';

class CourseCard extends StatelessWidget {
  final bool isBlue;
  final bool isShowBookmark;
  final VoidCallback? onPress;
  final VoidCallback? favoriteTap;
  final dynamic courseModel;
  final dynamic bookmarkCoursesModel;
  final String? attendType;
  final int? id;

  const CourseCard({
    super.key,
    this.isBlue = false,
    this.isShowBookmark = true,
    this.onPress,
    this.courseModel,
    this.bookmarkCoursesModel,
    this.attendType,
    required this.favoriteTap,
    this.id,
  });

  // Helpers to unify access across both model types
  String get _imageUrl => courseModel != null
      ? (courseModel!.image ?? '')
      : (bookmarkCoursesModel!.image ?? '');

  String get _providerImage => courseModel != null
      ? (courseModel!.provider?.imagePath ?? '')
      : (bookmarkCoursesModel!.provider?.image ?? '');

  String get _providerName {
    final p = courseModel != null
        ? courseModel!.provider
        : bookmarkCoursesModel!.provider;
    if (p == null) return '';
    final parts = [p.title, p.firstName, p.lastName]
        .where((s) => s != null && (s as String).isNotEmpty)
        .join(' ');
    return parts;
  }

  String get _specialization => courseModel != null
      ? (courseModel!.specialization?.name ?? '')
      : (bookmarkCoursesModel!.specialization?.name ?? '');

  String get _rate => courseModel != null
      ? (courseModel!.provider?.rate?.toString() ?? '0')
      : (bookmarkCoursesModel!.provider?.rate?.toString() ?? '0');

  String get _rateCount => courseModel != null
      ? (courseModel!.provider?.rateCount?.toString() ?? '0')
      : (bookmarkCoursesModel!.provider?.rateCount?.toString() ?? '0');

  String get _price => courseModel != null
      ? (courseModel!.price?.toString() ?? '')
      : (bookmarkCoursesModel!.price?.toString() ?? '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cover image ──────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    CachedImage(
                      imageUrl: _imageUrl,
                      width: double.infinity,
                      height: 160.h,
                      fit: BoxFit.cover,
                    ),
                    // Attendance badge
                    if (attendType != null && attendType!.isNotEmpty)
                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xCC1A1A1A),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            attendType!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    // Bookmark
                    if (isShowBookmark)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: GestureDetector(
                          onTap: favoriteTap,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              isBlue ? blueBookmarkIcon : bookmarkIcon,
                              height: 20.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Body ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Specialization pill
                    if (_specialization.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4EB),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          _specialization,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    // Provider row
                    Row(
                      children: [
                        // Avatar
                        ClipOval(
                          child: CachedImage(
                            imageUrl: _providerImage,
                            width: 32.w,
                            height: 32.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _providerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // Rating + price row
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14.sp, color: mainColor),
                        SizedBox(width: 3.w),
                        Text(
                          _rate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '($_rateCount ${tr("rater")})',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        if (_price.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4EB),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '$_price ${tr("sar")}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: mainColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
