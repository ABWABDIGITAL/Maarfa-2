import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_state.dart';
import 'package:my_academy/layout/view/home/user/view_all_teachers.dart';
import 'package:my_academy/res/value/color/color.dart';

import 'data/cubit/home_cubit.dart';
import 'data/models/get_all_specializations_data_model.dart';

class ViewAllSpecializationScreen extends StatefulWidget {
  const ViewAllSpecializationScreen({super.key});

  @override
  State<ViewAllSpecializationScreen> createState() =>
      _ViewAllSpecializationScreenState();
}

class _ViewAllSpecializationScreenState
    extends State<ViewAllSpecializationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<Home2Cubit>().getAllSpecializations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'specializations'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE8E8E8), height: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<Home2Cubit, Home2State>(
        builder: (context, state) {
          if (state is GetAllSpecializationsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: mainColor),
            );
          } else if (state is GetAllSpecializationsErrorState) {
            return _buildErrorState(state.errorMessage);
          } else if (state is GetAllSpecializationsSuccessState) {
            return _buildSpecializationsGrid(
                context.read<Home2Cubit>().allSpecializations);
          }
          return const Center(
            child: CircularProgressIndicator(color: mainColor),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE4E6),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline,
                  size: 40.w, color: const Color(0xFF9F1239)),
            ),
            SizedBox(height: 20.h),
            Text(
              'oops_something_went_wrong'.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: const Color(0xFF1A1A1A)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () =>
                  context.read<Home2Cubit>().getAllSpecializations(),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('try_again'.tr(),
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationsGrid(List<SpecializationData> specializations) {
    return RefreshIndicator(
      onRefresh: () async => context.read<Home2Cubit>().getAllSpecializations(),
      color: mainColor,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'choose_specialization'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Text(
                      'find_best_teachers_in_field'.tr(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.88,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _SpecializationCard(specializations[index], index),
                childCount: specializations.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        ],
      ),
    );
  }
}

// ── Specialization Card ──────────────────────────────────────

class _SpecializationCard extends StatelessWidget {
  final SpecializationData specialization;
  final int index;

  const _SpecializationCard(this.specialization, this.index);

  // Palette of flat bg/icon color pairs — no gradients
  static const _palettes = [
    (bg: Color(0xFFFFF4EB), icon: Color(0xFFF19704)), // amber
    (bg: Color(0xFFEDE9FE), icon: Color(0xFF5B21B6)), // purple
    (bg: Color(0xFFD1FAE5), icon: Color(0xFF065F46)), // green
    (bg: Color(0xFFFFE4E6), icon: Color(0xFF9F1239)), // rose
    (bg: Color(0xFFE0F2FE), icon: Color(0xFF0369A1)), // sky
    (bg: Color(0xFFF3F4F6), icon: Color(0xFF374151)), // slate
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _palettes[index % _palettes.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => ViewAllTeachers(
                selectedSpecializationId: specialization.id!,
                specializationName: specialization.name ?? 'Teachers',
              ),
              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                )),
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 280),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE8E8E8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Image / icon area
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: palette.bg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: specialization.image != null &&
                            specialization.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: specialization.image!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                _placeholder(palette.bg, palette.icon),
                            errorWidget: (_, __, ___) =>
                                _placeholder(palette.bg, palette.icon),
                          )
                        : _placeholder(palette.bg, palette.icon),
                  ),
                ),
              ),

              // Text area
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        specialization.name ?? 'unknown_specialization'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            'view_teachers'.tr(),
                            style: TextStyle(
                              color: palette.icon,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(Icons.arrow_forward_ios,
                              size: 10.w, color: palette.icon),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(Color bg, Color iconColor) {
    return Container(
      color: bg,
      child: Center(
        child: Icon(Icons.school_outlined, size: 32, color: iconColor),
      ),
    );
  }
}
