import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_cubit.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_state.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_all_best_teachers_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/teacher_details_screen.dart';
import 'package:my_academy/layout/view/home/user/view_all_specialization_screen.dart';
import 'package:my_academy/widget/alert/alert_rate.dart';
import 'package:my_academy/widget/headers/home/home_header.dart';

import '../../../../bloc/home/home_cubit.dart';
import '../../../../bloc/nations/nations_cubit.dart';
import '../../../../bloc/subscribe/subscribe_cubit.dart';
import '../../../../repository/provider/home/home_repository.dart';
import '../../../../res/drawable/image/images.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../../widget/search_home_widget/search_home_widget.dart';
import '../../../../widget/space/space.dart';
import '../../../activity/user_screens/course/course_screen.dart';
import '../../../activity/user_screens/video_courses/video_courses_list_screen.dart';
import '../../../activity/user_screens/packages/packages_list_screen.dart';
import '../../../activity/user_screens/grade/grade_screen.dart';
import '../../../activity/user_screens/offers/offers_screen.dart';
import '../../../card_view/current_subject/current_subject_card.dart';
import '../../../card_view/home/home_card.dart';
import '../../home/user/user_home_cache_view.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  @override
  void initState() {
    super.initState();
    context.read<NationsCubit>().getNationsInSplash();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeRepository())..getClientHome(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is SliderLoadedState) {
            return _profileView(context, state.data);
          } else if (state is SliderErrorState) {
            return const ErrorPage();
          } else {
            return const UserHomeCacheView();
          }
        },
      ),
    );
  }

  Widget _profileView(BuildContext context, dynamic data) {
    return BlocProvider(
      create: (_) => Home2Cubit()..getAllBestTeachers(),
      child: ListView(
        children: [
          const Space(boxHeight: 25),
          HomeHeader(isUser: true, data: data),
          const Space(boxHeight: 25),
          const SearchHomeWidget(),
          const Space(boxHeight: 15),

          // Live subscriptions section — fetched once in initState via BlocProvider.value
          _LiveSubscriptionsSection(data: data),

          const Space(boxHeight: 15),

          // Best Teachers
          BlocBuilder<Home2Cubit, Home2State>(
            builder: (context, state) {
              if (state is GetAllBestTeachersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetAllBestTeachersErrorState) {
                return const SizedBox();
              }
              final cubit = context.read<Home2Cubit>();
              return BestTeachersCard(
                teachers: cubit.bestTeachers,
                onSeeAll: () =>
                    Get.to(() => const ViewAllSpecializationScreen()),
                onTeacherTap: (teacher) => Get.to(() => TeacherDetailsScreen(
                      teacherId: teacher.id.toString(),
                    )),
              );
            },
          ),

          const Space(boxHeight: 15),

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
          const Space(boxHeight: 15),

          // Video Courses section
          RightHomeCard(
            title: tr("video_courses"),
            buttonText: tr("video_courses"),
            image: course,
            subTitle: tr("video_courses"),
            onTap: () => Get.to(() => const VideoCoursesListScreen()),
          ),
          LeftHomeCard(
            title: tr("monthly_packages"),
            buttonText: tr("monthly_packages"),
            image: onlineSubject,
            subTitle: tr("monthly_packages"),
            onTap: () => Get.to(() => const PackagesListScreen()),
          ),
          const Space(boxHeight: 50),
        ],
      ),
    );
  }
}

// ── Live Subscriptions Section ────────────────────────────────────────────────
// Extracted to its own StatefulWidget so the API calls happen once in initState,
// not on every BlocBuilder rebuild.

class _LiveSubscriptionsSection extends StatefulWidget {
  final dynamic data;
  const _LiveSubscriptionsSection({required this.data});

  @override
  State<_LiveSubscriptionsSection> createState() =>
      _LiveSubscriptionsSectionState();
}

