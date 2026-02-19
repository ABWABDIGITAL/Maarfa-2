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
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 4.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: bloc.bookmarkLesson == null
                              ? data.length
                              : bloc.bookmarkLesson!.length,
                          itemBuilder: (context, index) => SubjectCard(
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
