import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;

import '../../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../../res/value/color/color.dart';
import '../../provider_screens/calender/calender_table_screen.dart';
import '../trainer/trainer_screen.dart';

class SubjectScreen extends StatefulWidget {
  final dynamic lessonDetails;
  final bool isUser;

  const SubjectScreen({
    super.key,
    required this.lessonDetails,
    required this.isUser,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.lessonDetails.isBookmarked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lessonDetails;
    final provider = lesson.provider;
    final fullName =
        '${provider?.title ?? ''} ${provider?.firstName ?? ''} ${provider?.lastName ?? ''}'
            .trim();

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(provider, fullName),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              SliverToBoxAdapter(child: _buildQuickStats(lesson)),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              SliverToBoxAdapter(child: _buildSubjectInfo(lesson)),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              if (lesson.content != null && lesson.content!.isNotEmpty)
                SliverToBoxAdapter(child: _buildDescription(lesson)),
              if (lesson.content != null && lesson.content!.isNotEmpty)
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              SliverToBoxAdapter(
                  child: _buildTrainerSection(provider, fullName)),
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
          _buildBottomCTA(lesson),
        ],
      ),
    );
  }

  // ── Hero App Bar ──────────────────────────────

  Widget _buildSliverAppBar(dynamic provider, String fullName) {
    return SliverAppBar(
      expandedHeight: 280.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: accentColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isFavorite ? mainColor : Colors.white,
              size: 22.w,
            ),
            onPressed: () {
              BlocProvider.of<BookmarkCubit>(context).addToBookMark(
                  id: widget.lessonDetails.id!, type: 'lesson');
              setState(() => isFavorite = !isFavorite);
              HapticFeedback.lightImpact();
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildHeaderBackground(provider, fullName),
        title: Text(
          fullName,
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

  Widget _buildHeaderBackground(dynamic provider, String fullName) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3F2571), Color(0xFF5B3E9E)],
            ),
          ),
        ),
        // Decorative circles
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 180.w,
            height: 180.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              // Avatar
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [mainColor, mainColor.withValues(alpha: 0.5)],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor,
                  ),
                  child: ClipOval(
                    child: provider?.image != null &&
                            provider.image.toString().isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: provider.image,
                            width: 90.w,
                            height: 90.w,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                _defaultAvatar(),
                          )
                        : _defaultAvatar(),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                fullName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded,
                      size: 16.w, color: const Color(0xFFEFB10B)),
                  SizedBox(width: 4.w),
                  Text(
                    '${provider?.rate ?? 0}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '(${provider?.rateCount ?? 0} ${tr("ratee")})',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 90.w,
      height: 90.w,
      color: Colors.white24,
      child:
          Icon(Icons.person_outline_rounded, size: 45.w, color: Colors.white),
    );
  }

  // ── Quick Stats ──────────────────────────────

  Widget _buildQuickStats(dynamic lesson) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _statCard(
            Icons.menu_book_rounded,
            lesson.subject?.name ?? '',
            tr("subject"),
            mainColor,
          ),
          SizedBox(width: 10.w),
          _statCard(
            Icons.school_rounded,
            lesson.educationalStage?.name ?? '',
            tr("educational_stage"),
            const Color(0xFF2196F3),
          ),
          SizedBox(width: 10.w),
          _statCard(
            Icons.calendar_today_rounded,
            lesson.educationalYear?.name ?? '',
            tr("year"),
            const Color(0xFF4CAF50),
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
            Icon(icon, size: 20.w, color: color),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(fontSize: 9.sp, color: Colors.grey[500]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Subject Info Card ──────────────────────────

  Widget _buildSubjectInfo(dynamic lesson) {
    return _sectionCard(
      title: tr("subject_details"),
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          _infoRow(Icons.menu_book_rounded, tr("subject"),
              lesson.subject?.name ?? ''),
          _infoRow(Icons.school_rounded, tr("educational_stage"),
              '${lesson.educationalStage?.name ?? ''} - ${lesson.educationalYear?.name ?? ''}'),
          _infoRow(Icons.people_rounded, tr("subscriptions"),
              '${lesson.subscriptions ?? 0}'),
          SizedBox(height: 12.h),
          // Price highlight
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: mainColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.payments_rounded, color: mainColor, size: 22.w),
                SizedBox(width: 10.w),
                Text(
                  tr("per_hour"),
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  '${lesson.hourPrice ?? '0'} ${tr("sar")}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 16.w, color: accentColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[500])),
                SizedBox(height: 2.h),
                Text(value,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: primaryText,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Description ──────────────────────────────

  Widget _buildDescription(dynamic lesson) {
    return _sectionCard(
      title: tr("description"),
      icon: Icons.description_rounded,
      child: Text(
        lesson.content!,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[700],
          height: 1.7,
        ),
      ),
    );
  }

  // ── Trainer Section ──────────────────────────

  Widget _buildTrainerSection(dynamic provider, String fullName) {
    if (provider == null) return const SizedBox.shrink();

    return _sectionCard(
      title: tr("trainer"),
      icon: Icons.person_rounded,
      child: InkWell(
        onTap: () => Get.to(() => TrainerScreen(
              id: provider.id!,
              isUser: widget.isUser,
            )),
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
              CircleAvatar(
                radius: 26.w,
                backgroundColor: accentColor.withValues(alpha: 0.1),
                backgroundImage:
                    provider.image != null && provider.image.toString().isNotEmpty
                        ? CachedNetworkImageProvider(provider.image)
                        : null,
                child:
                    provider.image == null || provider.image.toString().isEmpty
                        ? Icon(Icons.person_rounded,
                            size: 26.w, color: accentColor)
                        : null,
              ),
              SizedBox(width: 14.w),
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
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 14.w, color: const Color(0xFFEFB10B)),
                        SizedBox(width: 3.w),
                        Text(
                          '${provider.rate ?? 0} (${provider.rateCount ?? 0})',
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

  // ── Bottom CTA ──────────────────────────────

  Widget _buildBottomCTA(dynamic lesson) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr("per_hour"),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
                Text(
                  '${lesson.hourPrice ?? '0'} ${tr("sar")}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.to(
                    () => CalenderScreen(lessonDetails: lesson)),
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
                    Flexible(
                      child: Text(
                        tr("available_appointments"),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  // ── Helpers ──────────────────────────────

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
}
