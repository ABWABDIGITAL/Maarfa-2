import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/provider_screens/requests_sent/requests_sent_screen.dart';
import 'package:my_academy/layout/card_view/request_card/request_advice_card.dart';
import 'package:my_academy/model/common/lessons/lesson_model.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/widget/master_list/custom_list.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../../bloc/provider_requests/provider_requests_cubit.dart';
import '../../../../repository/provider/requests/requests_repository.dart';
import '../../../../widget/loader/loader.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../activity/static/empty_screens/empty_screens.dart';

class ProviderRequestsSubjectCacheView extends StatelessWidget {
  const ProviderRequestsSubjectCacheView({super.key});
  // final scrollController = ScrollController();

  // void setupScrollController(context) {
  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels != 0) {
  //         BlocProvider.of<ProviderRequestsCubit>(context).getLessonsRequests();
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProviderRequestsCubit(RequestsProvider())..getLessonsRequestsCache(),
      child: BlocConsumer<ProviderRequestsCubit, ProviderRequestsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ProviderRequestsCubit, ProviderRequestsState>(
              builder: (context, state) {
            if (state is ProviderLessonRequestsLoadingState &&
                    state.isFirstFetch ||
                state is ProviderRequestsInitial) {
              return Padding(
                padding: EdgeInsets.only(top: screenHeight / 3),
                child: const Loading(),
              );
            }
            List<LessonDetails> data = [];
            if (state is ProviderLessonRequestsLoadingState) {
              data = state.data;
            } else if (state is ProviderLessonRequestsLoadedState) {
              data = state.data;
            }
            return subjectView(context, data);
          });
        },
      ),
    );
  }

  subjectView(context, List<LessonDetails> data) {
    return BlocProvider(
        create: (context) =>
            ProviderRequestsCubit(RequestsProvider())..initLesson(data),
        child: BlocBuilder<ProviderRequestsCubit, ProviderRequestsState>(
            builder: (context, state) {
          final bloc = ProviderRequestsCubit.get(context);
          return bloc.lessonModel.isEmpty
              ? SizedBox(
                  width: screenWidth,
                  height: screenHeight * 2 / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EmptyScreen(
                        title: tr("no_requests"),
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
                  count: bloc.lessonModel.length,
                  child: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Column(
                      children: [
                        RequestAdviceCard(
                          id: bloc.lessonModel[index].id!.toString(),
                          title: bloc.lessonModel[index].subject!.name,
                          date: bloc.lessonModel[index].times![0].startsAt
                              .toString(),
                          onTap: () {
                            Get.to(
                              () => RequestsSentScreen(
                                type: 'lesson',
                                id: bloc.lessonModel[index].id!,
                              ),
                            );
                          },
                          requestsCount:
                              bloc.lessonModel[index].requestsCount.toString(),
                          lessonPlace:
                              bloc.lessonModel[index].educationalStage!.name,
                        ),
                        const Space(
                          boxHeight: 15,
                        ),
                      ],
                    ),
                  ),
                );
        }));
  }
}
