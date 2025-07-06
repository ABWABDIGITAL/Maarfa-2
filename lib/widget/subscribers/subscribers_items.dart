import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/widget/buttons/master_load/master_load_button.dart';

import '../../bloc/subscribers/subscribers_cubit.dart';
import '../../model/subscribers/subscribers_model.dart';
import '../../repository/subscribers/subscribers_repository.dart';
import '../../res/drawable/image/images.dart';
import '../../res/value/color/color.dart';
import '../../res/value/style/textstyles.dart';
import '../side_padding/side_padding.dart';
import '../space/space.dart';

class SubscribersItems extends StatelessWidget {
  final SubscribersModel data;
  const SubscribersItems({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            SubscribersCubit(SubscribersRepository()),
        child: BlocConsumer<SubscribersCubit, SubscribersState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = SubscribersCubit.get(context);
              return SidePadding(
                sidePadding: 15,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: mainColor.withValues(alpha: .5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.w,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Image(
                              image: AssetImage(provider),
                            ),
                          ),
                          Space(
                            boxWidth: 10.w,
                          ),
                          Text("${data.firstName} ${data.lastName}",
                              style: TextStyles.hintStyle
                                  .copyWith(color: black, fontSize: 16.sp)),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            data.certificated ?? true
                                ? Container(
                                    height: 40.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: Center(
                                      child: Text(tr("certificated"),
                                          style: TextStyles.hintStyle.copyWith(
                                              color: inProgressColor)),
                                    ),
                                  )
                                : MasterLoadButton(
                                    buttonController: bloc.subscriberController,
                                    onPressed: () => bloc.sendCertificate(
                                        data.courseId!,
                                        data.requestId!,
                                        data.id!),
                                    buttonHeight: 40,
                                    // buttonColor: white,
                                    buttonRadius: 5,
                                    buttonText: tr("certificate_issuance"),
                                    sidePadding: 0,
                                    buttonStyle: TextStyles.hintStyle
                                        .copyWith(color: white),
                                  ),
                            const SizedBox(height: 10),
                            if (!(data.certificated ?? false))
                              MasterLoadButton(
                                buttonController: bloc.subscriberController,
                                onPressed: () => bloc.uploadePDFCertificate(
                                    data.courseId!, data.requestId!, data.id!),
                                buttonHeight: 40,
                                // buttonColor: white,
                                buttonRadius: 5,
                                buttonText: tr("certificate_pdf_issuance"),
                                sidePadding: 0,
                                buttonStyle:
                                    TextStyles.hintStyle.copyWith(color: white),
                              ),
                          ])
                    ],
                  ),
                ),
              );
            }));
  }
}
