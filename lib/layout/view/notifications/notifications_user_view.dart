import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/notifications/notifications_cubit.dart';
import 'package:my_academy/model/user/notification_user/notification_user_model.dart';
import 'package:my_academy/repository/common/notifications/notifications_repository.dart';

import '../../../res/drawable/image/images.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/notifications_card/notifications_card.dart';

class NotificationsUserView extends StatelessWidget {
  const NotificationsUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          NotificationsCubit(NotificationsRepository())..getNotificationsUser(),
      child: BlocConsumer<NotificationsCubit, NotificationsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
            if (state is NotificationsUserLoadedState) {
              final data = (state).data;
              return notificationUserView(data: data);
            } else if (state is NotificationsUserErrorState) {
              return const ErrorPage();
            } else {
              return const Loading();
            }
          });
        },
      ),
    );
  }

  notificationUserView({
    required NotificationUserModel data,
  }) {
    // CourseSubjectCubit courseSubjectCubit =
    // CourseSubjectCubit(CoursesRepository());
    return data.notifications.isEmpty
        ? SizedBox(
            width: screenWidth,
            height: screenHeight * 2 / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EmptyScreen(
                  title: tr("no_notification"),
                  image: notifications,
                  width: screenWidth,
                  height: 300.h,
                  // color: mainColor.withValues(alpha:0.3),
                ),
              ],
            ),
          )
        : CustomList(
            child: (context, index) => NotificationsCard(
              data: data.notifications[index],
            ),
            axis: Axis.vertical,
            listHeight: screenHeight,
            count: data.notifications.length,
          );
  }
}
