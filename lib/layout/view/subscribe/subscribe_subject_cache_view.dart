import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/subscribe/subscribe_cubit.dart';
import '../../../model/user/subscriptions/subscribe_subject/subscribe_subject_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../activity/user_screens/subject/subject_details.dart';
import '../../card_view/current_subject/current_subject_card.dart';
import '../../card_view/subscribe_subject/subscribe_subject_card.dart';

class SubscribeSubjectCacheView extends StatelessWidget {
  const SubscribeSubjectCacheView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<SubscribeCubit>(context)
          ..getSubscriptionLessonCache(),
        child: BlocConsumer<SubscribeCubit, SubscribeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<SubscribeCubit, SubscribeState>(
                  builder: (context, state) {
                if (state is SubjectSubscriptionLoadedState) {
                  final data = state.data;
                  return subscribeSubjectView(context, data);
                } else if (state is SubjectSubscriptionLoadErrorState) {
                  return const ErrorPage();
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeight / 3),
                    child: const Loading(),
                  );
                }
              });
            }));
  }

  subscribeSubjectView(BuildContext context, SubscribeSubjectModel data) {
    return BlocProvider.value(
        value: BlocProvider.of<SubscribeCubit>(context),
        // create: (BuildContext context) =>
        //     SubscribeCubit(SubscriptionsRepository())..initSubject(data),
        child: BlocConsumer<SubscribeCubit, SubscribeState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = SubscribeCubit.get(context);
              bloc.initSubject(data);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth,
                    color: textfieldColor.withValues(alpha: 0.2),
                    child: Column(
                      children: [
                        data.liveSubscription.isEmpty
                            ? const SizedBox()
                            : const Space(
                                boxHeight: 20,
                              ),
                        data.liveSubscription.isEmpty
                            ? const SizedBox()
                            : SidePadding(
                                sidePadding: 15,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(tr("current"),
                                        textAlign: TextAlign.start,
                                        style: TextStyles.unselectedStyle
                                            .copyWith(
                                                color: mainColor,
                                                fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                        data.liveSubscription.isEmpty
                            ? const SizedBox()
                            : CustomList(
                                listHeight: 100000000000000,
                                listWidth: screenWidth,
                                scroll: const NeverScrollableScrollPhysics(),
                                axis: Axis.vertical,
                                count: bloc.subscribeSubjectModel!
                                    .liveSubscription.length,
                                child: (context, index) => Column(
                                      children: [
                                        CurrentSubjectCard(
                                          currentTimeId: bloc
                                              .subscribeSubjectModel!
                                              .liveSubscription[index]
                                              .currentTimeId,
                                          type: "lesson",
                                          isLive: true,
                                          id: bloc
                                              .subscribeSubjectModel!
                                              .liveSubscription[index]
                                              .lesson
                                              .id,
                                          courseTitle: bloc
                                              .subscribeSubjectModel!
                                              .liveSubscription[index]
                                              .lesson
                                              .subject!
                                              .name!,
                                          price: bloc
                                              .subscribeSubjectModel!
                                              .liveSubscription[index]
                                              .lesson
                                              .hourPrice!,
                                          name:
                                              "${bloc.subscribeSubjectModel!.liveSubscription[index].lesson.provider.title!} ${bloc.subscribeSubjectModel!.liveSubscription[index].lesson.provider.firstName!} ${bloc.subscribeSubjectModel!.liveSubscription[index].lesson.provider.lastName!}",
                                        ),
                                        const Space(
                                          boxHeight: 15,
                                        ),
                                      ],
                                    )),
                      ],
                    ),
                  ),
                  const Space(
                    boxHeight: 20,
                  ),
                  bloc.subscribeSubjectModel!.subscriptions.isEmpty
                      ? SizedBox(
                          width: screenWidth,
                          height: screenHeight * 2 / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              EmptyScreen(
                                title: tr("no_subscriptions"),
                                image: emptyCurrent,
                                width: screenWidth,
                                height: 300.h,
                                color: mainColor.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        )
                      : SidePadding(
                          sidePadding: 15,
                          child: Text(tr("subjects"),
                              textAlign: TextAlign.start,
                              style: TextStyles.unselectedStyle.copyWith(
                                  color: blackColor,
                                  fontWeight: FontWeight.w700)),
                        ),
                  CustomList(
                      listHeight: 100000000000000,
                      listWidth: screenWidth,
                      scroll: const NeverScrollableScrollPhysics(),
                      axis: Axis.vertical,
                      count: bloc.subscribeSubjectModel!.subscriptions.length,
                      child: (context, index) => Column(
                            children: [
                              SubscribeSubjectCard(
                                onTap: () {
                                  Get.to(() => SubjectDetails(
                                        providerId: bloc
                                            .subscribeSubjectModel!
                                            .subscriptions[index]
                                            .lesson
                                            .provider
                                            .id,
                                        isFinshed: bloc.subscribeSubjectModel!
                                                .subscriptions[index].status ==
                                            4,
                                        times: bloc.subscribeSubjectModel!
                                            .subscriptions[index].times,
                                        providerName:
                                            "${bloc.subscribeSubjectModel!.subscriptions[index].lesson.provider.title!} / ${bloc.subscribeSubjectModel!.subscriptions[index].lesson.provider.firstName!} ${bloc.subscribeSubjectModel!.subscriptions[index].lesson.provider.lastName!} ",
                                        subjectTitle: bloc
                                            .subscribeSubjectModel!
                                            .subscriptions[index]
                                            .lesson
                                            .subject!
                                            .name!,
                                        subjectYear: bloc
                                            .subscribeSubjectModel!
                                            .subscriptions[index]
                                            .lesson
                                            .subject!
                                            .name!,
                                        hourPrice: bloc
                                            .subscribeSubjectModel!
                                            .subscriptions[index]
                                            .lesson
                                            .hourPrice!,
                                        hours: 1,
                                      ));
                                },
                                image: "",
                                price: bloc.subscribeSubjectModel!
                                    .subscriptions[index].lesson.hourPrice!,
                                id: bloc.subscribeSubjectModel!
                                    .subscriptions[index].lesson.subject!.id!,
                                name: bloc
                                    .subscribeSubjectModel!
                                    .subscriptions[index]
                                    .lesson
                                    .provider
                                    .firstName!,
                                title: bloc.subscribeSubjectModel!
                                    .subscriptions[index].lesson.subject!.name!,
                                status: bloc.subscribeSubjectModel!
                                            .subscriptions[index].status! ==
                                        1
                                    ? tr("offline")
                                    : bloc.subscribeSubjectModel!
                                                .subscriptions[index].status! ==
                                            2
                                        ? tr("live")
                                        : tr("online"),
                              ),
                              const Space(
                                boxHeight: 15,
                              ),
                            ],
                          )),
                ],
              );
            }));
  }
}
