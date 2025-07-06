import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../model/common/lessons/lesson_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../card_view/subject/subject_card.dart';
import 'bookmarks_lesson_cache_view.dart';

class BookmarksLessonView extends StatelessWidget {
  const BookmarksLessonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BookmarkCubit()..getBookmarkLessons(),
      child: BlocConsumer<BookmarkCubit, BookmarkState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BookmarkLessonsLoadedState) {
            // final bloc = BookmarkCubit.get(context);
            return bookMarkLessonsView(data: (state).data);
          } else if (state is BookmarkLessonsErrorState) {
            return const ErrorPage();
          } else {
            return const BookmarksLessonCacheView();
          }
        },
      ),
    );
  }

  bookMarkLessonsView({
    required List<LessonDetails> data,
  }) {
    return BlocProvider(
        create: (BuildContext context) =>
            BookmarkCubit()..initBookMarkLesson(data),
        child: BlocConsumer<BookmarkCubit, BookmarkState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = BookmarkCubit.get(context);
              return data.isEmpty
                  ? SizedBox(
                      width: screenWidth,
                      height: screenHeight * 2 / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmptyScreen(
                            title: tr("no_bookmark"),
                            image: emptyCurrent,
                            width: screenWidth,
                            height: 300.h,
                            color: mainColor.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    )
                  : bloc.bookmarkLesson != null && bloc.bookmarkLesson!.isEmpty
                      ? SizedBox(
                          width: screenWidth,
                          height: screenHeight * 2 / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              EmptyScreen(
                                title: tr("no_bookmark"),
                                image: emptyCurrent,
                                width: screenWidth,
                                height: 300.h,
                                color: mainColor.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        )
                      : CustomList(
                          listHeight: 100000000000000,
                          listWidth: screenWidth,
                          scroll: const NeverScrollableScrollPhysics(),
                          axis: Axis.vertical,
                          count: bloc.bookmarkLesson == null
                              ? data.length
                              : bloc.bookmarkLesson!.length,
                          child: (context, index) => SubjectCard(
                            isUser: true,
                            onTap: () {
                              bloc.addToBookMark(
                                  id: bloc.bookmarkLesson == null
                                      ? data[index].id!
                                      : bloc.bookmarkLesson![index].id!,
                                  type: 'lesson');
                              bloc.bookmark(bloc.bookmarkLesson == null
                                  ? data[index]
                                  : bloc.bookmarkLesson![index]);
                            },
                            isBlue: bloc.bookmarkLesson == null
                                ? data[index].isBookmarked!
                                : bloc.bookmarkLesson![index].isBookmarked!,
                            lessonDetails: bloc.bookmarkLesson == null
                                ? data[index]
                                : bloc.bookmarkLesson![index],
                          ),
                        );
            }));
  }
}
