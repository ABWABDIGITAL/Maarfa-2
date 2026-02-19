import 'package:flutter/cupertino.dart';
import 'package:my_academy/model/provider/notification_provider/notification_provider_response.dart';

import '../../../model/user/notification_user/notification_user_response.dart';
import '../../../service/network/dio/dio_service.dart';

class NotificationsRepository {
  providerNotifications() async {
    try {
      return await DioService()
          .get('/provider/auth/notifications')
          .then((value) => value.fold((l) {
                debugPrint('Provider notifications error: $l');
                return null;
              }, (r) {
                NotificationsProviderResponse notifications =
                    NotificationsProviderResponse.fromJson(r);
                return notifications;
              }));
    } catch (e) {
      debugPrint('Provider notifications exception: $e');
      return null;
    }
  }

  userNotifications() async {
    try {
      return await DioService()
          .get('/client/auth/notifications')
          .then((value) => value.fold((l) {
                debugPrint('User notifications error: $l');
                return null;
              }, (r) {
                NotificationsUserResponse notifications =
                    NotificationsUserResponse.fromJson(r);
                return notifications;
              }));
    } catch (e) {
      debugPrint('User notifications exception: $e');
      return null;
    }
  }
}
