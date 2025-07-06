import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/bloc/provider_appointments/provider_appointments_cubit.dart';
import 'package:my_academy/model/common/courses/course_model.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/widget/master_list/custom_list.dart';

import '../../../../bloc/provider_requests/provider_requests_cubit.dart';
import '../../../../widget/space/space.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../activity/auth/register/provider/subscribers_screen.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/current_subject/provider_academic_card.dart';
import 'provider_course_appointments_cache.dart';

class ProviderAppointmentsCourseView extends StatelessWidget {
  const ProviderAppointmentsCourseView({
    super.key,
    required this.status,
  });
  final String status;

  // final scrollController = ScrollController();

  // void setupScrollController(context) {
  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels != 0) {
  //         BlocProvider.of<ProviderAppointmentsCubit>(context).getLessons();
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProviderAppointmentsCubit()..getCourses(status),
      child: BlocConsumer<ProviderAppointmentsCubit, ProviderAppointmentsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ProviderAppointmentsCubit,
              ProviderAppointmentsState>(builder: (context, state) {
            // final bloc = ProviderAppointmentsCubit.get(context);
            if (state is ProviderCourseLoadingState && state.isFirstFetch ||
                state is ProviderRequestsInitial) {
              return ProviderAppointmentsCourseCacheView(status: status);
            }
            List<CourseModel> data = [];
            if (state is ProviderCourseLoadingState) {
              data = state.oldRequests;
            } else if (state is ProviderCourseLoadedState) {
              data = state.data;
            }
            return subjectView(context, data);
          });
        },
      ),
    );
  }

  subjectView(context, List<CourseModel> data) {
    return BlocProvider(
        create: (context) => ProviderAppointmentsCubit()..initCourse(data),
        child:
            BlocConsumer<ProviderAppointmentsCubit, ProviderAppointmentsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final bloc = ProviderAppointmentsCubit.get(context);
                  return bloc.courseModel.isEmpty
                      ? SizedBox(
                          width: screenWidth,
                          height: screenHeight * 2 / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              EmptyScreen(
                                title: tr("no_appointments"),
                                image: emptyCurrent,
                                width: screenWidth,
                                height: screenHeight / 3,
                                color: mainColor.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        )
                      : CustomList(
                          listHeight: 1000000000000000,
                          listWidth: screenWidth,
                          scroll: const NeverScrollableScrollPhysics(),
                          axis: Axis.vertical,
                          count: bloc.courseModel.length,
                          child: (context, index) => Column(
                                children: [
                                  SubjectAcademinScreen(
                                    data: bloc.courseModel[index],
                                    onTap: () {
                                      Get.to(() => SubscribersScreen(
                                            id: bloc.courseModel[index].id!,
                                          ));
                                    },
                                  ),
                                  // SubjectCardScreen(
                                  //   data: data[index],
                                  //   onTap: (){
                                  //     // Get.to(()=> RequestsSentScreen(
                                  //     //   type: 'course',
                                  //     //   id: data[index].id!,
                                  //     // ));
                                  //   },
                                  // ),
                                  const Space(
                                    boxHeight: 20,
                                  ),
                                ],
                              ));
                }));
  }
}
