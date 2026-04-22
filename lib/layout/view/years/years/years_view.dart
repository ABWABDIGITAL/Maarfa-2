import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/educational_stages_years/educational_stages_cubit.dart';
import '../../../../model/common/educational_stages/educational_stages_model.dart';
import '../../../../repository/common/educational_stages/educational_stages_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../card_view/class/class_card.dart';
import '../../../card_view/grade/grade_card.dart';

class YearsView extends StatelessWidget {
  final List<EducationalStageModel> stages;
  const YearsView({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EducationalStagesCubit(EducationalStagesRepository())
        ..getEducationalYears(),
      child: BlocBuilder<EducationalStagesCubit, EducationalStagesState>(
        builder: (context, state) {
          if (state is EducationalYearsLoadedState) {
            return _YearsContent(stages: stages, fallbackYears: state.data);
          } else if (state is EducationalYearsErrorState) {
            return const ErrorPage();
          }
          return const Center(child: Loading());
        },
      ),
    );
  }
}

class _YearsContent extends StatelessWidget {
  final List<EducationalStageModel> stages;
  final dynamic fallbackYears;

  const _YearsContent({required this.stages, required this.fallbackYears});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EducationalStagesCubit(EducationalStagesRepository()),
      child: BlocBuilder<EducationalStagesCubit, EducationalStagesState>(
        builder: (context, state) {
          final bloc = EducationalStagesCubit.get(context);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Section header: stages
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    tr("educational_stage"),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                ),
              ),

              // Stages list
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => GradeCard(
                      title: stages[index].name,
                      image: stages[index].image,
                      id: stages[index].id!,
                      onTap: () => bloc.selectStage(index, stages),
                      isSelected: bloc.isSelect == index,
                    ),
                    childCount: stages.length,
                  ),
                ),
              ),

              // Divider + years section
              if (bloc.yearsModel.isNotEmpty) ...[
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.grey[200], thickness: 1),
                        SizedBox(height: 12.h),
                        Text(
                          tr("grade"),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Years grid
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 1.3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final years = bloc.yearsModel.isNotEmpty
                            ? bloc.yearsModel
                            : fallbackYears;
                        return ClassCard(
                          stageId: stages[bloc.isSelect!].id!,
                          name: years[index].name!,
                          id: years[index].id!,
                        );
                      },
                      childCount: bloc.yearsModel.isNotEmpty
                          ? bloc.yearsModel.length
                          : (fallbackYears is List ? fallbackYears.length : 0),
                    ),
                  ),
                ),
              ],

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          );
        },
      ),
    );
  }
}
