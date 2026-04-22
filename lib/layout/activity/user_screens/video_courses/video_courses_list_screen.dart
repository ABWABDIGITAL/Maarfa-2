import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/video_course/video_course_cubit.dart';
import '../../../../model/common/video_courses/video_course_model.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import 'video_course_details_screen.dart';

class VideoCoursesListScreen extends StatelessWidget {
  const VideoCoursesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoCourseCubit()..getVideoCourses(),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            tr('video_courses'),
            style: TextStyle(
              fontFamily: 'Shamel',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: headerColor,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: headerColor),
            onPressed: () => Get.back(),
          ),
        ),
        body: BlocBuilder<VideoCourseCubit, VideoCourseState>(
          builder: (context, state) {
            if (state is VideoCourseLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: mainColor),
              );
            }
            if (state is VideoCoursesLoadedState) {
              if (state.courses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library_outlined,
                          size: 64.sp, color: grey),
                      SizedBox(height: 16.h),
                      Text(
                        tr('no_course'),
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 14.sp,
                          color: grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 12.h),
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  return _VideoCourseCard(course: state.courses[index]);
                },
              );
            }
            if (state is VideoCourseErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.sp, color: red),
                    SizedBox(height: 12.h),
                    Text(
                      tr('something_went_wrong'),
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 14.sp,
                        color: grey,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () => context
                          .read<VideoCourseCubit>()
                          .getVideoCourses(),
                      child: Text(
                        tr('retry'),
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 14.sp,
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _VideoCourseCard extends StatelessWidget {
  final VideoCourseModel course;

  const _VideoCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => Get.to(() => VideoCourseDetailsScreen(courseId: course.id!)),
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
              // Cover image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: CachedImage(
                  imageUrl: course.image ?? '',
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                ),
              ),
              // Body
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      course.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Provider row
                    if (course.provider != null)
                      Row(
                        children: [
                          ClipOval(
                            child: CachedImage(
                              imageUrl: course.provider?.imagePath ?? '',
                              width: 28.w,
                              height: 28.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '${course.provider?.title ?? ''} ${course.provider?.firstName ?? ''} ${course.provider?.lastName ?? ''}'
                                  .trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Shamel',
                                fontSize: 12.sp,
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
                        Icon(Icons.star_rounded,
                            size: 14.sp, color: mainColor),
                        SizedBox(width: 3.w),
                        Text(
                          (course.rate ?? 0).toString(),
                          style: TextStyle(
                            fontFamily: 'Shamel',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${course.rateCount ?? 0} ${tr("rater")})',
                          style: TextStyle(
                            fontFamily: 'Shamel',
                            fontSize: 11.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        if (course.totalPrice != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4EB),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '${course.totalPrice} ${tr("sar")}',
                              style: TextStyle(
                                fontFamily: 'Shamel',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: mainColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Units count
                    if (course.units != null)
                      Row(
                        children: [
                          Icon(Icons.video_library_outlined,
                              size: 14.sp, color: accentColor),
                          SizedBox(width: 4.w),
                          Text(
                            '${course.units!.length} ${tr("video_units")}',
                            style: TextStyle(
                              fontFamily: 'Shamel',
                              fontSize: 11.sp,
                              color: accentColor,
                              fontWeight: FontWeight.w600,
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
