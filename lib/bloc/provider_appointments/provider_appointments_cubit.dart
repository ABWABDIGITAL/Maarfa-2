import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/model/common/courses/course_model.dart';
import 'package:my_academy/model/common/lessons/lesson_model.dart';
import 'package:my_academy/repository/provider/lessons/lessons_repository.dart';
import '../../repository/provider/courses/courses_repository.dart';

part 'provider_appointments_state.dart';

class ProviderAppointmentsCubit extends Cubit<ProviderAppointmentsState> {
  ProviderAppointmentsCubit() : super(ProviderAppointmentsInitial());
  CoursesRepository coursesRepository = CoursesRepository();
  ProviderLessonsRepository lessonRepository = ProviderLessonsRepository();
  static ProviderAppointmentsCubit get(BuildContext context) =>
      BlocProvider.of(context);
  bool isSubject = false;
  int page = 1;
  List<CourseModel> courseModel = [];
  List<LessonDetails> lessonModel = [];

  String status = "";

  changeFilter(String state) {
    page = 1;
    courseModel = [];
    lessonModel = [];
    if (status == state) {
      status = state;
      emit(SameFilterState());
    } else {
      status = state;
      emit(DifferrentFilterState());
    }
    emit(ChangeStatusState());
  }

  clearFilter(type) {
    status = "";
    page = 1;
    if (type == 'lesson') {
      getLessons("");
    } else {
      getCourses("");
    }
    Get.back();
    emit(EmptyFilterState());
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

  initLesson(data) {
    page == 1 ? lessonModel = data : lessonModel.addAll(data.data.items);
    emit(InitialLessonState());
  }

  getLessons(lessonStatus) async {
    if (state is ProviderLessonsLoadingState) return;
    final currentState = state;
    var oldLessons = <LessonDetails>[];
    if (currentState is ProviderLessonsLoadedState) {
      oldLessons = currentState.data;
      lessonModel = currentState.data;
    }
    emit(ProviderLessonsLoadingState(oldLessons, isFirstFetch: page == 1));
    lessonRepository
        .getAppointmentsLessons(page, lessonStatus)
        .then((newLessons) {
      lessonModel.addAll(newLessons.data.lessons);
      if (newLessons.data.pagination.hasMorePages == true) {
        page++;
        // lessonModel.addAll(newLessons.data.lessons);
        lessonRepository.getAppointmentsLessons(page, lessonStatus).then((v) {
          lessonModel.addAll(v.data.lessons);
          emit(ProviderLessonsLoadedState(lessonModel));
        });
      }
      emit(ProviderLessonsLoadedState(lessonModel));
    });
  }

  getLessonsCache(lessonStatus) async {
    lessonRepository.getAppointmentsLessonsCache(lessonStatus).then((v) {
      lessonModel.addAll(v.data.lessons);
      emit(ProviderLessonsLoadedState(lessonModel));
    });
  }

  initCourse(data) {
    page == 1 ? courseModel = data : courseModel.addAll(data.data.courses);
    emit(InitialCourseState());
  }

  getCourses(courseStatus) async {
    if (state is ProviderCourseLoadingState) return;
    final currentState = state;
    var oldRequests = <CourseModel>[];
    if (currentState is ProviderCourseLoadedState) {
      oldRequests = currentState.data;
      courseModel = currentState.data;
    }
    emit(ProviderCourseLoadingState(oldRequests, isFirstFetch: page == 1));
    coursesRepository.getCourses(courseStatus, page).then((newRequests) {
      page++;
      courseModel.addAll(newRequests.data.courses);
      if (newRequests.data.pagination.hasMorePages == true) {
        // courseModel.addAll(newRequests.data.courses);
        coursesRepository.getCourses(status, page).then((v) {
          courseModel.addAll(v.data.courses);
          emit(ProviderCourseLoadedState(data: courseModel));
        });
      }
      emit(ProviderCourseLoadedState(data: courseModel));
    });
  }

  getCoursesCache() async {
    coursesRepository.getCoursesCache(status).then((v) {
      courseModel.addAll(v.data.courses);
      emit(ProviderCourseLoadedState(data: courseModel));
    });
  }

  getFilteredCoursesHandler() {
    page = 1;
    courseModel = [];
    if (status == "") {
      getCourses("");
    } else if (status == 'comming') {
      getCourses("comming");
      emit(CourseCommingState());
    } else {
      getCourses("finished");
      emit(CourseFinishedState());
    }
    emit(CourseState());
  }

  getFilteredLessonsHandler() {
    page = 1;
    lessonModel = [];
    if (status == "") {
      getLessons("");
    } else if (status == 'comming') {
      getLessons("comming");
      emit(LessonCommingState());
    } else {
      getLessons("finished");
      emit(LessonFinishedState());
    }
    emit(LessonState());
  }
}
