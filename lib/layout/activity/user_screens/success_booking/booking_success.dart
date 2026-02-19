import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/bloc/bottom_bar/bottom_bar_cubit.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../main/main_screen.dart';

class BookingStatus extends StatelessWidget {
  const BookingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon
              Container(
                width: 96.w,
                height: 96.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 52.w,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Title
              Text(
                tr('booked'),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10.h),

              // Subtitle
              Text(
                tr('booking_confirmed_desc'),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 36.h),

              // Booking status card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
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
                  children: [
                    _InfoRow(
                      icon: Icons.event_available_rounded,
                      label: tr('booking_status'),
                      value: tr('pending_confirmation'),
                      valueColor: const Color(0xFF856404),
                      valueBg: const Color(0xFFFFF3CD),
                    ),
                    Divider(
                        height: 24.h,
                        thickness: 1,
                        color: const Color(0xFFF3F4F6)),
                    _InfoRow(
                      icon: Icons.notifications_outlined,
                      label: tr('next_step'),
                      value: tr('await_teacher_confirmation'),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Primary CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(const MainScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    tr('main'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Secondary CTA
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    BlocProvider.of<BottomBarCubit>(context).selectedIndex = 2;
                    Get.to(() => const MainScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: const BorderSide(color: Color(0xFFE8E8E8)),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    tr('my_subscriptions'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final Color? valueBg;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 18.sp, color: const Color(0xFF374151)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
          ),
        ),
        valueBg != null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: valueBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF1A1A1A),
                  ),
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
      ],
    );
  }
}
