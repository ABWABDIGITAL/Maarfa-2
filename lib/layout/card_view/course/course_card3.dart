import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../bloc/groups/groups_cubit.dart';
import '../../../model/common/courses/course_details/course_details_model.dart';
import '../../../repository/user/groups_courses/groups_courses_repository.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../activity/provider_screens/map/course_location_screen.dart';

class CourseCard3 extends StatefulWidget {
  final bool isBlue;
  final bool? row;
  final CourseDetailsModel courseDetailsModel;

  // const CourseCard2({Key? key, this.isBlue = false}) : super(key: key);
  const CourseCard3({
    super.key,
    this.row,
    this.isBlue = false,
    required this.courseDetailsModel,
  });

  @override
  State<CourseCard3> createState() => _CourseCard3State();
}

class _CourseCard3State extends State<CourseCard3> {
  bool isFavorite = false;
  initFavorite() {
    setState(() {
      isFavorite = widget.isBlue;
    });
  }

  @override
  void initState() {
    initFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.center,
      children: [
        Container(
          width: screenWidth,
          // height: 500.h,
          color: textfieldColor.withValues(alpha: 0.1),
          child: Column(
            children: [
              Stack(
                alignment: FractionalOffset.topRight,
                children: [
                  Container(
                    width: screenWidth,
                    color: black.withValues(alpha: 0.1),
                    child: CachedImage(
                      imageUrl: widget.courseDetailsModel.image!,
                      width: screenWidth,
                      height: 275.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            //padding: EdgeInsets.only(top: 40, right: 30),
                            height: 40.h,
                            width: 50.w,
                            // clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              color: white,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(child: Icon(Icons.arrow_back)),
                          ),
                        ),
                      ),
                      Space(
                        boxHeight: 30.h,
                      ),
                      _courseInformation(widget.courseDetailsModel),
                    ],
                  ),
                ],
              ),
              Space(
                boxHeight: 15.h,
              ),
              _courseInfo(widget.courseDetailsModel),
            ],
          ),
        ),
        SidePadding(
          sidePadding: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    BlocProvider.of<BookmarkCubit>(context).addToBookMark(
                        id: widget.courseDetailsModel.id!, type: 'course');
                    isFavorite = !isFavorite;
                  });
                },
                child: Image.asset(
                  isFavorite ? blueBookmarkIcon : bookmarkIcon,
                  height: 70.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _courseInfo(CourseDetailsModel courseDetailsModel) {
    return BlocProvider(
        create: (BuildContext context) => GroupsCubit(GroupModelRepository())
          ..initAddress(
              courseDetailsModel.type ?? 0, courseDetailsModel.location ?? ""),
        child: BlocConsumer<GroupsCubit, GroupsState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = GroupsCubit.get(context);
              return SidePadding(
                sidePadding: 20,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          courseDetailsModel.specialization!.name ?? "",
                          style: TextStyles.hintStyle.copyWith(
                              color: grey, fontWeight: FontWeight.bold),
                        ),
                      ]),
                      Space(
                        boxHeight: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            courseDetailsModel.type == 1
                                ? tr("offline")
                                : courseDetailsModel.type == 2
                                    ? tr("live")
                                    : tr("online"),
                            style: TextStyles.contentStyle.copyWith(
                                color: mainColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      courseDetailsModel.type == 1
                          ? InkWell(
                              onTap: () => Get.to(() => CourseLocationScreen(
                                    lat: bloc.lat!,
                                    lng: bloc.lng!,
                                  )),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bloc.address ?? "",
                                    style: TextStyles.hintStyle
                                        .copyWith(color: secColor),
                                  ),
                                  Text(
                                    "العرض على الخريطة",
                                    style: TextStyles.hintStyle.copyWith(
                                        color: secColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : const Space(),
                      const Space(
                        boxHeight: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            courseDetailsModel.priceWithoutTax.toString(),
                            style: TextStyles.priceStyle,
                          ),
                          Text(
                            tr("sar"),
                            style: TextStyles.selectedStyle.copyWith(
                              color: black,
                            ),
                          ),
                          Text(
                            "/",
                            style: TextStyles.titleStyle.copyWith(color: black),
                          ),
                          Text(
                            courseDetailsModel.numberOfHours.toString(),
                            style: TextStyles.selectedStyle,
                          ),
                          Text(
                            tr("hour"),
                            style: TextStyles.contentStyle
                                .copyWith(color: mainColor),
                          ),
                        ],
                      ),
                      const Space(
                        boxHeight: 10,
                      ),
                      courseDetailsModel.attendanceType != 1
                          ? Row(
                              children: [
                                Image.asset(groupIcon),
                                RichText(
                                    text: TextSpan(
                                        text: tr("group"),
                                        style: TextStyles.hintStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: blackColor),
                                        children: [
                                      TextSpan(
                                          text: "${tr('max_people')} ",
                                          style: TextStyles.contentStyle),
                                      TextSpan(
                                          text: courseDetailsModel.maxStudents
                                              .toString(),
                                          style: TextStyles.contentStyle)
                                    ]))
                                // Text(tr("group{}",)),
                              ],
                            )
                          : Row(
                              children: [
                                Image.asset(userIcon),
                                Text(tr("single"),
                                    style: TextStyles.hintStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: blackColor)),
                                // Text(tr("group{}",)),
                              ],
                            ),
                      const Space(
                        boxHeight: 20,
                      ),
                    ]),
              );
            }));
  }

  _courseInformation(CourseDetailsModel courseDetailsModel) {
    return SidePadding(
      sidePadding: 20,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.75,
                  child: Text(
                    courseDetailsModel.name ?? "",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.introStyle
                        .copyWith(color: white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Space(
              boxHeight: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  star,
                  height: 15.h,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    courseDetailsModel.provider!.rate.toString(),
                    style: TextStyles.subTitleStyle.copyWith(
                        color: Colors.yellow, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  "(${courseDetailsModel.provider!.rateCount} ${tr("rater")})",
                  style: TextStyles.smallStyle.copyWith(color: white),
                ),
              ],
            ),
          ]),
    );
  }
}
