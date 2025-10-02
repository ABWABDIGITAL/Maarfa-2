import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../bloc/subject/subject_cubit.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../view/class_screen/class_screen_view.dart';
import '../grade/grade_screen.dart';

class ClassScreen extends StatelessWidget {
  final int id;
  final int stageId;
  final String name;
  final Map<String, dynamic>? filterData;

  const ClassScreen({
    super.key,
    required this.name,
    required this.id,
    required this.stageId,
    this.filterData,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const GradeScreen());
        return true;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
            title: name,
            centerTitle: true,
            backPressed: () => Get.offAll(() => const GradeScreen())),
        body: BlocProvider(
            create: (BuildContext context) =>
                SubjectCubit()..getSubjects(yearId: id, stageId: stageId),
            child: BlocConsumer<SubjectCubit, SubjectState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return BlocBuilder<SubjectCubit, SubjectState>(
                    builder: (context, state) {
                      if (state is SubjectLoadedState) {
                        final data = state.subject;

                        return ClassScreenView(
                          subject: data,
                          yearId: id,
                          stageId: stageId,
                          filterData: filterData,
                          name: name,
                        );
                      } else if (state is SubjectErrorState) {
                        return const ErrorPage();
                      } else {
                        return const Loading();
                      }
                    },
                  );
                })),

        // BlocProvider(
        //   create: (context) =>
        //       SubjectCubit()..getSubjects(yearId: id, stageId: stageId),
        //   child: BlocConsumer<SubjectCubit, SubjectState>(
        //     listener: (context, state) {},
        //     builder: (context, state) {
        //       if (state is SubjectLoadingState) {
        //         return const Loading();
        //       } else if (state is SubjectLoadedState) {
        //         return ClassScreenView(
        //           subject: state.subject,
        //           yearId: id,
        //           stageId: stageId,
        //         );
        //       } else if (state is SubjectErrorState) {
        //         return const ErrorPage();
        //       }
        //       return Container();
        //     },
        //   ),
        // ),
      ),
    );
  }
}
