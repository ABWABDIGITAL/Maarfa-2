import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/static/empty_screens/empty_screens.dart';

import '../../../../../widget/error/page/error_page.dart';
import '../../../../../widget/loader/loader.dart';
import '../../../../bloc/home/home_cubit.dart';
import '../../../../model/provider/home/home_db_response.dart';
import '../../../../repository/provider/home/home_repository.dart';
import '../../../../res/drawable/image/images.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/headers/home/home_header.dart';
import '../../../../widget/row_title/master_row.dart';
import '../../../../widget/space/space.dart';
import '../../../activity/provider_screens/all_course/all_courses_screen.dart';
import '../../../activity/provider_screens/all_subject/all_subject_screen.dart';
import '../../../card_view/provider_course/provider_course_card.dart';
import '../../../card_view/provider_current/provider_current_card.dart';
import '../../../card_view/provider_subject/provider_subject_card.dart';

// class HomeCacheView extends StatelessWidget {
//   const HomeCacheView({super.key});
//   @override
//   Widget build(final BuildContext context) {
//     return BlocProvider(
//         create: (BuildContext context) =>
//             HomeCubit(HomeRepository())..getCacheHome(),
//         child: BlocConsumer<HomeCubit, HomeState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return BlocBuilder<HomeCubit, HomeState>(
//                   builder: (context, state) {
//                 if (state is HomeLoadedState && state.data != null) {
//                   final data = (state).data;
//                   return homeView(context, data!);
//                 } else if (state is HomeLoadErrorState) {
//                   return const ErrorPage();
//                 } else {
//                   return const Loading();
//                 }
//               });
//             }));
//   }

//   homeView(context, HomeDbResponse data) {
//     return Stack(
//       alignment: FractionalOffset.topCenter,
//       children: [
//         Container(
//           width: screenWidth,
//           height: screenHeight * 0.45,
//           decoration: const BoxDecoration(
//               color: mainColor,
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(75),
//                   bottomRight: Radius.circular(75))),
//         ),
//         // Image.asset(
//         //   homeBackground,
//         //   width: screenWidth,
//         //   height: screenHeight * 0.45,
//         //   fit: BoxFit.fill,
//         // ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Space(
//               boxHeight: 50,
//             ),
//             HomeHeader(
//               isNotify: false,
//               isUser: false,
//               data: data,
//             ),
//             const Space(
//               boxHeight: 20,
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 right: 35.w,
//                 left: 35.w,
//                 top: 10.h,
//               ),
//               child: Text(
//                 tr("request"),
//                 style: TextStyles.titleStyle.copyWith(color: white),
//               ),
//             ),
//             const Space(
//               boxHeight: 10,
//             ),
//             data.data.currentAction == null
//                 ? EmptyScreen(
//                     title: tr("no_current"),
//                     image: emptyCurrent,
//                     width: screenWidth,
//                     height: 170.h,
//                     color: white,
//                   )
//                 : data.data.currentAction!.item == null
//                     ? EmptyScreen(
//                         title: tr("no_current"),
//                         image: emptyCurrent,
//                         width: screenWidth,
//                         height: 170.h,
//                         color: white,
//                       )
//                     : ProviderCurrentCard(
//                         data: data.data.currentAction,
//                       ),
//             Space(
//               boxHeight: screenHeight * 0.05,
//             ),
//             SizedBox(
//               height: screenHeight * 0.5,
//               width: screenWidth,
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   // const Space(
//                   //   boxHeight: 40,
//                   // ),
//                   MasterRow(
//                     title: tr("t_courses"),
//                     subTitle: tr("view_all_c"),
//                     onTap: () => Get.to(() => const ProviderCourseScreen()),
//                   ),
//                   data.data.courses!.isEmpty || data.data.courses == null
//                       ? EmptyScreen(
//                           title: tr("no_course"),
//                           image: emptyCurrent,
//                           width: screenWidth,
//                           height: 170.h,
//                           color: mainColor.withValues(alpha:0.3),
//                         )
//                       : CustomList(
//                           listHeight: 10000000000000,
//                           listWidth: screenWidth,
//                           scroll: const ScrollPhysics(),
//                           axis: Axis.vertical,
//                           count: data.data.courses!.length,
//                           child: (context, index) => Padding(
//                             padding: EdgeInsets.only(bottom: 15.h),
//                             child: ProviderCourseCard(
//                                 data: data.data.courses![index]),
//                           ),
//                         ),
//                   MasterRow(
//                     title: tr("courses_offered"),
//                     subTitle: tr("view_all_l"),
//                     onTap: () => Get.to(() => const ProviderSubjectScreen()),
//                   ),
//                   // const Space(
//                   //   boxHeight: 30,
//                   // ),
//                   data.data.lessons!.isEmpty || data.data.lessons == null
//                       ? EmptyScreen(
//                           title: tr("no_lesson"),
//                           image: emptyCurrent,
//                           width: screenWidth,
//                           height: 170.h,
//                           color: mainColor.withValues(alpha:0.3),
//                         )
//                       : CustomList(
//                           listHeight: 10000000000000,
//                           listWidth: screenWidth,
//                           scroll: const ScrollPhysics(),
//                           axis: Axis.vertical,
//                           count: data.data.lessons!.length,
//                           child: (context, index) => Padding(
//                             padding: EdgeInsets.only(bottom: 15.h),
//                             child: ProviderSubjectCard(
//                                 data: data.data.lessons![index]),
//                           ),
//                         ),

