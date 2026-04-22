part of 'provider_video_course_cubit.dart';

abstract class ProviderVideoCourseState {}

class ProviderVideoCourseInitial extends ProviderVideoCourseState {}

class ProviderVideoCourseLoadingState extends ProviderVideoCourseState {}

class ProviderVideoCoursesLoadedState extends ProviderVideoCourseState {
  final List<VideoCourseModel> courses;
  ProviderVideoCoursesLoadedState(this.courses);
}

class ProviderVideoCourseErrorState extends ProviderVideoCourseState {
  final String? message;
  ProviderVideoCourseErrorState({this.message});
}

class ProviderVideoCourseCreatedState extends ProviderVideoCourseState {}

class ProviderVideoCourseUpdatedState extends ProviderVideoCourseState {}

class ProviderVideoCourseDeletedState extends ProviderVideoCourseState {}

class ProviderVideoUnitAddedState extends ProviderVideoCourseState {}

class ProviderVideoUnitUploadingState extends ProviderVideoCourseState {
  ProviderVideoUnitUploadingState();
}

class ProviderVideoUnitDeletedState extends ProviderVideoCourseState {}