class _LiveSubscriptionsSectionState extends State<_LiveSubscriptionsSection> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<SubscribeCubit>();
    cubit.getSubscriptionCourseHome();
    cubit.getSubscriptionLessonHome();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscribeCubit, SubscribeState>(
      builder: (context, susState) {
        final bloc = SubscribeCubit.get(context);

        final hasLessonSubs = bloc.subscribeSubjectModel != null &&
            bloc.subscribeSubjectModel!.liveSubscription.isNotEmpty;
        final hasCourseSubs = bloc.subscribeCourseModel != null &&
            bloc.subscribeCourseModel!.liveSubscription!.isNotEmpty;

        return Column(
          children: [
            // Live lesson subscriptions
            if (susState is SubjectSubscriptionLoadedState && hasLessonSubs)
              Column(
                children: List.generate(
                  bloc.subscribeSubjectModel!.liveSubscription.length,
                  (index) {
                    final sub =
                        bloc.subscribeSubjectModel!.liveSubscription[index];
                    return Column(
                      children: [
                        CurrentSubjectCard(
                          currentTimeId: sub.currentTimeId,
                          type: "lesson",
                          isLive: true,
                          id: sub.lesson.id,
                          courseTitle: sub.lesson.subject!.name!,
                          price: sub.lesson.hourPrice!,
                          name:
                              "${sub.lesson.provider.title!} ${sub.lesson.provider.firstName!} ${sub.lesson.provider.lastName!}",
                          onConferenceEnded: () {
                            bloc.getSubscriptionCourseHome();
                            bloc.getSubscriptionLessonHome();
                            Get.dialog(
                              RateAlert(
                                id: sub.lesson.id,
                                type: 'lesson',
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                        const Space(boxHeight: 15),
                      ],
                    );
                  },
                ),
              )
            // Live course subscriptions
            else if (hasCourseSubs)
              Column(
                children: List.generate(
                  bloc.subscribeCourseModel!.liveSubscription!.length,
                  (index) {
                    final sub =
                        bloc.subscribeCourseModel!.liveSubscription![index];
                    return Column(
                      children: [
                        CurrentSubjectCard(
                          currentTimeId: sub.currentTimeId,
                          type: "course",
                          isLive: sub.course.type != 1,
                          image: sub.course.image!,
                          id: sub.course.id!,
                          courseTitle: sub.course.name!,
                          price: sub.course.price,
                          name:
                              "${sub.course.provider.title!} ${sub.course.provider.firstName!} ${sub.course.provider.lastName!}",
                          onConferenceEnded: () {
                            bloc.getSubscriptionCourseHome();
                            bloc.getSubscriptionLessonHome();
                            Get.dialog(
                              RateAlert(
                                id: sub.course.id!,
                                type: 'course',
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                        const Space(boxHeight: 15),
                      ],
                    );
                  },
                ),
              ),

            // Offers swiper
            if (widget.data.data.offers!.isNotEmpty)
              SizedBox(
                width: screenWidth,
                height: 245.h,
                child: Swiper(
                  autoplay: true,
                  itemCount: widget.data.data.offers!.length,
                  viewportFraction: 0.9,
                  scale: 0.92,
                  pagination: SwiperPagination(
                    margin: const EdgeInsets.only(bottom: 8),
                    builder: DotSwiperPaginationBuilder(
                      color: mainColor.withValues(alpha: 0.2),
                      activeColor: accentColor,
                      size: 6.0,
                      activeSize: 8.0,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final offer = widget.data.data.offers![index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () => Get.to(() => const OffersScreen()),
                      child: Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CachedImage(
                                  imageUrl: offer.image!,
                                  fit: BoxFit.fill,
                                  width: screenWidth,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  offer.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.textView16SemiBold
                                      .copyWith(color: cvColor),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  offer.content!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.hintStyle
                                      .copyWith(fontSize: 13.sp),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: 12.0,
                                    top: 8),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    tr('view_details'),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class BestTeachersCard extends StatelessWidget {
  final List<ProvidersMM> teachers;
  final VoidCallback? onSeeAll;
  final Function(ProvidersMM)? onTeacherTap;

  const BestTeachersCard({
    super.key,
    required this.teachers,
    this.onSeeAll,
    this.onTeacherTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildTeachersList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            tr("best_teachers"),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              tr('view_all'),
              style: const TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTeachersList(BuildContext context) {
    if (teachers.isEmpty) return _buildEmptyState(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.5;
    final cardHeight = 230.h;

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: teachers.length,
        itemBuilder: (context, index) =>
            _buildTeacherCard(teachers[index], cardWidth),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 230.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              tr('no_teachers_found'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherCard(ProvidersMM teacher, double cardWidth) {
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => onTeacherTap?.call(teacher),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTeacherImage(teacher, cardWidth),
              _buildTeacherInfo(teacher),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherImage(ProvidersMM teacher, double cardWidth) {
    final imageHeight = cardWidth * 0.55;
    final initials = _getInitials(teacher);
    const bgColors = [
      Color(0xFFE8F4FD),
      Color(0xFFFFF3E0),
      Color(0xFFE8F5E9),
      Color(0xFFFCE4EC),
      Color(0xFFEDE7F6),
    ];
    const fgColors = [
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFF4527A0),
    ];
    final idx =
        (initials.isEmpty ? 0 : initials.codeUnitAt(0)) % bgColors.length;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            teacher.imagePath != null && teacher.imagePath!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: teacher.imagePath!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: bgColors[idx]),
                    errorWidget: (_, __, ___) => Container(
                      color: bgColors[idx],
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: fgColors[idx],
                            fontSize: (cardWidth * 0.15).clamp(24.0, 44.0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: bgColors[idx],
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: fgColors[idx],
                          fontSize: (cardWidth * 0.15).clamp(24.0, 44.0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
            if (teacher.rate != null && teacher.rate! > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF272727),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFEFB10B), size: 11),
                      const SizedBox(width: 3),
                      Text(
                        teacher.rate.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherInfo(ProvidersMM teacher) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getFullName(teacher),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF272727),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (teacher.title != null || teacher.degree != null) ...[
              const SizedBox(height: 3),
              Text(
                '${teacher.title ?? ''} ${teacher.degree ?? ''}'.trim(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF707070),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            if (teacher.specialization != null &&
                teacher.specialization!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  teacher.specialization!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFullName(ProvidersMM teacher) {
    final firstName = teacher.firstName ?? '';
    final lastName = teacher.lastName ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Teacher' : fullName;
  }

  String _getInitials(ProvidersMM teacher) {
    final firstName = teacher.firstName ?? '';
    final lastName = teacher.lastName ?? '';
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    return initials.isEmpty ? 'T' : initials;
  }
}
