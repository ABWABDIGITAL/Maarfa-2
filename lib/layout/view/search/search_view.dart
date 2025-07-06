import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/search_bloc/search_bloc.dart';
import '../../../model/common/search/search_db_response.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/search/search_result.dart';
import '../../../widget/space/space.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: BlocProvider.of<SearchBloc>(context),
      builder: (BuildContext context, SearchState state) {
        if (state is SearchInitial) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Space(
                boxHeight: screenHeight / 4,
              ),
              Icon(
                Icons.search_off_rounded,
                color: mainColor.withValues(alpha: 0.5),
                size: 150.h,
              ),
              Text(tr("no_search"),
                  style: TextStyles.appBarStyle
                      .copyWith(color: mainColor.withValues(alpha: 0.5))),
            ],
          );
        } else if (state is SearchLoadingState) {
          return const Loading();
        } else if (state is SearchErrorState) {
          return Text(state.error);
        } else {
          final success = state as SearchLoadedState;
          return success.data.courses!.isEmpty && success.data.lessons!.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Space(
                      boxHeight: screenHeight / 4,
                    ),
                    Icon(
                      Icons.search_off_rounded,
                      color: mainColor.withValues(alpha: 0.5),
                      size: 150.h,
                    ),
                    Text(tr("no_result"),
                        style: TextStyles.appBarStyle
                            .copyWith(color: mainColor.withValues(alpha: 0.5))),
                  ],
                )
              : SearchResult(data: success.data);
        }
      },
    );
    // return BlocProvider(
    //     create: (BuildContext context) => SearchCubit()..getSearchedItems(""),
    //     child: BlocConsumer<SearchCubit, SearchState>(
    //         listener: (context, state) {},
    //         builder: (context, state) {
    //           return BlocBuilder<SearchCubit, SearchState>(
    //               builder: (context, state) {
    //             if (state is SearchLoaded) {
    //               final courses = state.courses;
    //               final lessons = state.lessons;
    //               return searchView(courses: courses, lessons: lessons);
    //             } else if (state is SearchError) {
    //               return const ErrorPage();
    //             } else {
    //               return const Loading();
    //             }
    //           });
    //         }));
  }

  searchView({
    List<SearchCourse>? courses,
    List<SearchLesson>? lessons,
  }) {
    // return BlocProvider(
    //   create: (BuildContext context) => SearchCubit()
    //     ..initCourses(courses)
    //     ..initBookMarkCourse(courses)
    //     ..initBookMarkLesson(lessons),
    //   child: BlocConsumer<SearchCubit, SearchState>(
    //     listener: (context, state) {},
    //     builder: (context, state) {
    //       final bloc = SearchCubit.get(context);
    //       return SizedBox(
    //         width: screenWidth,
    //         height: screenHeight,
    //         child: Column(
    //           children: [
    //             CustomList(
    //               listHeight: 100000000000000,
    //               listWidth: screenWidth,
    //               scroll: const NeverScrollableScrollPhysics(),
    //               axis: Axis.vertical,
    //               count: bloc.lessonsModel == null
    //                   ? lessons!.length
    //                   : bloc.lessonsModel!.length,
    //               child: (context, index) => Column(
    //                 children: [
    //                   SubjectCard(
    //                     onTap: () {
    //                       bloc.bookmarkLesson(index);
    //                       BlocProvider.of<BookmarkCubit>(context).addToBookMark(
    //                           id: lessons![index].id!, type: 'lesson');
    //                     },
    //                     isBlue: bloc.lessonList[index],
    //                     lessonDetails: bloc.lessonsModel == null
    //                         ? lessons![index]
    //                         : bloc.lessonsModel![index],
    //                     yearId: null,
    //                     stageId: null,
    //                   ),
    //                   const Space(
    //                     boxHeight: 15,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             CustomList(
    //                 listHeight: 100000000000000,
    //                 listWidth: screenWidth,
    //                 scroll: const NeverScrollableScrollPhysics(),
    //                 axis: Axis.vertical,
    //                 count: bloc.coursesModel!.length,
    //                 child: (context, index) => Column(
    //                       children: [
    //                         CourseCard(
    //                           favoriteTap: () {
    //                             bloc.bookmarkCourse(index);
    //                             BlocProvider.of<BookmarkCubit>(context)
    //                                 .addToBookMark(
    //                                     id: bloc.coursesModel![index].id!,
    //                                     type: 'course');
    //                           },
    //                           isBlue: bloc.courseList[index],
    //                           id: bloc.coursesModel![index].id,
    //                           onPress: () => Get.to(
    //                             CourseRegistration(
    //                                 id: bloc.coursesModel![index].id!),
    //                           ),
    //                           courseModel: bloc.coursesModel![index],
    //                         ),
    //                         const Space(
    //                           boxHeight: 15,
    //                         ),
    //                       ],
    //                     )),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
