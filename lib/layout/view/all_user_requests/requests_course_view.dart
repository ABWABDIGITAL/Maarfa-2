import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/all_requests/all_requests_cubit.dart';
import 'package:my_academy/repository/user/all_requests/all_requests_repository.dart';

import '../../../model/user/request_details/request_details_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/space/space.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/my_requests/request_course_card.dart';
import 'request_course_cache_view.dart';

class RequestsCourseView extends StatelessWidget {
  const RequestsCourseView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            AllRequestsCubit(AllRequestsRepository())..getCourseRequests(),
        child: BlocConsumer<AllRequestsCubit, AllRequestsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<AllRequestsCubit, AllRequestsState>(
                  builder: (context, state) {
                if (state is CourseRequestsLoadedState) {
                  final data = state.data;
                  return requestsCourseView(context: context, data: data!);
                } else if (state is CourseRequestsLoadErrorState) {
                  return const ErrorPage();
                } else {
                  return const RequestsCourseCacheView();
                }
              });
            }));
  }

  requestsCourseView({
    required BuildContext context,
    required List<RequestDetailsModel> data,
  }) {
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
              final attendanceType = context
                  .read<AllRequestsCubit>()
                  .getAttendanceType(data[index].course.type.toString());
              final status = context
                  .read<AllRequestsCubit>()
                  .getStatus(data[index].status.toString());
              return Column(
                children: [
                  RequestCourseCard(
                    courseId: data[index].id,
                    image: data[index].course.image,
                    courseTitle: data[index].course.name ?? '',
                    price: data[index].course.price,
                    name:
                        "${data[index].course.provider.title} ${data[index].course.provider.firstName} ${data[index].course.provider.lastName}",
                    attendance: attendanceType,
                    id: data[index].course.id!,
                    acceptanceCheck: status,
                  ),
                  const Space(
                    boxHeight: 15,
                  ),
                ],
              );
            });
  }
}
