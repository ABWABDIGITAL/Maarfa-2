import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/notifications/notifications_cubit.dart';
import 'package:my_academy/model/user/notification_user/notification_user_model.dart';
import 'package:my_academy/repository/common/notifications/notifications_repository.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../../../model/common/notifications/notification_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/notifications_card/notifications_card.dart';

class NotificationsUserView extends StatelessWidget {
  const NotificationsUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsCubit(NotificationsRepository())..getNotificationsUser(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsUserLoadedState) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationsCubit>().getNotificationsUser(),
              color: mainColor,
              backgroundColor: Colors.white,
              child: _NotificationsContent(data: state.data),
            );
          } else if (state is NotificationsUserErrorState) {
            return const ErrorPage();
          }
          return const Loading();
        },
      ),
    );
  }
}

class _NotificationsContent extends StatelessWidget {
  final NotificationUserModel data;
  const _NotificationsContent({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.notifications.isEmpty) {
      return SizedBox(
        width: screenWidth,
        height: screenHeight * 2 / 3,
        child: Center(
          child: EmptyScreen(
            title: tr('no_notification'),
            image: notifications,
            width: screenWidth,
            height: 300.h,
          ),
        ),
      );
    }

    final groups = _groupByDate(data.notifications);

    return ListView.builder(
      padding: EdgeInsets.only(top: 12.h, bottom: 32.h),
      itemCount: groups.length,
      itemBuilder: (context, i) {
        final group = groups[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, i == 0 ? 0 : 12.h, 18.w, 8.h),
              child: Text(
                group.label.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Shamel',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF707070),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            ...group.items.map(
              (n) => NotificationsCard(
                data: n,
                isRead: _isOlderThanDay(n),
              ),
            ),
          ],
        );
      },
    );
  }

  List<_DateGroup> _groupByDate(List<NotificationModel> list) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <NotificationModel>[];
    final yesterdayItems = <NotificationModel>[];
    final earlierItems = <NotificationModel>[];

    for (final n in list) {
      DateTime? dt;
      try {
        dt = DateTime.parse(n.createdAt ?? '');
      } catch (_) {}

      if (dt == null) {
        earlierItems.add(n);
      } else {
        final day = DateTime(dt.year, dt.month, dt.day);
        if (day == today) {
          todayItems.add(n);
        } else if (day == yesterday) {
          yesterdayItems.add(n);
        } else {
          earlierItems.add(n);
        }
      }
    }

    return [
      if (todayItems.isNotEmpty)
        _DateGroup(label: tr('today'), items: todayItems),
      if (yesterdayItems.isNotEmpty)
        _DateGroup(label: tr('yesterday'), items: yesterdayItems),
      if (earlierItems.isNotEmpty)
        _DateGroup(label: tr('earlier'), items: earlierItems),
    ];
  }

  bool _isOlderThanDay(NotificationModel n) {
    try {
      final dt = DateTime.parse(n.createdAt ?? '');
      return DateTime.now().difference(dt).inDays >= 1;
    } catch (_) {
      return true;
    }
  }
}

class _DateGroup {
  final String label;
  final List<NotificationModel> items;
  const _DateGroup({required this.label, required this.items});
}
