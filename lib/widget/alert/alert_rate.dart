import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_academy/bloc/rate/rate_cubit.dart';
import 'package:my_academy/res/drawable/icon/icons.dart';
import 'package:my_academy/res/drawable/lottie/lottie.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/buttons/master/master_button.dart';
import 'package:my_academy/widget/buttons/master_load/master_load_button.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';

class RateAlert extends StatelessWidget {
  const RateAlert({super.key, required this.id, required this.type});

  final String type;

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RateCubit(),
        child: BlocConsumer<RateCubit, RateState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = RateCubit.get(context);
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                    children: [
                      SingleChildScrollView(
                        
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(10.w, 50.h, 10.w, 10.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10.h),
                              // Teacher Rating Section
                              Text(
                                tr("rate_teacher"),
                                style: TextStyles.headerStyle.copyWith(
                                    color: black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 8.h),
                              RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 25.sp,
                                ratingWidget: RatingWidget(
                                  full: Image.asset(starOrange),
                                  half: Image.asset(starOrange),
                                  empty: Image.asset(starWhite),
                                ),
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.w),
                                onRatingUpdate: (rating) {
                                  bloc.rating = rating;
                                },
                              ),
                              SizedBox(height: 20.h),
                              // Session Quality Rating Section
                              Text(
                                tr("session_quality"),
                                style: TextStyles.headerStyle.copyWith(
                                    color: black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                tr("rate_session_quality"),
                                style: TextStyles.hintStyle.copyWith(
                                    fontSize: 12.sp),
                              ),
                              SizedBox(height: 8.h),
                              RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 25.sp,
                                ratingWidget: RatingWidget(
                                  full: Image.asset(starOrange),
                                  half: Image.asset(starOrange),
                                  empty: Image.asset(starWhite),
                                ),
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.w),
                                onRatingUpdate: (rating) {
                                  bloc.sessionQualityRating = rating;
                                },
                              ),
                              SizedBox(height: 20.h),
                              // Review Text Field
                              SidePadding(
                                sidePadding: 10,
                                child: TextField(
                                  controller: bloc.rateController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: tr("write_rate"),
                                    hintStyle: TextStyles.hintStyle
                                        .copyWith(fontSize: 12.sp),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 10.h),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                      borderSide:
                                          const BorderSide(color: borderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                      borderSide:
                                          const BorderSide(color: mainColor),
                                    ),
                                  ),
                                  style: TextStyles.hintStyle
                                      .copyWith(fontSize: 13.sp, color: black),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              // Buttons
                              SidePadding(
                                sidePadding: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: MasterLoadButton(
                                        buttonHeight: 55,
                                        onPressed: () => bloc.addRate(
                                          type: type,
                                          id: id,
                                        ),
                                        buttonText: tr("rate"),
                                        buttonStyle: TextStyles
                                            .textView14SemiBold
                                            .copyWith(color: white),
                                        buttonColor: mainColor,
                                        buttonController: bloc.loadController,
                                      ),
                                    ),
                                    const Space(
                                      boxWidth: 10,
                                    ),
                                    Expanded(
                                      child: MasterButton(
                                        buttonHeight: 55,
                                        buttonColor: profileColor,
                                        borderColor: profileColor,
                                        onPressed: () {
                                          Get.back();
                                        },
                                        buttonText: tr("cancel"),
                                        buttonStyle: TextStyles
                                            .textView14SemiBold
                                            .copyWith(color: mainColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: -300,
                          child: Lottie.asset(rate,
                              height: 200, width: 300, fit: BoxFit.cover)),
                    ],
                  ));
            }));
  }
}
