import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../layout/activity/user_screens/search/search.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../side_padding/side_padding.dart';

class SearchTextfield extends StatelessWidget {
  final VoidCallback? onTap;
  final bool focus;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const SearchTextfield(
      {super.key,
      this.onTap,
      this.onChanged,
      this.controller,
      required this.focus});

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 35.w,
      child: LimitedBox(
        maxHeight: 55.h,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          autofocus: focus,
          style: TextStyles.hintStyle.copyWith(color: black),
          decoration: InputDecoration(
            fillColor: white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: white,
                  width: 1.w,
                  style: BorderStyle.solid,
                )),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: white,
                  width: 1.w,
                  style: BorderStyle.solid,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: white,
                  width: 1.w,
                  style: BorderStyle.solid,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: secColor,
                  width: 1.w,
                  style: BorderStyle.solid,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: white,
                  width: 1.w,
                  style: BorderStyle.solid,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: white,
                  width: 1.w,
                  style: BorderStyle.solid,
                )),
            hintText: tr("search_courses"),
            hintStyle: TextStyles.hintStyle,
            suffixIcon: GestureDetector(
              onTap: () {
                Get.to(const SearchScreen());
              },
              child: Container(
                height: 55.h,
                width: 55.w,
                decoration:
                    BoxDecoration(color: secColor.withValues(alpha: 0.1)),
                child: Center(
                    child:
                        Image.asset(filter, height: 20.h, fit: BoxFit.contain)),
              ),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Image.asset(search, height: 20.h, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
