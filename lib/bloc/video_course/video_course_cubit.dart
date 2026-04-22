import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/common/video_courses/video_course_model.dart';
import '../../model/common/video_courses/video_courses_db_response.dart';
import '../../repository/common/video_courses/video_course_repository.dart';

part 'video_course_state.dart';

class VideoCourseCubit extends Cubit<VideoCourseState> {
  VideoCourseCubit() : super(VideoCourseInitial());

  VideoCourseRepository repository = VideoCourseRepository();

  static VideoCourseCubit get(BuildContext context) =>
      BlocProvider.of(context);

  List<VideoCourseModel> videoCourses = [];

  getVideoCourses() async {
    emit(VideoCourseLoadingState());
    try {
      final result = await repository.getVideoCourses();
      if (result != null && result is VideoCoursesDbResponse) {
        videoCourses = result.data?.videoCourses ?? [];
        emit(VideoCoursesLoadedState(videoCourses));
      } else {
        emit(VideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(VideoCourseErrorState());
    }
  }

  getVideoCourseDetails(int id) async {
    emit(VideoCourseLoadingState());
    try {
      final result = await repository.getVideoCourseDetails(id);
      if (result != null && result is VideoCourseDetailsDbResponse) {
        emit(VideoCourseDetailsLoadedState(result.data!));
      } else {
        emit(VideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(VideoCourseErrorState());
    }
  }

  purchaseCourse(int id) async {
    emit(VideoCoursePurchaseLoadingState());
    try {
      final result = await repository.purchaseCourse(id);
      if (result != null) {
        emit(VideoCoursePurchaseSuccessState());
        getVideoCourseDetails(id);
      } else {
        emit(VideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(VideoCourseErrorState());
    }
  }

  purchaseUnit(int unitId, int courseId) async {
    emit(VideoCoursePurchaseLoadingState());
    try {
      final result = await repository.purchaseUnit(unitId);
      if (result != null) {
        emit(VideoCoursePurchaseSuccessState());
        getVideoCourseDetails(courseId);
      } else {
        emit(VideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(VideoCourseErrorState());
    }
  }

  getStreamUrl(int unitId) async {
    try {
      final result = await repository.getStreamUrl(unitId);
      if (result != null) {
        final url = result["data"]?["stream_url"] ?? result["data"]?["url"] ?? "";
        emit(VideoStreamLoadedState(url.toString()));
      } else {
        emit(VideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(VideoCourseErrorState());
    }
  }
}
