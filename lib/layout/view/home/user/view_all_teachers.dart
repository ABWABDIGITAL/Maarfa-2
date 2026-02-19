import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_all_teachers_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/teacher_details_screen.dart';
import 'package:my_academy/layout/view/home/user/view_all_specialization_screen.dart';

import 'package:my_academy/res/value/color/color.dart';

import 'data/cubit/home_cubit.dart';
import 'data/cubit/home_state.dart';

class ViewAllTeachers extends StatefulWidget {
  const ViewAllTeachers({
    super.key,
    required this.selectedSpecializationId,
    required this.specializationName,
  });

  final int selectedSpecializationId;
  final String specializationName;

  @override
  State<ViewAllTeachers> createState() => _ViewAllTeachersState();
}

class _ViewAllTeachersState extends State<ViewAllTeachers>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late Home2Cubit _homeCubit;
  late AnimationController _fabAnimationController;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _homeCubit = context.read<Home2Cubit>();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _homeCubit.getAllTeachers(specialityId: widget.selectedSpecializationId);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Show/hide scroll to top button
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
      _fabAnimationController.forward();
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
      _fabAnimationController.reverse();
    }

    // Load more teachers
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _homeCubit.loadMoreTeachers(
          specialityId: widget.selectedSpecializationId);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocBuilder<Home2Cubit, Home2State>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildBody(state),
              if (_showScrollToTop) _buildScrollToTopButton(),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.grey[700], size: 20.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Column(
        children: [
          Text(
            widget.specializationName,
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          BlocBuilder<Home2Cubit, Home2State>(
            builder: (context, state) {
              final teacherCount = _homeCubit.allTeachers.length;
              return Text(
                teacherCount > 0
                    ? '$teacherCount ${'available_teacher'.tr()}'
                    : '',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ],
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Container(
          height: 1.h,
          color: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildBody(Home2State state) {
    if (state is GetAllTeachersLoadingState) {
      return _buildLoadingState();
    }

    if (state is GetAllTeachersErrorState) {
      return _buildErrorState(state);
    }

    final teachers = _homeCubit.allTeachers;

    if (teachers.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => _homeCubit.getAllTeachers(
          specialityId: widget.selectedSpecializationId),
      color: mainColor,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == teachers.length) {
                    return _buildLoadMoreIndicator();
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: TeacherCard(
                      teacher: teachers[index],
                      onTap: () => _onTeacherTap(teachers[index]),
                    ),
                  );
                },
                childCount: teachers.length + 1,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
          ),
          SizedBox(height: 16.h),
          Text(
            'loading_teachers'.tr(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(GetAllTeachersErrorState state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40.w,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'something_went_wrong_in_data'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              state.errorMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => _homeCubit.getAllTeachers(
                  specialityId: widget.selectedSpecializationId),
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_search_rounded,
                size: 40.w,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'no_teachers_found'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'no_teacher_in_specialization'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return BlocBuilder<Home2Cubit, Home2State>(
      builder: (context, state) {
        if (state is GetAllTeachersLoadingMoreState) {
          return Container(
            padding: EdgeInsets.all(20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'load_more'.tr(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildScrollToTopButton() {
    return Positioned(
      bottom: 24.h,
      right: 24.w,
      child: ScaleTransition(
        scale: _fabAnimationController,
        child: FloatingActionButton.small(
          onPressed: _scrollToTop,
          backgroundColor: mainColor,
          child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
        ),
      ),
    );
  }

  void _onTeacherTap(Providers teacher) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TeacherDetailsScreen(teacherId: teacher.id!.toString()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

// Enhanced TeacherCard
class TeacherCard extends StatelessWidget {
  final Providers teacher;
  final VoidCallback? onTap;

  const TeacherCard({
    super.key,
    required this.teacher,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildTeacherAvatar(),
                SizedBox(width: 16.w),
                Expanded(child: _buildTeacherInfo()),
                SizedBox(width: 12.w),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: teacher.imagePath != null && teacher.imagePath!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: teacher.imagePath!,
              width: 64.w,
              height: 64.h,
              fit: BoxFit.cover,
              placeholder: (_, __) => _buildAvatarPlaceholder(),
              errorWidget: (_, __, ___) => _buildDefaultAvatar(),
            )
          : _buildDefaultAvatar(),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 64.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    final fullName =
        '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
    const bgColors = [
      Color(0xFFE8F4FD),
      Color(0xFFFFF3E0),
      Color(0xFFE8F5E9),
      Color(0xFFFCE4EC),
      Color(0xFFEDE7F6),
    ];
    const fgColors = [
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFF4527A0),
    ];
    final idx = initial.codeUnitAt(0) % bgColors.length;

    return Container(
      width: 64.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: bgColors[idx],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: fgColors[idx],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherInfo() {
    final fullName =
        '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName.isNotEmpty ? fullName : 'name_not_available'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (teacher.title != null && teacher.title!.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            teacher.title!,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: 8.h),
        Row(
          children: [
            if (teacher.rate != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.w,
                      color: Colors.amber[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      teacher.rate!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
            ],
            if (teacher.rateCount != null && teacher.rateCount! > 0) ...[
              Text(
                '(${teacher.rateCount} ${'reviews'.tr()})',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16.w,
        color: Colors.grey[600],
      ),
    );
  }
}