//                   const Space(
//                     boxHeight: 50,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class HomeCacheView extends StatelessWidget {
  const HomeCacheView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          HomeCubit(HomeRepository())..getCacheHome(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadedState && state.data != null) {
                final data = (state).data;
                return _homeCacheView(context, data!);
              } else if (state is HomeLoadErrorState) {
                return const ErrorPage();
              } else {
                return const Loading();
              }
            },
          );
        },
      ),
    );
  }

  Widget _homeCacheView(BuildContext context, HomeDbResponse data) {
    return Column(
      children: [
        // Header with curved background, similar to ProviderHomeView
        Container(
          padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: HomeHeader(
            isNotify: false,
            isUser: false,
            data: data,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Space(boxHeight: 20),
                  Text(
                    tr("request"),
                    style: TextStyles.titleStyle.copyWith(color: mainColor),
                  ),
                  const Space(boxHeight: 10),
                  // Current action or empty
                  data.data.currentAction == null ||
                          data.data.currentAction!.item == null
                      ? EmptyScreen(
                          title: tr("no_current"),
                          image: emptyCurrent,
                          width: screenWidth,
                          height: 170.h,
                        )
                      : ProviderCurrentCard(data: data.data.currentAction),
                  const Space(boxHeight: 30),
                  MasterRow(
                    title: tr("t_courses"),
                    subTitle: tr("view_all_c"),
                    onTap: () => Get.to(() => const ProviderCourseScreen()),
                  ),
                  const Space(boxHeight: 10),
                  // data.data.courses?.isEmpty ?? true
                  //     ? EmptyScreen(
                  //         title: tr("no_course"),
                  //         image: emptyCurrent,
                  //         width: screenWidth,
                  //         height: 170.h,
                  //         color: mainColor.withValues(alpha:0.3),
                  //       )
                  //     : Column(
                  //         children: List.generate(
                  //           data.data.courses!.length,
                  //           (index) => Padding(
                  //             padding: EdgeInsets.only(bottom: 10.h),
                  //             child: ProviderCourseCard(
                  //                 data: data.data.courses![index]),
                  //           ),
                  //         ),
                  //       ),
                  data.data.courses?.isEmpty ?? true
                      ? EmptyScreen(
                          title: tr("no_course"),
                          image: emptyCurrent,
                          width: screenWidth,
                          height: 170.h,
                          color: mainColor.withValues(alpha: 0.3),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 10.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 10.h,
                                  mainAxisExtent: 180.sp),
                          itemCount: data.data.courses!.length,
                          itemBuilder: (context, index) => ProviderCourseCard(
                              data: data.data.courses![index]),
                        ),
                  const Space(boxHeight: 20),
                  MasterRow(
                    title: tr("courses_offered"),
                    subTitle: tr("view_all_l"),
                    onTap: () => Get.to(() => const ProviderSubjectScreen()),
                  ),
                  const Space(boxHeight: 10),
                  data.data.lessons?.isEmpty ?? true
                      ? EmptyScreen(
                          title: tr("no_lesson"),
                          image: emptyCurrent,
                          width: screenWidth,
                          height: 170.h,
                          color: mainColor.withValues(alpha: 0.3),
                        )
                      : ListView.builder(
                          itemCount: data.data.lessons!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: ProviderSubjectCard(
                                data: data.data.lessons![index]),
                          ),
                        ),
                  const Space(boxHeight: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
