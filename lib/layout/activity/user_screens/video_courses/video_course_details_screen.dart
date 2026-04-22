import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/video_course/video_course_cubit.dart';
import '../../../../model/common/video_courses/video_course_model.dart';
import '../../../../model/common/video_courses/video_unit_model.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import 'video_player_screen.dart';

class VideoCourseDetailsScreen extends StatelessWidget {
  final int courseId;

  const VideoCourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VideoCourseCubit()..getVideoCourseDetails(courseId),
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
        body: BlocConsumer<VideoCourseCubit, VideoCourseState>(
          listener: (context, state) {
            if (state is VideoCoursePurchaseSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr('success_pay')),
                  backgroundColor: inProgressColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VideoCourseLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: mainColor),
              );
            }
            if (state is VideoCourseDetailsLoadedState) {
              return _buildDetails(context, state.course);
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

  Widget _buildDetails(BuildContext context, VideoCourseModel course) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course image header
          CachedImage(
            imageUrl: course.image ?? '',
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  course.title ?? '',
                  style: TextStyle(
                    fontFamily: 'Shamel',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 8.h),

                // Description
                if (course.description != null &&
                    course.description!.isNotEmpty)
                  Text(
                    course.description!,
                    style: TextStyle(
                      fontFamily: 'Shamel',
                      fontSize: 13.sp,
                      color: darkGrey,
                      height: 1.6,
                    ),
                  ),
                SizedBox(height: 12.h),

                // Provider info
                if (course.provider != null) _buildProviderRow(course),
                SizedBox(height: 12.h),

                // Rating row
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16.sp, color: mainColor),
                    SizedBox(width: 4.w),
                    Text(
                      '${course.rate ?? 0}',
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '(${course.rateCount ?? 0} ${tr("rater")})',
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // No download notice
                Row(
                  children: [
                    Icon(Icons.cloud_off_outlined,
                        size: 14.sp, color: darkGrey),
                    SizedBox(width: 4.w),
                    Text(
                      tr('no_download'),
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 11.sp,
                        color: darkGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Purchase full course button
                if (course.totalPrice != null && course.totalPrice! > 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<VideoCourseCubit>()
                            .purchaseCourse(course.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        '${tr("purchase_full_course")} - ${course.totalPrice} ${tr("sar")}',
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),

                // Units section header
                Text(
                  tr('video_units'),
                  style: TextStyle(
                    fontFamily: 'Shamel',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 12.h),

                // Units list
                if (course.units != null && course.units!.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: course.units!.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final unit = course.units![index];
                      return _buildUnitCard(context, unit, course.id!);
                    },
                  )
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Text(
                        tr('no_course'),
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 13.sp,
                          color: grey,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderRow(VideoCourseModel course) {
    final provider = course.provider!;
    final name =
        '${provider.title ?? ''} ${provider.firstName ?? ''} ${provider.lastName ?? ''}'
            .trim();
    return Row(
      children: [
        ClipOval(
          child: CachedImage(
            imageUrl: provider.imagePath ?? '',
            width: 36.w,
            height: 36.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Shamel',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitCard(
      BuildContext context, VideoUnitModel unit, int courseId) {
    final isFree = unit.isFree == true;
    final isPurchased = unit.isPurchased == true;
    final canPlay = isFree || isPurchased;

    // Format duration
    String durationText = '';
    if (unit.duration != null) {
      final minutes = unit.duration! ~/ 60;
      final seconds = unit.duration! % 60;
      durationText = '$minutes:${seconds.toString().padLeft(2, '0')}';
    }

    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Play / Lock icon
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: canPlay
                    ? mainColor.withValues(alpha: 0.1)
                    : grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                canPlay ? Icons.play_circle_fill : Icons.lock_outline,
                color: canPlay ? mainColor : grey,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Unit info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Shamel',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (durationText.isNotEmpty) ...[
                        Icon(Icons.access_time,
                            size: 12.sp, color: darkGrey),
                        SizedBox(width: 3.w),
                        Text(
                          durationText,
                          style: TextStyle(
                            fontFamily: 'Shamel',
                            fontSize: 11.sp,
                            color: darkGrey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      if (isFree)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: inProgressColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            tr('free'),
                            style: TextStyle(
                              fontFamily: 'Shamel',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: inProgressColor,
                            ),
                          ),
                        )
                      else if (isPurchased)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            tr('purchased'),
                            style: TextStyle(
                              fontFamily: 'Shamel',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        )
                      else if (unit.price != null)
                        Text(
                          '${unit.price} ${tr("sar")}',
                          style: TextStyle(
                            fontFamily: 'Shamel',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: mainColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Action button
            if (canPlay)
              InkWell(
                onTap: () {
                  _playUnit(context, unit);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    tr('watch_video'),
                    style: TextStyle(
                      fontFamily: 'Shamel',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
              )
            else
              InkWell(
                onTap: () {
                  context
                      .read<VideoCourseCubit>()
                      .purchaseUnit(unit.id!, courseId);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    tr('purchase_unit'),
                    style: TextStyle(
                      fontFamily: 'Shamel',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _playUnit(BuildContext context, VideoUnitModel unit) {
    if (unit.youtubeUrl != null && unit.youtubeUrl!.isNotEmpty) {
      Get.to(() => VideoPlayerScreen(
            youtubeUrl: unit.youtubeUrl!,
            title: unit.title ?? '',
          ));
    }
  }
}
