import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:my_academy/layout/activity/user_screens/trainer/trainer_screen.dart';
import 'package:my_academy/model/common/courses/course_details/course_details_model.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../../../../bloc/course_subject/course_subject_cubit.dart';
import '../../../../repository/user/courses/courses_repository.dart';
import '../../../../widget/loader/loader.dart';
import '../../../view/connectivity/connectivity_view.dart';
import '../app_appointments/available_appointments_screen.dart';

class CourseRegistration extends StatelessWidget {
  final int id;
  final bool isUser;

  const CourseRegistration({
    super.key,
    required this.id,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CourseSubjectCubit(CoursesRepository())..getCourseById(id),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: ConnectivityView(
          child: BlocBuilder<CourseSubjectCubit, CourseSubjectState>(
            builder: (context, state) {
              if (state is CourseDetailsLoadedState && state.data != null) {
                return _CourseDetailsView(
                  course: state.data!,
                  isUser: isUser,
                );
              }
              if (state is CourseErrorState) {
                return _buildError(context);
              }
              return const Center(child: Loading());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.w, color: Colors.grey[400]),
                  SizedBox(height: 12.h),
                  Text(tr("warning_message"),
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text(tr("back")),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20.w, color: primaryText),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseDetailsView extends StatelessWidget {
  final CourseDetailsModel course;
  final bool isUser;

  const _CourseDetailsView({required this.course, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildQuickStats()),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildDescription()),
            if (course.tags != null && course.tags!.isNotEmpty) ...[
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              SliverToBoxAdapter(child: _buildSkills()),
            ],
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildTrainerSection(context)),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
        if (course.isRequested != true)
          _buildBottomCTA(context),
      ],
    );
  }

  // ── Hero App Bar ──────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context) {
    final categoryLabel = _getCategoryLabel();

    return SliverAppBar(
      expandedHeight: 280.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: accentColor,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Course image or gradient
            if (course.image != null && course.image!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: course.image!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _gradientBackground(),
              )
            else
              _gradientBackground(),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // Content overlay
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + type badges
                    Row(
                      children: [
                        if (categoryLabel != null)
                          _badge(categoryLabel, mainColor),
                        if (categoryLabel != null) SizedBox(width: 8.w),
                        _badge(
                          course.attendanceType == 1
                              ? tr("online")
                              : tr("offline"),
                          course.attendanceType == 1
                              ? Colors.green
                              : Colors.orange,
                        ),
                        if (course.courseSubType != null) ...[
                          SizedBox(width: 8.w),
                          _badge(
                            course.courseSubType == 'foundation'
                                ? tr("foundation")
                                : tr("training"),
                            accentColor,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Course name
                    Text(
                      course.name ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),

                    // Specialization + Rating
                    Row(
                      children: [
                        if (course.specialization?.name != null) ...[
                          Icon(Icons.category_rounded,
                              size: 14.w, color: Colors.white70),
                          SizedBox(width: 4.w),
                          Text(
                            course.specialization!.name!,
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13.sp),
                          ),
                          SizedBox(width: 16.w),
                        ],
                        Icon(Icons.star_rounded,
                            size: 16.w, color: const Color(0xFFEFB10B)),
                        SizedBox(width: 3.w),
                        Text(
                          '${course.rate?.toStringAsFixed(1) ?? '0.0'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' (${course.rateCount ?? 0})',
                          style: TextStyle(
                              color: Colors.white60, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          course.name ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        titlePadding: EdgeInsets.only(left: 56.w, right: 56.w, bottom: 16.h),
      ),
    );
  }

  Widget _gradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3F2571), Color(0xFF5B3E9E)],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Quick Stats ──────────────────────────────────────

  Widget _buildQuickStats() {
    final spotsLeft = (course.maxStudents ?? 0) - (course.subscriptions ?? 0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _statCard(
            Icons.access_time_rounded,
            '${course.numberOfHours ?? 0}',
            tr("hourss"),
            const Color(0xFF2196F3),
          ),
          SizedBox(width: 10.w),
          _statCard(
            Icons.people_rounded,
            '${course.subscriptions ?? 0}/${course.maxStudents ?? 0}',
            tr("students"),
            const Color(0xFF4CAF50),
          ),
          SizedBox(width: 10.w),
          _statCard(
            Icons.event_seat_rounded,
            '$spotsLeft',
            tr("available"),
            spotsLeft > 5 ? const Color(0xFF4CAF50) : Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 22.w, color: color),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Description ──────────────────────────────────────

  Widget _buildDescription() {
    return _sectionCard(
      title: tr("course_detials"),
      icon: Icons.description_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.content ?? tr("no_data"),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
              height: 1.7,
            ),
          ),
          if (course.price.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: mainColor.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_rounded, color: mainColor, size: 20.w),
                  SizedBox(width: 10.w),
                  Text(
                    tr("package_price"),
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Text(
                    '${course.price} ${tr("sar")}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Skills/Tags ──────────────────────────────────────

  Widget _buildSkills() {
    return _sectionCard(
      title: tr("acquired_skills"),
      icon: Icons.auto_awesome_rounded,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: course.tags!.map((tag) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: accentColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              tag.name ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Trainer Section ──────────────────────────────────

  Widget _buildTrainerSection(BuildContext context) {
    final provider = course.provider;
    if (provider == null) return const SizedBox.shrink();

    final fullName =
        '${provider.title ?? ''} ${provider.firstName ?? ''} ${provider.lastName ?? ''}'
            .trim();

    return _sectionCard(
      title: tr("trainer"),
      icon: Icons.person_rounded,
      child: InkWell(
        onTap: () => Get.to(
            () => TrainerScreen(id: provider.id!, isUser: isUser)),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28.w,
                backgroundColor: accentColor.withValues(alpha: 0.1),
                backgroundImage: provider.imagePath != null &&
                        provider.imagePath!.isNotEmpty
                    ? CachedNetworkImageProvider(provider.imagePath!)
                    : null,
                child: provider.imagePath == null ||
                        provider.imagePath!.isEmpty
                    ? Icon(Icons.person_rounded,
                        size: 28.w, color: accentColor)
                    : null,
              ),
              SizedBox(width: 14.w),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    if (provider.bio != null &&
                        provider.bio!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        provider.bio!,
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 14.w, color: const Color(0xFFEFB10B)),
                        SizedBox(width: 3.w),
                        Text(
                          '${provider.rate?.toStringAsFixed(1) ?? '0.0'} (${provider.rateCount ?? 0})',
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.w, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom CTA ──────────────────────────────────────

  Widget _buildBottomCTA(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr("package_price"),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
                Text(
                  '${course.price} ${tr("sar")}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            // Register button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => AvailableAppointments(
                      courseId: course.id,
                      courseDetailsModel: course));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_available_rounded, size: 20.w),
                    SizedBox(width: 8.w),
                    Text(
                      tr("available_appointments"),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.w, color: accentColor),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  String? _getCategoryLabel() {
    switch (course.courseCategory) {
      case 'qudrat':
        return tr("qudrat");
      case 'tahsili':
        return tr("tahsili");
      default:
        return null;
    }
  }
}
