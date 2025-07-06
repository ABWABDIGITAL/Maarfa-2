import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/all_requests/all_requests_cubit.dart';
import 'package:my_academy/repository/user/all_requests/all_requests_repository.dart';

import '../../../model/user/lesson_requests/lesson_requests_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/space/space.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/my_requests/request_subject_card.dart';

class RequestsSubjectCacheView extends StatelessWidget {
  const RequestsSubjectCacheView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            AllRequestsCubit(AllRequestsRepository())..getLessonRequestsCache(),
        child: BlocConsumer<AllRequestsCubit, AllRequestsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<AllRequestsCubit, AllRequestsState>(
                  builder: (context, state) {
                if (state is LessonRequestsLoadedState) {
                  final data = state.data;
                  return requestsLessonView(context, data!);
                } else if (state is LessonRequestsLoadErrorState) {
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
}

requestsLessonView(
  BuildContext context,
  List<RequestModel> data,
) {
  return data.isEmpty
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
                height: 300.h,
                color: mainColor.withValues(alpha: 0.3),
              ),
            ],
          ),
        )
      : CustomList(
          listHeight: 100000000000000,
          listWidth: screenWidth,
          scroll: const ClampingScrollPhysics(),
          axis: Axis.vertical,
          count: data.length,
          child: (context, index) {
            // final status = context
            //     .read<AllRequestsCubit>()
            //     .getStatus(data[index].status.toString());
            return Column(
              children: [
                RequestSubjectCard(
                  lessonId: data[index].id!,
                  price: data[index].lesson!.hourPrice!,
                  lessonTitle: data[index].lesson!.subject!.name!,
                  name: data[index].lesson!.provider!.firstName!,
                  id: data[index].lesson!.subject!.id!,
                  onlineCheck: data[index].status.toString(),
                  acceptanceCheck: data[index].status == 1
                      ? tr("pending")
                      : data[index].status == 2
                          ? tr("accepted")
                          : data[index].status == 3
                              ? tr("rejected")
                              : tr("paid"),
                  onTap: () {},
                ),
                const Space(
                  boxHeight: 15,
                ),
              ],
            );
          });
}
