import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/model/common/courses/course_details/course_details_model.dart';

import '../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../bloc/course_subject/course_subject_cubit.dart';
import '../../../bloc/specialzation/specialization_state.dart';
import '../../../repository/user/courses/courses_repository.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/space/space.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../activity/user_screens/course/course_registration.dart';
import '../../card_view/course/course_card.dart';

class SpecializationView extends StatelessWidget {
  const SpecializationView(
      {super.key, this.title, this.id, required this.filter});
  final String? title;
  final int? id;
  final Map<String, dynamic> filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CourseSubjectCubit(CoursesRepository())
        ..getCourses(
            1,
            filter.containsKey("specialization_ids[]")
                ? filter["specialization_ids[]"]
                : id!,
            filter),
      child: BlocConsumer<CourseSubjectCubit, CourseSubjectState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CourseLoadedState) {
              return specializationView(context: context, data: (state).data);
            } else if (state is SpecializationErrorState) {
              return const ErrorPage();
            }
            // else if (state is CourseSubjectLoadingState) {
            //   return Center(
            //     child: SizedBox(
            //       height: 150.h,
            //       child: const Dialog(
            //         child: Loading(),
            //       ),
            //     ),
            //   );
            // }
            return const Loading();
          }),
    );
  }

  specializationView({
    required BuildContext context,
    required List<CourseDetailsModel> data,
  }) {
    return BlocProvider(
        create: (BuildContext context) =>
            CourseSubjectCubit(CoursesRepository())..initBookMarkCourse(data),
        child: BlocConsumer<CourseSubjectCubit, CourseSubjectState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = CourseSubjectCubit.get(context);
              return data.isEmpty
                  ? SizedBox(
                      width: screenWidth,
                      height: screenHeight * 2 / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmptyScreen(
                            title: tr("no_course"),
                            image: emptyCurrent,
                            width: screenWidth,
                            height: 300.h,
                            color: mainColor.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        // const Space(
                        //   boxHeight: 15,
                        // ),
                        // SidePadding(
                        //   sidePadding: 15,
                        //   child: CustomList(
                        //     listHeight: 40,
                        //     listWidth: screenWidth,
                        //     scroll: const ScrollPhysics(),
                        //     axis: Axis.horizontal,
                        //     count: bloc.typeList.length,
                        //     child: (context, index) => GestureDetector(
                        //       onTap: () {
                        //         /// get only all courses
                        //         bloc.getCoursesByType(1, id);
                        //       },
                        //       child: CourseTypeCard(
                        //         title: bloc.typeList[index]["type"],
                        //         // Get.locale!.languageCode == "en"
                        //         //     ? bloc.typeListEn[index]
                        //         //     : bloc.typeListAr[index],
                        //         isSelected: bloc.typeList[index]["isSelected"],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const Space(
                          boxHeight: 20,
                        ),
                        CustomList(
                          listHeight: 1000000000000,
                          listWidth: screenWidth,
                          axis: Axis.vertical,
                          scroll: const NeverScrollableScrollPhysics(),
                          count: data.length,
                          child: (context, index) => CourseCard(
                            isBlue: bloc.courseList[index],
                            favoriteTap: () {
                              bloc.bookmarkCourse(index);
                              BlocProvider.of<BookmarkCubit>(context)
                                  .addToBookMark(
                                      id: data[index].id!, type: "course");
                            },
                            id: id,
                            attendType: data[index].type == 1
                                ? tr("offline")
                                : tr("online"),
                            // Get.locale!.languageCode == "en"
                            //     ? bloc.typeListEn[1]
                            //     : bloc.typeListAr[1]:data[index].attendanceType==2?Get.locale!.languageCode == "en"
                            //     ? bloc.typeListEn[3]
                            //     : bloc.typeListAr[3]:Get.locale!.languageCode == "en"
                            //     ? bloc.typeListEn[2]
                            //     : bloc.typeListAr[2],
                            onPress: () => Get.to(
                              CourseRegistration(
                                id: data[index].id!,
                                isUser: true,
                              ),
                            ),
                            courseModel: data[index],
                          ),
                        ),
                      ],
                    );
            }));
  }
}
