import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_academy/repository/user/all_requests/all_requests_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user/lesson_requests/lesson_requests_model.dart';
import '../../model/user/request_details/request_details_model.dart';
import '../../service/notification/notification_event_bus.dart';

part 'all_requests_state.dart';

class AllRequestsCubit extends Cubit<AllRequestsState> {
  AllRequestsCubit(this.allRequestsRepository) : super(AllRequestsInitial()) {
    _notificationSubscription =
        NotificationEventBus.instance.stream.listen(_onNotification);
  }

  AllRequestsRepository allRequestsRepository;
  StreamSubscription<NotificationEvent>? _notificationSubscription;

  void _onNotification(NotificationEvent event) {
    if (['request_accepted', 'request_canceled', 'pay_request', 'request_sent']
        .contains(event.type)) {
      _invalidateCache();
      getCourseRequests();
      getLessonRequests();
    }
  }

  Future<void> _invalidateCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('requests_course');
    prefs.remove('requests_lesson');
  }

  getCourseRequests() {
    allRequestsRepository.coursesRequests().then((value) {
      if (value != null && value.data != null) {
        emit(CourseRequestsLoadedState(data: value.data.requests));
      } else {
        emit(CourseRequestsLoadErrorState());
      }
    });
  }

  getCourseRequestsCache() {
    allRequestsRepository.coursesRequestsCache().then((value) {
      if (value != null && value.data != null) {
        emit(CourseRequestsLoadedState(data: value.data.requests));
      }
    });
  }

  getLessonRequests() {
    allRequestsRepository.lessonsRequests().then((value) {
      if (value != null && value.data != null) {
        emit(LessonRequestsLoadedState(data: value.data.requests));
      } else {
        emit(LessonRequestsLoadErrorState());
      }
    });
  }

  getLessonRequestsCache() {
    allRequestsRepository.lessonsRequestsCache().then((value) {
      if (value != null && value.data != null) {
        emit(LessonRequestsLoadedState(data: value.data.requests));
      }
    });
  }

  String getStatus(String status) {
    if (status == '1') {
      return tr("pending");
    } else if (status == '2') {
      return tr("accepted");
    } else if (status == '3') {
      return tr("rejected");
    } else if (status == '4') {
      return tr("paid");
    }
    return tr("unknown");
  }

  String getAttendanceType(String status) {
    if (status == '1') {
      return tr("offline");
    } else if (status == '2') {
      return tr("live");
    } else if (status == '3') {
      return tr("online");
    }
    return 'Online';
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
