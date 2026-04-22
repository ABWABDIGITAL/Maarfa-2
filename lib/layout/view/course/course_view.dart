import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/specialzation/specialization_cubit.dart';
import '../../../bloc/specialzation/specialization_state.dart';
import '../../../model/common/courses/course_details/course_details_model.dart';
import '../../../repository/common/specializations/specializations_repository.dart';
import '../../../res/value/color/color.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../card_view/specification/specification_card.dart';

class CourseView extends StatelessWidget {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SpecializationCubit(SpecializationsRepository())
            ..getSpecializations(),
      child: BlocBuilder<SpecializationCubit, SpecializationState>(
        builder: (context, state) {
          if (state is SpecializationLoadedState) {
            return _buildContent(state.data);
          } else if (state is SpecializationErrorState) {
            return const ErrorPage();
          }
          return const Center(child: Loading());
        },
      ),
    );
  }

  Widget _buildContent(List<Specialization>? data) {
    if (data == null || data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 48.w, color: Colors.grey[300]),
            SizedBox(height: 12.h),
            Text(
              tr("no_data"),
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              tr("choose_specialization"),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  SpecificationCard(specializationsModel: data[index]),
              childCount: data.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 40.h)),
      ],
    );
  }
}
