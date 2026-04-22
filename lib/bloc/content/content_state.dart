part of 'content_cubit.dart';

abstract class ContentState {}

class ContentInitial extends ContentState {}

class SameContentState extends ContentState {}

class DifferentContentState extends ContentState {}

class ChangeContentState extends ContentState {}

class SameGradeState extends ContentState {}

class DifferentGradeState extends ContentState {}

class ChooseGradeState extends ContentState {}

class SameYearState extends ContentState {}

class DifferentYearState extends ContentState {}

class ChooseYearState extends ContentState {}

class SameSpecializationState extends ContentState {}

class DifferentSpecializationState extends ContentState {}

class ChooseSpecializationState extends ContentState {}

class SameSubjectState extends ContentState {}

class DifferentSubjectState extends ContentState {}

class ChooseSubjectState extends ContentState {}

class ChooseDateState extends ContentState {}

class AddDateState extends ContentState {}

class DateFoundState extends ContentState {}

class UpdateDateListState extends ContentState {}

class DeleteDateState extends ContentState {}

class AddLessonState extends ContentState {}

class AddCourseState extends ContentState {}

class ValidateEmptyState extends ContentState {}

class ValidateNotEmptyState extends ContentState {}

class ValidateState extends ContentState {}

class LessonsLoadedState extends ContentState {
  final List<LessonDetails> lessons;
  LessonsLoadedState(this.lessons);
}

class LessonsLoadingState extends ContentState {
  final List<LessonDetails> oldLessons;
  final bool isFirstFetch;
  LessonsLoadingState(this.oldLessons, {this.isFirstFetch = false});
}

class CoursesLoadedState extends ContentState {
  final List<CourseModel> courses;
  CoursesLoadedState(this.courses);
}

class CoursesLoadingState extends ContentState {
  final List<CourseModel> oldCourses;
  final bool isFirstFetch;
  CoursesLoadingState(this.oldCourses, {this.isFirstFetch = false});
}

class ShowTableState extends ContentState {}

class HideTableState extends ContentState {}

class ChangeTableState extends ContentState {}

class UnselectDaysState extends ContentState {}

class SelectDayState extends ContentState {}

class SetDaysState extends ContentState {}

class ChooseStartDateState extends ContentState {}

class ChooseEndDateState extends ContentState {}

class ChooseStartTimeState extends ContentState {}

class ChooseEndTimeState extends ContentState {}

class PickInitState extends ContentState {}

class PickPictureState extends ContentState {}

class AddSkillsState extends ContentState {}

class SameSystemState extends ContentState {}

class DifferrentSystemState extends ContentState {}

class SetCourseSystemState extends ContentState {}

class SetCourseCategoryState extends ContentState {}

class SetCourseSubTypeState extends ContentState {}

class SameTypeState extends ContentState {}

class DifferrentTypeState extends ContentState {}

class SetCourseTypeState extends ContentState {}

class RemoveSkillState extends ContentState {}

class ClearCourseDataState extends ContentState {}

class InitAddressData extends ContentState {}

class EducationalYearsLoadedState extends ContentState {
  List<EducationalYearModel> data;

  EducationalYearsLoadedState({required this.data});
}

class EducationalYearsErrorState extends ContentState {}

class InitYearsState extends ContentState {}

class SubjectLoadedState extends ContentState {
  List<SubjectModel> data;

  SubjectLoadedState({required this.data});
}

class SubjectErrorState extends ContentState {}

class InitSubjectState extends ContentState {}

class InitialCourseState extends ContentState {}
