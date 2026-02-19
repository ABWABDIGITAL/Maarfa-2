part of 'provider_requests_cubit.dart';

@immutable
abstract class ProviderRequestsState {}

class ProviderRequestsInitial extends ProviderRequestsState {}

class ProviderRequestsLoadingState extends ProviderRequestsState {
  final List<CourseModel> oldRequests;
  final bool isFirstFetch;

  ProviderRequestsLoadingState(this.oldRequests, {this.isFirstFetch = false});
}

class ProviderRequestsLoadedState extends ProviderRequestsState {
  final List<CourseModel> data;
  ProviderRequestsLoadedState({required this.data});
}

class ProviderLessonRequestsLoadingState extends ProviderRequestsState {
  final List<LessonDetails> data;
  final bool isFirstFetch;
  ProviderLessonRequestsLoadingState(this.data, {this.isFirstFetch = false});
}

class ProviderLessonRequestsLoadedState extends ProviderRequestsState {
  final List<LessonDetails> data;
  // final RequestModel? data;
  ProviderLessonRequestsLoadedState({required this.data});
}

class ProviderRequestsErrorState extends ProviderRequestsState {}

class ChooseSubjectState extends ProviderRequestsState {}

class ChooseCourseState extends ProviderRequestsState {}

class ProviderShowRequestsInitial extends ProviderRequestsState {}

class ProviderShowRequestsLoadingState extends ProviderRequestsState {
  final List<Request> requests;
  final bool isFirstFetch;
  ProviderShowRequestsLoadingState(this.requests, {this.isFirstFetch = false});
}

class ProviderShowRequestsLoadedState extends ProviderRequestsState {
  final List<Request> data;
  ProviderShowRequestsLoadedState({required this.data});
}

class InitialCourseState extends ProviderRequestsState {}

class InitialLessonState extends ProviderRequestsState {}

class InitialRequestState extends ProviderRequestsState {}

class RequestStatusChangedState extends ProviderRequestsState {}
