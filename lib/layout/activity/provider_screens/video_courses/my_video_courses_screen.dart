import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/video_course/provider_video_course_cubit.dart';
import '../../../../model/common/video_courses/video_course_model.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import 'add_unit_screen.dart';
import 'create_video_course_screen.dart';

class MyVideoCoursesScreen extends StatelessWidget {
  const MyVideoCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProviderVideoCourseCubit()..getMyVideoCourses(),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            tr('my_video_courses'),
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
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: FloatingActionButton(
            backgroundColor: mainColor,
            onPressed: () async {
              final result =
                  await Get.to(() => const CreateVideoCourseScreen());
              if (result == true && context.mounted) {
                context
                    .read<ProviderVideoCourseCubit>()
                    .getMyVideoCourses();
              }
            },
            child: const Icon(Icons.add, color: white),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.startFloat,
        body: BlocConsumer<ProviderVideoCourseCubit,
            ProviderVideoCourseState>(
          listener: (context, state) {
            if (state is ProviderVideoCourseDeletedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr('delete')),
                  backgroundColor: inProgressColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProviderVideoCourseLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: mainColor),
              );
            }
            if (state is ProviderVideoCoursesLoadedState) {
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
                  return _ProviderVideoCourseCard(
                    course: state.courses[index],
                  );
                },
              );
            }
            if (state is ProviderVideoCourseErrorState) {
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
                          .read<ProviderVideoCourseCubit>()
                          .getMyVideoCourses(),
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

class _ProviderVideoCourseCard extends StatelessWidget {
  final VideoCourseModel course;

  const _ProviderVideoCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor),
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
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: CachedImage(
                imageUrl: course.image ?? '',
                width: double.infinity,
                height: 140.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
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
                  // Price + units count
                  Row(
                    children: [
                      if (course.totalPrice != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4EB),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '${course.totalPrice} ${tr("sar")}',
                            style: TextStyle(
                              fontFamily: 'Shamel',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: mainColor,
                            ),
                          ),
                        ),
                      SizedBox(width: 8.w),
                      Icon(Icons.video_library_outlined,
                          size: 13.sp, color: accentColor),
                      SizedBox(width: 3.w),
                      Text(
                        '${course.units?.length ?? 0} ${tr("video_units")}',
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 11.sp,
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Action buttons
                  Row(
                    children: [
                      // Add unit
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final result = await Get.to(() =>
                                AddUnitScreen(courseId: course.id!));
                            if (result == true && context.mounted) {
                              context
                                  .read<ProviderVideoCourseCubit>()
                                  .getMyVideoCourses();
                            }
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                tr('add_unit'),
                                style: TextStyle(
                                  fontFamily: 'Shamel',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Delete
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(tr('warning')),
                              content: Text(tr('delete_warning')),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(),
                                  child: Text(tr('cancel')),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    context
                                        .read<ProviderVideoCourseCubit>()
                                        .deleteVideoCourse(course.id!);
                                  },
                                  child: Text(
                                    tr('delete'),
                                    style: const TextStyle(color: red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.delete_outline,
                              color: red, size: 20.sp),
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
    );
  }
}
