import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/live/live_cubit.dart';
import '../../../repository/live/live_repository.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/logo/logo/logo.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';

class CurrentSubjectCard extends StatelessWidget {
  const CurrentSubjectCard(
      {super.key,
      required this.isLive,
      required this.type,
      this.image,
      required this.courseTitle,
      required this.name,
      required this.currentTimeId,
      required this.price,
      required this.id,
      this.onConferenceEnded});
  final String courseTitle;
  final String? image;
  final int? currentTimeId;
  final String name;
  final String price;
  final int id;
  final String type;
  final bool isLive;
  final VoidCallback? onConferenceEnded;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => LiveCubit(LiveRepository()),
        child: BlocConsumer<LiveCubit, LiveState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = LiveCubit.get(context);
              return SidePadding(
                sidePadding: 15,
                child: Container(
                  height: 160,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: textfieldColor,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Space(
                        boxHeight: 15,
                      ),
                      SidePadding(
                        sidePadding: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                type == "course"
                                    ? Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        width: 80.w,
                                        height: 70.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: CachedNetworkImage(
                                            imageUrl: image!,
                                            width: 80.w,
                                            height: 70.h,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Logo(
                                                  logoHeight: 50,
                                                  logoWidth: 50,
                                                )),
                                      )
                                    : const Logo(logoHeight: 50, logoWidth: 50),
                                const Space(
                                  boxHeight: 5,
                                ),
                                Text("#$id",
                                    style: TextStyles.errorStyle
                                        .copyWith(color: textfieldColor)),
                              ],
                            ),
                            const Space(
                              boxWidth: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenWidth / 2,
                                    child: Text(courseTitle,
                                        style: TextStyles.appBarStyle.copyWith(
                                            color: blackColor,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: screenWidth / 2,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          profile,
                                          height: 15.h,
                                          fit: BoxFit.contain,
                                          color: textfieldColor,
                                        ),
                                        Text(name, style: TextStyles.hintStyle),
                                      ],
                                    ),
                                  ),
                                  // const Space(
                                  //   boxWidth: 10,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     Text(tr("subject_details"),
                                  //         style: TextStyles.subTitleStyle),
                                  //     const Space(
                                  //       boxWidth: 5,
                                  //     ),
                                  //     Image.asset(moreInfo,
                                  //         height: 10.h, fit: BoxFit.contain),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      Image.asset(money,
                                          height: 15.h, fit: BoxFit.contain),
                                      Text("$price ${tr("sar")}",
                                          style: TextStyles.hintStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      bloc.isLoad
                          ? const Loading()
                          : type == "lesson"
                              ? InkWell(
                                  onTap: () => bloc.enterLive(false, id, type,
                                      timeId: currentTimeId,
                                      onConferenceEnded: onConferenceEnded),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: screenWidth,
                                      height: 40.h,
                                      color: mainLightColor,
                                      child: Center(
                                          child: Text(tr("enter_lesson"),
                                              style: TextStyles.unselectedStyle
                                                  .copyWith(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                    ),
                                  ),
                                )
                              : isLive
                                  ? InkWell(
                                      onTap: () => bloc.enterLive(
                                          false, id, type,
                                          timeId: currentTimeId,
                                          onConferenceEnded: onConferenceEnded),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: screenWidth,
                                          height: 40.h,
                                          color: mainLightColor,
                                          child: Center(
                                              child: Text(tr("enter_lesson"),
                                                  style: TextStyles
                                                      .unselectedStyle
                                                      .copyWith(
                                                          color: white,
                                                          fontWeight: FontWeight
                                                              .w700))),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                    ],
                  ),
                ),
              );
            }));
  }
}
