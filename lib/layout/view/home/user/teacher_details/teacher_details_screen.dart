import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:my_academy/bloc/add_request/add_request_cubit.dart';
import 'package:my_academy/layout/activity/user_screens/main/main_screen.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_teacher_details_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/profissional_booking_bottom_sheet.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/widget/toast/toast.dart';

import '../../../../activity/user_screens/packages/packages_list_screen.dart';
import '../data/cubit/home_cubit.dart';
import '../data/cubit/home_state.dart';

class TeacherDetailsScreen extends StatefulWidget {
  final String teacherId;

  const TeacherDetailsScreen({
    super.key,
    required this.teacherId,
  });

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _bookingButtonController;
  bool _isSelectionMode = false;
  String? _selectedLesson;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bookingButtonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fetchTeacherDetails();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _bookingButtonController.forward();
    });
  }

  void _fetchTeacherDetails() {
    final teacherId = int.tryParse(widget.teacherId);
    if (teacherId != null) {
      context.read<Home2Cubit>().getTeacherDetails(providerId: teacherId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bookingButtonController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: BlocProvider(
        create: (context) => AddRequestCubit(),
        child: BlocBuilder<Home2Cubit, Home2State>(
          builder: (context, state) {
            if (state is GetTeacherDetailsLoadingState) {
              return _buildLoadingScreen();
            } else if (state is GetTeacherDetailsErrorState) {
              return _buildErrorScreen(state.errorMessage);
            } else if (state is GetTeacherDetailsSuccessState) {
              final teacher =
                  context.read<Home2Cubit>().teacherDetailsDataModel?.data;
              if (teacher == null) {
                return _buildErrorScreen('teacher_data_not_available'.tr());
              }
              return _buildSuccessScreen(teacher);
            }
            return _buildLoadingScreen();
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Loading / Error
  // ─────────────────────────────────────────────

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSimpleAppBar(),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSimpleAppBar(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.error_outline,
                            size: 48.w, color: Colors.red.shade400),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'something_went_wrong'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        error,
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 28.h),
                      _filledButton(
                        label: 'retry'.tr(),
                        icon: Icons.refresh,
                        onTap: _fetchTeacherDetails,
                        color: accentColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 0),
      child: Row(
        children: [
          _circleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Success Screen
  // ─────────────────────────────────────────────

  Widget _buildSuccessScreen(TeacherDetailsData teacher) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(teacher),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildStatsRow(teacher)),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildInfoCard(teacher)),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildAboutSection(teacher)),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildLessonsSection(teacher)),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(child: _buildPackagesButton(teacher)),
            SliverToBoxAdapter(child: SizedBox(height: 110.h)),
          ],
        ),
        _buildBookingBar(teacher),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Sliver Hero Header
  // ─────────────────────────────────────────────

  Widget _buildSliverAppBar(TeacherDetailsData teacher) {
    final fullName =
        '${teacher.provider?.firstName ?? ''} ${teacher.provider?.lastName ?? ''}'
            .trim();
    final specialization = teacher.provider?.specializations
            ?.map((s) => s.name ?? '')
            .where((n) => n.isNotEmpty)
            .join(' • ') ??
        '';

    return SliverAppBar(
      expandedHeight: 290.h,
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
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildHeaderBackground(teacher, fullName, specialization),
        title: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 200),
          child: Text(
            fullName.isNotEmpty ? fullName : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
      ),
    );
  }

  Widget _buildHeaderBackground(
      TeacherDetailsData teacher, String fullName, String specialization) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
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
        Positioned(
          bottom: 20,
          left: -30,
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor.withValues(alpha: 0.15),
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              // Avatar with ring
              Hero(
                tag: 'teacher_avatar_${teacher.provider?.id}',
                child: Container(
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
                      child: teacher.provider?.imagePath?.isNotEmpty == true
                          ? CachedNetworkImage(
                              imageUrl: teacher.provider!.imagePath!,
                              width: 100.w,
                              height: 100.w,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => _buildAvatarPlaceholder(),
                              errorWidget: (_, __, ___) =>
                                  _buildDefaultAvatar(),
                            )
                          : _buildDefaultAvatar(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Name
              Text(
                fullName.isNotEmpty ? fullName : 'name_not_available'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              if (teacher.provider?.title?.isNotEmpty == true) ...[
                SizedBox(height: 4.h),
                Text(
                  teacher.provider!.title!,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (specialization.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: mainColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    specialization,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              // Rating row
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: mainColor, size: 16.w),
                  SizedBox(width: 4.w),
                  Text(
                    teacher.provider?.rate?.toStringAsFixed(1) ?? '0.0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '(${teacher.provider?.rateCount ?? 0} ${'ratee'.tr()})',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11.sp,
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

  // ─────────────────────────────────────────────
  // Stats Row
  // ─────────────────────────────────────────────

  Widget _buildStatsRow(TeacherDetailsData teacher) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _statChip(
            icon: Icons.people_alt_rounded,
            value: '${teacher.provider?.rateCount ?? 0}',
            label: 'students'.tr(),
            color: const Color(0xFF4CAF50),
          ),
          SizedBox(width: 10.w),
          _statChip(
            icon: Icons.play_lesson_rounded,
            value: '${teacher.lessons?.length ?? 0}',
            label: 'lessonWW'.tr(),
            color: const Color(0xFF2196F3),
          ),
          SizedBox(width: 10.w),
          _statChip(
            icon: Icons.workspace_premium_rounded,
            value: teacher.provider?.degree?.split(' ').first ?? '–',
            label: 'qualification'.tr(),
            color: mainColor,
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18.w, color: color),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  // ─────────────────────────────────────────────
  // Info Card
  // ─────────────────────────────────────────────

  Widget _buildInfoCard(TeacherDetailsData teacher) {
    final specs = teacher.provider?.specializations
        ?.map((s) => s.name ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    return _sectionCard(
      title: 'teacher_info'.tr(),
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          if (specs != null && specs.isNotEmpty) ...[
            _infoTile(
              icon: Icons.school_rounded,
              label: 'specialization'.tr(),
              value: specs.join(', '),
            ),
            _divider(),
          ],
          if (teacher.provider?.degree != null)
            _infoTile(
              icon: Icons.workspace_premium_rounded,
              label: 'qualification'.tr(),
              value: teacher.provider!.degree!,
            ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.w, color: accentColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500)),
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

  Widget _divider() => Divider(
        height: 20.h,
        thickness: 1,
        color: Colors.grey.shade100,
      );

  // ─────────────────────────────────────────────
  // About Section
  // ─────────────────────────────────────────────

  Widget _buildAboutSection(TeacherDetailsData teacher) {
    final bio = teacher.provider?.bio?.isNotEmpty == true
        ? teacher.provider!.bio!
        : null;

    if (bio == null) return const SizedBox.shrink();

    return _sectionCard(
      title: 'aboutOfTeacher'.tr(),
      icon: Icons.person_outline_rounded,
      child: Text(
        bio,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[700],
          height: 1.7,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Lessons Section
  // ─────────────────────────────────────────────

  Widget _buildLessonsSection(TeacherDetailsData teacher) {
    final lessons = teacher.lessons ?? [];

    return _sectionCard(
      title: lessons.isEmpty ? 'lessons'.tr() : 'available_lessons'.tr(),
      icon: Icons.play_lesson_rounded,
      trailing: lessons.isNotEmpty
          ? _badge('${lessons.length} ${'lessonWW'.tr()}')
          : null,
      child: lessons.isEmpty
          ? _emptyLessons()
          : Column(
              children: [
                ...lessons.take(3).map((l) => _buildLessonCard(l)),
                if (lessons.length > 3) ...[
                  SizedBox(height: 4.h),
                  _viewAllButton(lessons),
                ],
              ],
            ),
    );
  }

  Widget _buildPackagesButton(TeacherDetailsData teacher) {
    final providerId = teacher.provider?.id;
    if (providerId == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () => Get.to(() => PackagesListScreen(providerId: providerId)),
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: mainColor.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.inventory_2_rounded,
                    size: 22.w, color: mainColor),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("monthly_packages"),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      tr("view_packages_desc"),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
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

  Widget _emptyLessons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 48.w, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            'no_lessonsً'.tr(),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _viewAllButton(List<Lesson> lessons) {
    return TextButton(
      onPressed: () => _showAllLessons(lessons),
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${'view_all_lessons'.tr()} (${lessons.length})',
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.arrow_forward_ios_rounded, size: 12.w),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Lesson Card
  // ─────────────────────────────────────────────

  Widget _buildLessonCard(Lesson lesson) {
    final lessonId = lesson.id?.toString() ?? lesson.hashCode.toString();
    final isSelected = _selectedLesson == lessonId;
    final priceText = lesson.hourPrice != null
        ? '${lesson.hourPrice} ${'SAR/hour'.tr()}'
        : 'pppp'.tr();
    final nextTime = _formatLessonTime(lesson.nextTime);
    final isLive = lesson.isLive == true;

    return GestureDetector(
      onTap: _isSelectionMode ? () => _toggleLessonSelection(lesson) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                if (_isSelectionMode) ...[
                  _selectionCircle(isSelected),
                  SizedBox(width: 10.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lesson.subject?.name != null)
                        Text(
                          lesson.subject!.name!,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: primaryText,
                          ),
                        ),
                      if (lesson.content?.isNotEmpty == true) ...[
                        SizedBox(height: 3.h),
                        Text(
                          lesson.content!,
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Live / Recorded badge
                _lessonTypeBadge(isLive),
              ],
            ),
            SizedBox(height: 10.h),
            // Meta row
            Row(
              children: [
                if (lesson.educationalStage?.name != null) ...[
                  Icon(Icons.school_rounded, size: 12.w, color: accentColor),
                  SizedBox(width: 3.w),
                  Text(
                    lesson.educationalStage!.name!,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 10.w),
                ],
                if (nextTime.isNotEmpty) ...[
                  Icon(Icons.schedule_rounded,
                      size: 12.w, color: Colors.orange),
                  SizedBox(width: 3.w),
                  Text(
                    nextTime,
                    style:
                        TextStyle(fontSize: 11.sp, color: Colors.orange[700]),
                  ),
                ],
                const Spacer(),
                Text(
                  priceText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: mainColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            // Time slots
            if (lesson.times != null && lesson.times!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildLessonTimeChip(lesson.times!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _selectionCircle(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? accentColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? accentColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, color: Colors.white, size: 14.w)
          : null,
    );
  }

  Widget _lessonTypeBadge(bool isLive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isLive ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLive ? Colors.red.shade600 : Colors.green.shade600,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            isLive ? 'livee'.tr() : 'registered'.tr(),
            style: TextStyle(
              fontSize: 10.sp,
              color: isLive ? Colors.red.shade600 : Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonTimeChip(List<LessonTime> times) {
    if (times.isEmpty) return const SizedBox.shrink();

    if (times.length == 1) {
      final t = times.first;
      final range = _formatTimeRange(t);
      if (range.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EEF9),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule_rounded, size: 13.w, color: accentColor),
            SizedBox(width: 6.w),
            Text(
              range,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: accentColor,
                  fontWeight: FontWeight.w600),
            ),
            if (_calculateDuration(t.startsAt ?? '', t.endsAt ?? '')
                .isNotEmpty) ...[
              SizedBox(width: 6.w),
              Text(
                '· ${_calculateDuration(t.startsAt ?? '', t.endsAt ?? '')}',
                style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEF9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 13.w, color: accentColor),
          SizedBox(width: 6.w),
          Text(
            '${times.length} ${'sessions'.tr()}',
            style: TextStyle(
                fontSize: 12.sp,
                color: accentColor,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // All Lessons Bottom Sheet
  // ─────────────────────────────────────────────

  void _showAllLessons(List<Lesson> lessons) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAllLessonsSheet(lessons),
    );
  }

  Widget _buildAllLessonsSheet(List<Lesson> lessons) {
    return StatefulBuilder(builder: (context, setModalState) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  Text(
                    'all_lessons'.tr(),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryText),
                  ),
                  const Spacer(),
                  // Selection mode toggle
                  GestureDetector(
                    onTap: () {
                      setModalState(() {});
                      setState(_toggleSelectionMode);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: _isSelectionMode
                            ? accentColor.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isSelectionMode
                                ? Icons.check_circle_rounded
                                : Icons.checklist_rounded,
                            size: 16.w,
                            color: _isSelectionMode
                                ? accentColor
                                : Colors.grey[600],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _isSelectionMode
                                ? 'Selection Mode'.tr()
                                : 'Select Mode'.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: _isSelectionMode
                                  ? accentColor
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _badge('${lessons.length}'),
                ],
              ),
            ),
            // Selection banner
            if (_isSelectionMode && _selectedLesson != null)
              _buildSelectionBanner(
                onClear: () {
                  setState(() => _selectedLesson = null);
                  setModalState(() {});
                },
              ),
            // List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
                itemCount: lessons.length,
                itemBuilder: (_, i) => _buildLessonCard(lessons[i]),
              ),
            ),
            // Confirm button inside sheet
            if (_isSelectionMode && _selectedLesson != null)
              _buildSheetConfirmButton(lessons),
          ],
        ),
      );
    });
  }

  Widget _buildSelectionBanner({required VoidCallback onClear}) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              size: 16.w, color: Colors.green.shade600),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '1 ${'lesson selected'.tr()}',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Text(
              'Clear'.tr(),
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.red.shade500,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetConfirmButton(List<Lesson> lessons) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            final sel = getSelectedLesson(lessons);
            if (sel != null) {
              // Booking logic delegated to parent state
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF065F46),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r)),
            elevation: 0,
          ),
          child: Text('Book Selected Lesson'.tr(),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Booking Bar
  // ─────────────────────────────────────────────

  Widget _buildBookingBar(TeacherDetailsData teacher) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _bookingButtonController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 28.h),
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
              // Select / Book lesson button
              Expanded(
                child: BlocBuilder<AddRequestCubit, AddRequestState>(
                  builder: (context, _) {
                    final hasSelection = _selectedLesson != null;
                    return _filledButton(
                      label: hasSelection
                          ? 'Book Selected Lesson'.tr()
                          : _isSelectionMode
                              ? 'Cancel Selection'.tr()
                              : 'Select Lesson'.tr(),
                      icon: hasSelection
                          ? Icons.check_circle_rounded
                          : Icons.checklist_rounded,
                      color:
                          hasSelection ? const Color(0xFF065F46) : accentColor,
                      onTap: hasSelection
                          ? () => _bookSelectedLesson(teacher, context)
                          : _toggleSelectionMode,
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              // Book new date button
              Expanded(
                child: _filledButton(
                  label: 'bookANewDate'.tr(),
                  icon: Icons.calendar_today_rounded,
                  color: mainColor,
                  onTap: () => _onBookNowPressed(teacher),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookSelectedLesson(TeacherDetailsData teacher, BuildContext ctx) {
    final selectedLessonObj = getSelectedLesson(teacher.lessons ?? []);
    if (selectedLessonObj == null) return;

    final lessonTimes = selectedLessonObj.times
            ?.where((t) => t.id != null)
            .map((t) => t.id!)
            .toList() ??
        [];

    if (lessonTimes.isEmpty) {
      showToast('This lesson has no available time slots'.tr());
      return;
    }

    final cubit = ctx.read<AddRequestCubit>();
    cubit.times
      ..clear()
      ..addAll(lessonTimes);

    cubit.addRequestLesson(
      lessonId: int.parse(_selectedLesson!),
      times: lessonTimes,
      context: ctx,
    );
  }

  // ─────────────────────────────────────────────
  // Booking Handling
  // ─────────────────────────────────────────────

  void _onBookNowPressed(TeacherDetailsData teacher) {
    final lessons = teacher.lessons ?? [];
    if (lessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no_lessonsً'.tr())),
      );
      return;
    }

    // Use the selected lesson if one is picked, otherwise fall back to first
    final selectedObj =
        _selectedLesson != null ? getSelectedLesson(lessons) : null;
    final lesson = selectedObj ?? lessons.first;
    final lessonId = lesson.id;

    if (lessonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('booking_failed'.tr())),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    ProfessionalBookingBottomSheet.show(
      context,
      teacher,
      lessonId,
      (date, timeFrom, timeTo, type) => _handleBookingWithConsumer(
        teacher: teacher,
        lessonId: lessonId,
        date: formatDateToEnglish(date),
        timeFrom: timeFrom,
        timeTo: timeTo,
        type: type,
      ),
    );
  }

  Future<void> _handleBookingWithConsumer({
    required TeacherDetailsData teacher,
    required int lessonId,
    required String date,
    required String timeFrom,
    required String timeTo,
    required String type,
  }) async {
    final prefService = SharedPrefService();
    final clientId = await prefService.getValue('user_id');
    if (!mounted) return;

    final cubit = context.read<Home2Cubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: BlocConsumer<Home2Cubit, Home2State>(
          listener: (ctx, state) {
            if (state is MakeBookSuccessState) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('booking_success'.tr()),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            } else if (state is MakeBookErrorState) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage.isNotEmpty
                      ? state.errorMessage
                      : 'booking_failed'.tr()),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
          builder: (ctx, state) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: accentColor),
                SizedBox(height: 16.h),
                Text('Processing your booking...'.tr(),
                    style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;
    cubit.makeBook(
      clientId: clientId,
      lessonId: lessonId,
      date: date,
      timeFrom: timeFrom,
      timeTo: timeTo,
      type: type,
      teacherId: teacher.provider!.id.toString(),
    );
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
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
              if (trailing != null) ...[
                const Spacer(),
                trailing,
              ],
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 11.sp, color: accentColor, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _filledButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.w),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.all(4.w),
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
        icon: Icon(icon, size: 20.w, color: primaryText),
        onPressed: onTap,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Avatar widgets
  // ─────────────────────────────────────────────

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child:
          Icon(Icons.person_outline_rounded, size: 50.w, color: Colors.white),
    );
  }

  // ─────────────────────────────────────────────
  // Selection helpers
  // ─────────────────────────────────────────────

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) _selectedLesson = null;
    });
  }

  void _toggleLessonSelection(Lesson lesson) {
    final id = lesson.id?.toString() ?? lesson.hashCode.toString();
    setState(() {
      _selectedLesson = _selectedLesson == id ? null : id;
    });
  }

  Lesson? getSelectedLesson(List<Lesson> lessons) {
    if (_selectedLesson == null) return null;
    try {
      return lessons.firstWhere(
        (l) => (l.id?.toString() ?? l.hashCode.toString()) == _selectedLesson,
      );
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // Time formatting helpers
  // ─────────────────────────────────────────────

  String _formatLessonTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '';
    try {
      final dt = DateTime.parse(timeString);
      final diff = dt.difference(DateTime.now());
      if (diff.inDays > 0) {
        return '${'during'.tr()} ${diff.inDays} ${'dayss'.tr()}';
      }
      if (diff.inHours > 0) {
        return '${'during'.tr()} ${diff.inHours} ${'hourss'.tr()}';
      }
      if (diff.inMinutes > 0) {
        return '${'during'.tr()} ${diff.inMinutes} ${'minutess'.tr()}';
      }
      return 'now'.tr();
    } catch (_) {
      return timeString;
    }
  }

  String _formatTimeRange(LessonTime? time) {
    if (time == null || time.startsAt == null || time.endsAt == null) {
      return '';
    }
    final start = _formatProfessionalTime(time.startsAt!);
    final end = _formatProfessionalTime(time.endsAt!);
    return '$start – $end';
  }

  String _formatProfessionalTime(String t) {
    try {
      final dt = DateTime.parse('1970-01-01T$t');
      final h = dt.hour;
      final m = dt.minute.toString().padLeft(2, '0');
      if (h == 0) return '12:$m AM';
      if (h < 12) return '$h:$m AM';
      if (h == 12) return '12:$m PM';
      return '${h - 12}:$m PM';
    } catch (_) {
      return t;
    }
  }

  String _calculateDuration(String startTime, String endTime) {
    try {
      final s = DateTime.parse('1970-01-01T$startTime');
      final e = DateTime.parse('1970-01-01T$endTime');
      final d = e.difference(s);
      final h = d.inHours;
      final m = d.inMinutes % 60;
      if (h > 0 && m > 0) return '${h}h ${m}m';
      if (h > 0) return '${h}h';
      if (m > 0) return '${m}m';
      return '';
    } catch (_) {
      return '';
    }
  }

  String convertArabicToEnglishNumbers(String input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }

  String formatDateToEnglish(String date) {
    final d = DateTime.parse(convertArabicToEnglishNumbers(date));
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

enum LessonType {
  course,
  lesson;

  String get title {
    switch (this) {
      case LessonType.course:
        return 'Course';
      case LessonType.lesson:
        return 'Lesson';
    }
  }
}
