import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/home/home_cubit.dart';
import '../../../../model/slider/slider_response.dart';
import '../../../../repository/provider/home/home_repository.dart';
import '../../../../res/drawable/image/images.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/headers/home/home_header.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/search_home_widget/search_home_widget.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../activity/user_screens/course/course_screen.dart';
import '../../../activity/user_screens/grade/grade_screen.dart';
import '../../../activity/user_screens/offers/offers_screen.dart';
import '../../../card_view/home/home_card.dart';

class UserHomeCacheView extends StatelessWidget {
  const UserHomeCacheView({super.key});
  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            HomeCubit(HomeRepository())..getCacheSlider(),
        child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                if (state is SliderLoadedState && state.data != null) {
                  final data = (state).data;
                  return profileView(context, data!);
                } else if (state is SliderErrorState) {
                  return const ErrorPage();
                } else {
                  return const Loading();
                }
              });
            }));
  }

  profileView(context, SliderDbResponse data) {
    return ListView(
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
        if (data.data != null && data.data!.offers != null)
          SizedBox(
            width: screenWidth,
            height: 200.h,
            child: Swiper(
              autoplay: true,
              itemCount: data.data!.offers!.length,
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
                          imageUrl: data.data!.offers![index].image!,
                          width: screenWidth,
                          height: 140.h,
                          fit: BoxFit.fill,
                        ),
                        SidePadding(
                          sidePadding: 15,
                          child: Text(data.data!.offers![index].name!,
                              style: TextStyles.textView14SemiBold),
                        ),
                        SidePadding(
                          sidePadding: 15,
                          child: Text(data.data!.offers![index].content!,
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
    );
  }
}
