import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../layout/activity/user_screens/search/search.dart';
import '../../res/drawable/icon/icons.dart';
import '../../res/value/color/color.dart';
import '../../res/value/style/textstyles.dart';
import '../side_padding/side_padding.dart';

class SearchHomeWidget extends StatelessWidget {
  const SearchHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 18.w,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.to(
            () => const SearchScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 250),
          );
        },
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              SvgPicture.asset(
                'assets/images/search_icon.svg',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  tr("search_courses"),
                  style: TextStyles.hintStyle.copyWith(
                    fontSize: 14.sp,
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Filter button — flat, no gradient
              Container(
                height: 56.h,
                width: 52.w,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    filter,
                    color: Colors.white,
                    height: 18.h,
                    width: 18.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
