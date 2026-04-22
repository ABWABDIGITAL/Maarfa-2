import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/common/video_courses/video_course_model.dart';
import '../../model/common/video_courses/video_courses_db_response.dart';
import '../../repository/provider/video_courses/provider_video_course_repository.dart';

part 'provider_video_course_state.dart';

class ProviderVideoCourseCubit extends Cubit<ProviderVideoCourseState> {
  ProviderVideoCourseCubit() : super(ProviderVideoCourseInitial());

  ProviderVideoCourseRepository repository = ProviderVideoCourseRepository();

  static ProviderVideoCourseCubit get(BuildContext context) =>
      BlocProvider.of(context);

  List<VideoCourseModel> myCourses = [];

  getMyVideoCourses() async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.getMyVideoCourses();
      if (result != null && result is VideoCoursesDbResponse) {
        myCourses = result.data?.videoCourses ?? [];
        emit(ProviderVideoCoursesLoadedState(myCourses));
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  createVideoCourse(Map<String, dynamic> data) async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.createVideoCourse(data);
      if (result != null) {
        emit(ProviderVideoCourseCreatedState());
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  updateVideoCourse(int id, Map<String, dynamic> data) async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.updateVideoCourse(id, data);
      if (result != null) {
        emit(ProviderVideoCourseUpdatedState());
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  deleteVideoCourse(int id) async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.deleteVideoCourse(id);
      if (result != null) {
        emit(ProviderVideoCourseDeletedState());
        getMyVideoCourses();
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  addUnit(int courseId, File video, Map<String, dynamic> data) async {
    emit(ProviderVideoUnitUploadingState());
    try {
      final result = await repository.addUnit(courseId, video, data);
      if (result != null) {
        emit(ProviderVideoUnitAddedState());
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  addUnitWithUrl(int courseId, Map<String, dynamic> data) async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.addUnitWithUrl(courseId, data);
      if (result != null) {
        emit(ProviderVideoUnitAddedState());
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  updateUnit(int id, Map<String, dynamic> data) async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.updateUnit(id, data);
      if (result != null) {
        emit(ProviderVideoCourseUpdatedState());
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }

  deleteUnit(int id) async {
    emit(ProviderVideoCourseLoadingState());
    try {
      final result = await repository.deleteUnit(id);
      if (result != null) {
        emit(ProviderVideoUnitDeletedState());
      } else {
        emit(ProviderVideoCourseErrorState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ProviderVideoCourseErrorState());
    }
  }
}
