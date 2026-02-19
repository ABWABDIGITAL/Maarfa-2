import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../activity/user_screens/subject/subject_screen.dart';

class SubjectCard extends StatelessWidget {
  final bool isBlue;
  final dynamic lessonDetails;
  final int? yearId;
  final int? stageId;
  final VoidCallback onTap;
  final bool isUser;

  const SubjectCard({
    super.key,
    required this.isBlue,
    required this.lessonDetails,
    required this.onTap,
    required this.isUser,
    this.yearId,
    this.stageId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookmarkCubit(),
      child: BlocConsumer<BookmarkCubit, BookmarkState>(
        listener: (_, __) {},
        builder: (_, __) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: InkWell(
              onTap: () => Get.to(() =>
                  SubjectScreen(lessonDetails: lessonDetails, isUser: isUser)),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    _TeacherAvatar(imageUrl: lessonDetails.provider?.image),
                    SizedBox(width: 14.w),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Teacher name
                          Text(
                            lessonDetails.provider?.firstName ?? '',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // Lesson content preview
                          Text(
                            lessonDetails.content ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Bottom row: rating + price
                          Row(
                            children: [
                              // Star rating
                              Icon(Icons.star_rounded,
                                  size: 14.sp, color: mainColor),
                              SizedBox(width: 3.w),
                              Text(
                                lessonDetails.provider?.rate?.toString() ?? '0',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(${lessonDetails.provider?.rateCount ?? 0} ${tr("rater")})',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const Spacer(),
                              // Price pill
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4EB),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '${lessonDetails.hourPrice} ${tr("sar")}/${tr("hour")}',
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
                    SizedBox(width: 8.w),
                    // Bookmark icon
                    GestureDetector(
                      onTap: onTap,
                      child: Image.asset(
                        isBlue ? blueBookmarkIcon : bookmarkIcon,
                        height: 28.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TeacherAvatar extends StatelessWidget {
  final String? imageUrl;

  const _TeacherAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const bgColors = [
      Color(0xFFE8F4FD),
      Color(0xFFFFF3E0),
      Color(0xFFF3E8FD),
      Color(0xFFE8FDF4),
      Color(0xFFFDE8E8),
    ];
    const fgColors = [
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF6A1B9A),
      Color(0xFF1B5E20),
      Color(0xFFB71C1C),
    ];

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: 56.w,
          height: 56.h,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _fallback(bgColors, fgColors),
          placeholder: (_, __) => _fallback(bgColors, fgColors),
        ),
      );
    }
    return _fallback(bgColors, fgColors);
  }

  Widget _fallback(List<Color> bgColors, List<Color> fgColors) {
    final code = imageUrl?.isNotEmpty == true ? imageUrl!.codeUnitAt(0) : 0;
    final idx = code % bgColors.length;
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: bgColors[idx],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(Icons.person, color: fgColors[idx], size: 28),
      ),
    );
  }
}
