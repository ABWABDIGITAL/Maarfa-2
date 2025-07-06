import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/provider_course_details/provider_course_details_cubit.dart';
import '../../../model/common/courses/course_details/course_details_model.dart';
import '../../../repository/provider/courses/courses_repository.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/alert/delete/delete_alert.dart';
import '../../../widget/buttons/master/master_button.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../activity/provider_screens/add_contant/add_course_screen.dart';
import '../../activity/user_screens/app_appointments/available_appointments_screen.dart';
import '../../activity/user_screens/trainer/trainer_screen.dart';
import '../../card_view/course/course_info_card.dart';
import '../../card_view/trainer_card/trainer_card.dart';

class ProviderCourseDetailsView extends StatelessWidget {
  const ProviderCourseDetailsView(
      {super.key, required this.id, required this.isUser});
  final int id;
  final bool isUser;
  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ProviderCourseDetailsCubit(CoursesRepository())..getCourseById(id),
        child: BlocConsumer<ProviderCourseDetailsCubit,
                ProviderCourseDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<ProviderCourseDetailsCubit,
                  ProviderCourseDetailsState>(builder: (context, state) {
                if (state is CourseDetailsLoadedState) {
                  final data = (state).data;
                  return courseDetailsView(context, data);
                } else if (state is CourseDetailsErrorState) {
                  return const ErrorPage();
                } else {
                  return const Loading();
                }
              });
            }));
  }

  courseDetailsView(context, CourseDetailsModel data) {
    return BlocProvider(
        create: (BuildContext context) =>
            ProviderCourseDetailsCubit(CoursesRepository()),
        child: BlocConsumer<ProviderCourseDetailsCubit,
                ProviderCourseDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = ProviderCourseDetailsCubit.get(context);
              return ListView(
                children: [
                  CourseInfoCard(
                    courseTitle: data.name!,
                    specialization: data.specialization!.name!,
                    data: data,
                  ),
                  SidePadding(
                    sidePadding: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Space(
                          boxHeight: 20,
                        ),
                        Text(
                          tr("course_detials"),
                          style: TextStyles.appBarStyle.copyWith(color: black),
                        ),
                        const Space(boxHeight: 10),
                        Text(
                          data.content!,
                          style: TextStyles.hintStyle,
                        ),
                        const Space(boxHeight: 10),
                        // InkWell(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         tr("show_more"),
                        //         style: TextStyles.subTitleStyle,
                        //       ),
                        //       const Icon(
                        //         Icons.keyboard_arrow_down,
                        //         color: mainColor,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const Space(boxHeight: 20),
                        Text(
                          tr("acquired_skills"),
                          style: TextStyles.appBarStyle.copyWith(color: black),
                        ),
                        const Space(boxHeight: 10),
                        Wrap(
                          children: List.generate(
                              data.tags!.length,
                              (index) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 3.w),
                                  child: ChoiceChip(
                                      backgroundColor: white,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: textfieldColor),
                                          borderRadius:
                                              BorderRadius.circular(25.r)),
                                      onSelected: (t) {},
                                      selectedColor: mainColor,
                                      label: Text(data.tags![index].name!,
                                          style: TextStyles.appBarStyle
                                              .copyWith(
                                                  color: black,
                                                  fontWeight: FontWeight.bold)),
                                      selected: false))),
                        ),
                        const Space(boxHeight: 30),
                        Text(
                          tr("trainer"),
                          style: TextStyles.appBarStyle.copyWith(color: black),
                        ),
                        Space(boxHeight: 10.h),
                        GestureDetector(
                          onTap: () => Get.to(() => TrainerScreen(
                                id: data.provider!.id!,
                                isUser: false,
                              )),
                          child: TrainerCard(
                            courseDetailsModel: data,
                          ),
                        ),
                        const Space(boxHeight: 30),
                        // MasterButton(
                        //   // buttonStyle:
                        //   //     TextStyles.appBarStyle.copyWith(color: mainColor),
                        //   onPressed: () {
                        //     Get.to(() => SubscribersScreen(id: data.id!));
                        //   },
                        //   buttonText: tr("certificate_issuance"),
                        // ),
                        const Space(boxHeight: 30),
                        MasterButton(
                          // buttonStyle:
                          //     TextStyles.appBarStyle.copyWith(color: mainColor),
                          onPressed: () {
                            Get.to(
                              () => AddCourseScreen(
                                courseDetailsMode: data,
                              ),
                            );
                          },
                          buttonText: tr("repeat"),
                        ),

                        const Space(boxHeight: 15),
                        MasterButton(
                            // buttonStyle:
                            //     TextStyles.appBarStyle.copyWith(color: mainColor),
                            onPressed: () {
                              Get.to(() => AvailableAppointments(
                                  isUser: false,
                                  courseId: data.id,
                                  courseDetailsModel: data));
                            },
                            buttonText: tr("view_table")),
                        // const Space(boxHeight: 20),
                        // MasterButton(
                        //     borderColor: transparent,
                        //     buttonColor: mainColor.withValues(alpha:0.1),
                        //     buttonStyle: TextStyles.appBarStyle
                        //         .copyWith(color: mainColor),
                        //     onPressed: () {},
                        //     buttonText: tr("edit")),

                        const Space(boxHeight: 20),
                        MasterButton(
                            borderColor: transparent,
                            buttonColor: circleColor.withValues(alpha: 0.1),
                            buttonStyle: TextStyles.appBarStyle
                                .copyWith(color: circleColor),
                            onPressed: () => deleteAlert(
                                  deleteTap: () => bloc.deleteCourse(data.id!),
                                ),
                            buttonText: tr("deactive")),
                        const Space(boxHeight: 30),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
