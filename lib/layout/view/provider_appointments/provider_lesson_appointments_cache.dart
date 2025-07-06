import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/provider_appointments/provider_appointments_cubit.dart';
import 'package:my_academy/layout/card_view/request_card/request_advice_card.dart';
import 'package:my_academy/model/common/lessons/lesson_model.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/widget/master_list/custom_list.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../../widget/loader/loader.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../activity/static/empty_screens/empty_screens.dart';

class ProviderAppointmentsSubjectCacheView extends StatelessWidget {
  const ProviderAppointmentsSubjectCacheView({
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
          ProviderAppointmentsCubit()..getLessonsCache(status),
      child: BlocConsumer<ProviderAppointmentsCubit, ProviderAppointmentsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ProviderAppointmentsCubit,
              ProviderAppointmentsState>(builder: (context, state) {
            if (state is ProviderLessonsLoadingState && state.isFirstFetch ||
                state is ProviderAppointmentsInitial) {
              return Padding(
                padding: EdgeInsets.only(top: screenHeight / 3),
                child: const Loading(),
              );
            }
            List<LessonDetails> data = [];
            if (state is ProviderLessonsLoadingState) {
              data = state.data;
            } else if (state is ProviderLessonsLoadedState) {
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
        create: (context) => ProviderAppointmentsCubit()..initLesson(data),
        child:
            BlocConsumer<ProviderAppointmentsCubit, ProviderAppointmentsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final bloc = ProviderAppointmentsCubit.get(context);
                  return bloc.lessonModel.isEmpty
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
                          count: bloc.lessonModel.length,
                          child: (context, index) => Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Column(
                              children: [
                                RequestAdviceCard(
                                  isRequest: false,
                                  id: bloc.lessonModel[index].id!.toString(),
                                  title: bloc.lessonModel[index].subject!.name,
                                  date: bloc
                                      .lessonModel[index].times![0].startsAt
                                      .toString(),
                                  onTap: () {
                                    // Get.to(() =>
                                    //     RequestsSentScreen(
                                    //   type:'lesson',
                                    //   id: data[index].id!,
                                    // ),);
                                  },
                                  requestsCount: bloc
                                      .lessonModel[index].requestsCount
                                      .toString(),
                                  lessonPlace: bloc.lessonModel[index]
                                      .educationalStage!.name,
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
