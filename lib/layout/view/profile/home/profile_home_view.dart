import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../widget/error/page/error_page.dart';
import '../../../../bloc/profile/user/user_cubit.dart';
import '../../../../model/slider/slider_model.dart';
import '../../../../repository/user/edit_profile/user_repository.dart';
import '../../../../res/drawable/image/images.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/headers/home/home_header.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../../widget/search_home_widget/search_home_widget.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../activity/user_screens/course/course_screen.dart';
import '../../../activity/user_screens/grade/grade_screen.dart';
import '../../../activity/user_screens/offers/offers_screen.dart';
import '../../../card_view/home/home_card.dart';
import '../../home/user/user_home_cache_view.dart';

class HomeProfileView extends StatelessWidget {
  final bool isUser, isNotify;
  final List<SliderModel>? offers;
  const HomeProfileView(
      {super.key, required this.isUser, this.isNotify = true, this.offers});
  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            UserCubit(UserRepository())..getProfile(),
        child: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is UserApiLoadedState) {
                final data = state.data;
                return profileView(context, data);
              } else if (state is ErrorUserState) {
                return const ErrorPage();
              } else {
                return const UserHomeCacheView();
              }
            }));
  }

  profileView(context, data) {
    return Stack(
      alignment: FractionalOffset.topCenter,
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.4,
          decoration: const BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100))),
        ),
        // Image.asset(
        //   homeBackground,
        //   width: screenWidth,
        //   height: 390.h,
        //   fit: BoxFit.fill,
        // ),
        ListView(
          children: [
            const Space(
              boxHeight: 25,
            ),
            HomeHeader(
              isUser: true,
              data: data,
            ),
            const Space(
              boxHeight: 25,
            ),
            const SearchHomeWidget(),
            const Space(
              boxHeight: 15,
            ),
            SizedBox(
              width: screenWidth,
              height: 200.h,
              child: Swiper(
                autoplay: true,
                itemCount: offers!.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Get.to(() => const OffersScreen()),
                  child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10.r)),
                      height: 200.h,
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            imageUrl: offers![index].image!,
                            width: screenWidth,
                            height: 140.h,
                            fit: BoxFit.fill,
                          ),
                          SidePadding(
                            sidePadding: 15,
                            child: Text(offers![index].name!,
                                style: TextStyles.textView14SemiBold),
                          ),
                          SidePadding(
                            sidePadding: 15,
                            child: Text(offers![index].content!,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.hintStyle),
                          ),
                        ],
                      )),
                ),
                viewportFraction: 0.8,
                scale: 0.9,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: mainColor.withValues(alpha: 0.1),
                        activeColor: mainColor)),
              ),
            ),
            const Space(
              boxHeight: 15,
            ),
            RightHomeCard(
              title: tr("need_subject"),
              buttonText: tr("grades"),
              image: onlineSubject,
              subTitle: tr("subject_available"),
              onTap: () => Get.to(() => const GradeScreen()),
            ),
            // const Space(
            //   boxHeight: 15,
            // ),
            LeftHomeCard(
              title: tr("need_course"),
              buttonText: tr("courses"),
              image: course,
              subTitle: tr("course_available"),
              onTap: () => Get.to(() => const CourseScreen()),
            ),
            const Space(
              boxHeight: 50,
            ),
          ],
        ),
      ],
    );
  }
}
