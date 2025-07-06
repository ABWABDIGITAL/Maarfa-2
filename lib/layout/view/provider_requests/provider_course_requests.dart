import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/provider_screens/requests_sent/requests_sent_screen.dart';
import 'package:my_academy/layout/card_view/current_subject/provider_subject_card.dart';
import 'package:my_academy/model/common/courses/course_model.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/widget/master_list/custom_list.dart';

import '../../../../bloc/provider_requests/provider_requests_cubit.dart';
import '../../../../repository/provider/requests/requests_repository.dart';
import '../../../../widget/space/space.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import 'provider_course_requests_cache_view.dart';

class ProviderRequestsCourseView extends StatelessWidget {
  const ProviderRequestsCourseView({super.key});
  // final scrollController = ScrollController();

  // void setupScrollController(context) {
  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels != 0) {
  //         BlocProvider.of<ProviderRequestsCubit>(context).getRequests();
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProviderRequestsCubit(RequestsProvider())..getRequests(),
      child: BlocConsumer<ProviderRequestsCubit, ProviderRequestsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ProviderRequestsCubit, ProviderRequestsState>(
              builder: (context, state) {
            if (state is ProviderRequestsLoadingState && state.isFirstFetch ||
                state is ProviderRequestsInitial) {
              return const ProviderRequestsCourseCacheView();
            }
            List<CourseModel> data = [];
            if (state is ProviderRequestsLoadingState) {
              data = state.oldRequests;
            } else if (state is ProviderRequestsLoadedState) {
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
        create: (context) =>
            ProviderRequestsCubit(RequestsProvider())..initCourse(data),
        child: BlocBuilder<ProviderRequestsCubit, ProviderRequestsState>(
            builder: (context, state) {
          final bloc = ProviderRequestsCubit.get(context);
          return bloc.courseModel.isEmpty
              ? SizedBox(
                  width: screenWidth,
                  height: screenHeight * 2 / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EmptyScreen(
                        title: tr("no_bookmark"),
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
                          SubjectCardScreen(
                            data: bloc.courseModel[index],
                            onTap: () {
                              Get.to(() => RequestsSentScreen(
                                    type: 'course',
                                    id: bloc.courseModel[index].id!,
                                  ));
                            },
                          ),
                          const Space(
                            boxHeight: 20,
                          ),
                        ],
                      ));
        }));
  }
}
