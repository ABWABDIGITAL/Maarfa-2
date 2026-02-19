import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../../activity/user_screens/request/course_pay/pay_screen.dart';

class RequestCourseCard extends StatelessWidget {
  final String courseTitle;
  final String? image;
  final int id, courseId;
  final String name;
  final String price;
  final String attendance;
  final String acceptanceCheck;

  const RequestCourseCard({
    super.key,
    required this.courseTitle,
    required this.courseId,
    this.image,
    required this.acceptanceCheck,
    required this.price,
    required this.name,
    required this.id,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final statusCfg = _StatusConfig.fromStatus(acceptanceCheck);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: () => Get.to(() => PayScreen(
              type: 'course',
              id: courseId,
              isRequest: true,
              requestId: id,
            )),
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course thumbnail
              _CourseThumbnail(
                imageUrl: image,
                attendance: attendance,
              ),
              SizedBox(width: 14.w),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Request ID badge
                    Text(
                      '#$id',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Title
                    Text(
                      courseTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Teacher row
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 14.sp, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Price + status row
                    Row(
                      children: [
                        // Price pill
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4EB),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '$price ${tr("sar")}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: mainColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Status pill
                        _Pill(
                          label: acceptanceCheck,
                          bg: statusCfg.bg,
                          fg: statusCfg.fg,
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

// ── Sub-widgets ──────────────────────────────────────────────

class _CourseThumbnail extends StatelessWidget {
  final String? imageUrl;
  final String attendance;

  const _CourseThumbnail({required this.imageUrl, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 72.w,
                  height: 72.h,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _placeholder(),
                  placeholder: (_, __) => _placeholder(),
                )
              : _placeholder(),
        ),
        // Attendance badge at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 22.h,
            decoration: BoxDecoration(
              color: const Color(0xCC1A1A1A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            child: Center(
              child: Text(
                attendance,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72.w,
      height: 72.h,
      color: const Color(0xFFF3F4F6),
      child: Center(
        child: Icon(Icons.library_books_outlined,
            color: Colors.grey[400], size: 28),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _Pill({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _StatusConfig {
  final Color bg;
  final Color fg;

  const _StatusConfig({required this.bg, required this.fg});

  factory _StatusConfig.fromStatus(String status) {
    final s = status.toLowerCase();
    if (s.contains('قبول') || s.contains('accept') || s.contains('موافق')) {
      return const _StatusConfig(bg: Color(0xFFD1FAE5), fg: Color(0xFF065F46));
    } else if (s.contains('رفض') || s.contains('reject')) {
      return const _StatusConfig(bg: Color(0xFFFFE4E6), fg: Color(0xFF9F1239));
    } else if (s.contains('paid') || s.contains('مدفوع')) {
      return const _StatusConfig(bg: Color(0xFFEDE9FE), fg: Color(0xFF5B21B6));
    }
    // default: pending
    return const _StatusConfig(bg: Color(0xFFFFF3CD), fg: Color(0xFF856404));
  }
}
