import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/model/provider/requests/requests_model/requests_model.dart';
import 'package:my_academy/repository/provider/requests/requests_repository.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../model/common/courses/course_model.dart';
import '../../model/common/lessons/lesson_model.dart';
import '../../service/notification/notification_event_bus.dart';

part 'provider_requests_state.dart';

class ProviderRequestsCubit extends Cubit<ProviderRequestsState> {
  ProviderRequestsCubit(this.requestsProvider)
      : super(ProviderRequestsInitial()) {
    _notificationSubscription =
        NotificationEventBus.instance.stream.listen(_onNotification);
  }

  RequestsProvider requestsProvider;
  StreamSubscription<NotificationEvent>? _notificationSubscription;

  static ProviderRequestsCubit get(BuildContext context) =>
      BlocProvider.of(context);
  int page = 1;
  List<Request> requestModel = [];
  List<LessonDetails> lessonModel = [];
  List<CourseModel> courseModel = [];
  bool isSubject = false;
  RoundedLoadingButtonController acceptController =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController rejectControl =
      RoundedLoadingButtonController();
  final TextEditingController rejectController = TextEditingController();

  void _onNotification(NotificationEvent event) {
    if (['new_request', 'request_paid'].contains(event.type)) {
      page = 1;
      courseModel = [];
      lessonModel = [];
      getRequests();
      getLessonsRequests();
    }
  }

  initCourse(data) {
    page == 1 ? courseModel = data : courseModel.addAll(data.data.items);
    emit(InitialCourseState());
  }

  getRequests() async {
    if (state is ProviderRequestsLoadingState) return;
    final currentState = state;
    var oldRequests = <CourseModel>[];
    if (currentState is ProviderRequestsLoadedState) {
      oldRequests = currentState.data;
      courseModel = currentState.data;
    }
    emit(ProviderRequestsLoadingState(oldRequests, isFirstFetch: page == 1));
    requestsProvider.getItemsHasRequest("course", page).then((newRequests) {
      page++;
      courseModel.addAll(newRequests.data.items);
      if (newRequests.data.pagination.hasMorePages == true) {
        requestsProvider.getItemsHasRequest("course", page).then((v) {
          courseModel.addAll(v.data.items);
          emit(ProviderRequestsLoadedState(data: courseModel));
        });
      }
      emit(ProviderRequestsLoadedState(data: courseModel));
    });
  }

  initLesson(data) {
    page == 1 ? lessonModel = data : lessonModel.addAll(data.data.items);
    emit(InitialLessonState());
  }

  getLessonsRequests() async {
    if (state is ProviderLessonRequestsLoadingState) return;
    final currentState = state;
    var oldRequests = <LessonDetails>[];
    if (currentState is ProviderLessonRequestsLoadedState) {
      oldRequests = currentState.data;
      lessonModel = currentState.data;
    }
    emit(ProviderLessonRequestsLoadingState(oldRequests,
        isFirstFetch: page == 1));
    requestsProvider.getItemsHasRequest("lesson", page).then((newRequests) {
      page++;
      lessonModel.addAll(newRequests.data.items);
      if (newRequests.data.pagination.hasMorePages == true) {
        requestsProvider.getItemsHasRequest("lesson", page).then((v) {
          lessonModel.addAll(v.data.items);
          emit(ProviderLessonRequestsLoadedState(data: lessonModel));
        });
      }
      emit(ProviderLessonRequestsLoadedState(data: lessonModel));
    });
  }

  getLessonsRequestsCache() async {
    requestsProvider.getItemsHasRequestCache("lesson").then((v) {
      lessonModel.addAll(v.data.items);
      emit(ProviderLessonRequestsLoadedState(data: lessonModel));
    });
  }

  getCoursesRequestsCache() async {
    requestsProvider.getItemsHasRequestCache("course").then((v) {
      courseModel.addAll(v.data.items);
      emit(ProviderRequestsLoadedState(data: courseModel));
    });
  }

  initDetails(data) {
    page == 1 ? requestModel = data : requestModel.addAll(data.data.requests);
    emit(InitialRequestState());
  }

  showRequestsDetails(String type, int id) async {
    if (state is ProviderShowRequestsLoadingState) return;
    final currentState = state;
    var requests = <Request>[];
    if (currentState is ProviderShowRequestsLoadedState) {
      requests = currentState.data;
      requestModel = currentState.data;
    }
    emit(ProviderShowRequestsLoadingState(requests, isFirstFetch: page == 1));
    requestsProvider.getItemsRequestDetails(type, id, page).then((newRequests) {
      page++;
      requestModel.addAll(newRequests.data.requests);
      if (newRequests.data.pagination.hasMorePages == true) {
        requestsProvider.getItemsRequestDetails(type, id, page).then((v) {
          requestModel.addAll(v.data.requests);
          emit(ProviderShowRequestsLoadedState(data: requestModel));
        });
      }
      emit(ProviderShowRequestsLoadedState(data: requestModel));
    });
  }

  acceptRequest(int id) {
    Map<String, dynamic> data = {
      "status": 2,
    };
    requestsProvider.changeRequestStatus(id, data).then((value) {
      acceptController.reset();
      emit(RequestStatusChangedState());
    });
  }

  rejectRequest(int id, type) {
    Map<String, dynamic> data = {
      "status": 3,
      "reject_reason": rejectController.text,
    };
    requestsProvider.changeRequestStatus(id, data).then((value) {
      rejectControl.reset();
      emit(RequestStatusChangedState());
    });
  }

  chooseCourseSubject(state) {
    switch (state == true) {
      case true:
        isSubject = true;
        emit(ChooseSubjectState());
        break;
      case false:
        isSubject = false;
        emit(ChooseCourseState());
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
