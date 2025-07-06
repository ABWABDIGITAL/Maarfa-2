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
import '../../../widget/space/space.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/my_requests/request_subject_card.dart';
import 'request_subject_cache_view.dart';

class RequestsSubjectView extends StatelessWidget {
  const RequestsSubjectView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AllRequestsCubit(AllRequestsRepository())..getLessonRequests(),
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
                return const RequestsSubjectCacheView();
              }
            },
          );
        },
      ),
    );
  }
}

Widget requestsLessonView(
  BuildContext context,
  List<RequestModel> data,
) {
  if (data.isEmpty) {
    return Container(
      width: screenWidth,
      height: screenHeight * 2 / 3,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Enhanced empty state
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: mainColor.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                EmptyScreen(
                  title: tr("no_requests"),
                  image: emptyCurrent,
                  width: screenWidth * 0.6,
                  height: 200.h,
                  color: mainColor.withValues(alpha: 0.3),
                ),
                Space(boxHeight: 16.h),
                Text(
                  tr("no_requests_subtitle"),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                Space(boxHeight: 20.h),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to browse lessons or make a request
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 18.sp),
                      Space(boxWidth: 8.w),
                      Text(tr("browse_lessons")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return Container(
    color: Colors.grey[50], // Subtle background
    child: Column(
      children: [
        // Header section with statistics
        _buildHeaderSection(data),

        // Requests list
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return RequestSubjectCard(
                        lessonId: data[index].id!,
                        price: data[index].lesson!.hourPrice!,
                        lessonTitle: data[index].lesson!.subject!.name!,
                        name: data[index].lesson!.provider!.firstName!,
                        id: data[index].lesson!.subject!.id!,
                        onlineCheck: data[index].status.toString(),
                        acceptanceCheck: _getStatusText(data[index].status),
                        onTap: () {},
                      );
                    },
                    childCount: data.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildHeaderSection(List<RequestModel> data) {
  final pendingCount = data.where((item) => item.status == 1).length;
  final acceptedCount = data.where((item) => item.status == 2).length;
  final rejectedCount = data.where((item) => item.status == 3).length;
  final paidCount = data.where((item) => item.status == 4).length;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.assignment,
              color: mainColor,
              size: 20.sp,
            ),
            Space(boxWidth: 8.w),
            Text(
              tr("my_requests_summary"),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "${data.length} ${tr("total")}",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Space(boxHeight: 12.h),

        // Status statistics
        Row(
          children: [
            Expanded(
                child: _buildStatusStat(
                    tr("pending"), pendingCount, Colors.orange)),
            Expanded(
                child: _buildStatusStat(
                    tr("accepted"), acceptedCount, Colors.green)),
            Expanded(
                child: _buildStatusStat(
                    tr("rejected"), rejectedCount, Colors.red)),
            Expanded(
                child: _buildStatusStat(tr("paid"), paidCount, Colors.blue)),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatusStat(String label, int count, Color color) {
  return Column(
    children: [
      Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Space(boxHeight: 4.h),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

String _getStatusText(int? status) {
  switch (status) {
    case 1:
      return tr("pending");
    case 2:
      return tr("accepted");
    case 3:
      return tr("rejected");
    case 4:
      return tr("paid");
    default:
      return tr("unknown");
  }
}
//
// class RequestsSubjectView extends StatelessWidget {
//   const RequestsSubjectView({super.key});
//
//   @override
//   Widget build(final BuildContext context) {
//     return BlocProvider(
//         create: (BuildContext context) =>
//             AllRequestsCubit(AllRequestsRepository())..getLessonRequests(),
//         child: BlocConsumer<AllRequestsCubit, AllRequestsState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return BlocBuilder<AllRequestsCubit, AllRequestsState>(
//                   builder: (context, state) {
//                 if (state is LessonRequestsLoadedState) {
//                   final data = state.data;
//                   return requestsLessonView(context, data!);
//                 } else if (state is LessonRequestsLoadErrorState) {
//                   return const ErrorPage();
//                 } else {
//                   return const RequestsSubjectCacheView();
//                 }
//               });
//             }));
//   }
// }
//
// requestsLessonView(
//   BuildContext context,
//   List<RequestModel> data,
// ) {
//   return data.isEmpty
//       ? SizedBox(
//           width: screenWidth,
//           height: screenHeight * 2 / 3,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               EmptyScreen(
//                 title: tr("no_requests"),
//                 image: emptyCurrent,
//                 width: screenWidth,
//                 height: 300.h,
//                 color: mainColor.withValues(alpha:0.3),
//               ),
//             ],
//           ),
//         )
//       : CustomList(
//           listHeight: 100000000000000,
//           listWidth: screenWidth,
//           scroll: const ClampingScrollPhysics(),
//           axis: Axis.vertical,
//           count: data.length,
//           child: (context, index) {
//             // final status = context
//             //     .read<AllRequestsCubit>()
//             //     .getStatus(data[index].status.toString());
//             return Column(
//               children: [
//                 RequestSubjectCard(
//                   lessonId: data[index].id!,
//                   price: data[index].lesson!.hourPrice!,
//                   lessonTitle: data[index].lesson!.subject!.name!,
//                   name: data[index].lesson!.provider!.firstName!,
//                   id: data[index].lesson!.subject!.id!,
//                   onlineCheck: data[index].status.toString(),
//                   acceptanceCheck: data[index].status == 1
//                       ? tr("pending")
//                       : data[index].status == 2
//                           ? tr("accepted")
//                           : data[index].status == 3
//                               ? tr("rejected")
//                               : tr("paid"),
//                   onTap: () {},
//                 ),
//                 const Space(
//                   boxHeight: 15,
//                 ),
//               ],
//             );
//           });
// }
