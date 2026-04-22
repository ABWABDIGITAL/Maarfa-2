part of 'video_course_cubit.dart';

abstract class VideoCourseState {}

class VideoCourseInitial extends VideoCourseState {}

class VideoCourseLoadingState extends VideoCourseState {}

class VideoCoursesLoadedState extends VideoCourseState {
  final List<VideoCourseModel> courses;
  VideoCoursesLoadedState(this.courses);
}

class VideoCourseDetailsLoadedState extends VideoCourseState {
  final VideoCourseModel course;
  VideoCourseDetailsLoadedState(this.course);
}

class VideoCourseErrorState extends VideoCourseState {
  final String? message;
  VideoCourseErrorState({this.message});
}

class VideoCoursePurchaseSuccessState extends VideoCourseState {}

class VideoCoursePurchaseLoadingState extends VideoCourseState {}

class VideoStreamLoadedState extends VideoCourseState {
  final String streamUrl;
  VideoStreamLoadedState(this.streamUrl);
}
