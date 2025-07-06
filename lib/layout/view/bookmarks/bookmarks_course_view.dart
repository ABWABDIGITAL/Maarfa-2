import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../model/user/bookmarks/bookmark_course_db_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../activity/user_screens/course/course_registration.dart';
import '../../card_view/course/course_card.dart';
import 'bookmarks_course_cache_view.dart';

class BookmarksCourseView extends StatelessWidget {
  const BookmarksCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BookmarkCubit()..getBookmarkCourses(),
      child: BlocConsumer<BookmarkCubit, BookmarkState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BookmarkCoursesLoadedState) {
            // final bloc = BookmarkCubit.get(context);
            return bookMarkCoursesView(data: (state).data);
          } else if (state is BookmarkCoursesErrorState) {
            return const ErrorPage();
          } else {
            return const BookmarksCourseCacheView();
          }
        },
      ),
    );
  }

  bookMarkCoursesView({
    required List<BookmarkCoursesModel> data,
  }) {
    // return data.isEmpty
    //     ? Container()
    //     : CustomList(
    //   listHeight: 100000000000000,
    //   listWidth: screenWidth,
    //   scroll: const NeverScrollableScrollPhysics(),
    //   axis: Axis.vertical,
    //   count: data.length,
    //   child: (context, index) =>
    //   CourseCard(
    //     bookmarkCoursesModel: data[index],
    //     onPress: () {},
    //   ),
    // );
    return BlocProvider(
        create: (BuildContext context) =>
            BookmarkCubit()..initBookMarkCourse(data),
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
                  : bloc.bookmarkCourse != null && bloc.bookmarkCourse!.isEmpty
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
                          count: bloc.bookmarkCourse == null
                              ? data.length
                              : bloc.bookmarkCourse!.length,
                          child: (context, index) => CourseCard(
                            attendType: bloc.bookmarkCourse![index].type == 1
                                ? tr("offline")
                                : tr("online"),
                            isBlue: true,
                            favoriteTap: () {
                              // bloc.bookmark(bloc.bookmarkCourse == null
                              //     ? data[index]
                              //     : bloc.bookmarkCourse![index]);
                              BlocProvider.of<BookmarkCubit>(context)
                                  .addToBookMark(
                                      id: bloc.bookmarkCourse == null
                                          ? data[index].id!
                                          : bloc.bookmarkCourse![index].id!,
                                      type: "course");
                            },
                            bookmarkCoursesModel: bloc.bookmarkCourse == null
                                ? data[index]
                                : bloc.bookmarkCourse![index],
                            // courseModel: bloc.bookmarkCourse == null
                            //     ? data[index]
                            //     : bloc.bookmarkCourse![index],
                            onPress: () => Get.to(
                              CourseRegistration(
                                  isUser: true,
                                  id: bloc.bookmarkCourse == null
                                      ? data[index].id!
                                      : bloc.bookmarkCourse![index].id!),
                            ),
                          ),
                        );
            }));
  }
}
