import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/widget/buttons/master_load/master_load_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../model/provider/requests/requests_model/requests_model.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/space/space.dart';

class CardContact extends StatelessWidget {
  const CardContact(
      {super.key,
      required this.data,
      required this.rejectTap,
      required this.acceptTap,
      this.acceptController,
      this.rejectController});
  final Request data;
  final void Function() rejectTap;
  final void Function() acceptTap;
  final RoundedLoadingButtonController? rejectController;
  final RoundedLoadingButtonController? acceptController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    height: 30.h,
                    width: 30.w,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Image(image: AssetImage(userSolid))),
                const Space(
                  boxWidth: 5,
                ),
                Text(
                  "${data.client!.firstName!} ${data.client!.lastName!} ",
                  style: TextStyles.hintStyle.copyWith(
                    color: black,
                  ),
                ),
                const Spacer(),
                Container(
                    height: 30.h,
                    width: 30.w,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Image(image: AssetImage(tableCells))),
                const Space(
                  boxWidth: 5,
                ),
                Text(
                  data.createdAt.toString(),
                  // "22-2-2020 . 02:00",
                  style: TextStyles.contentStyle,
                ),
              ],
            ),
            const Space(
              boxHeight: 20,
            ),
            data.status == 2
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tr("request_accept"),
                        style: TextStyles.subTitleStyle
                            .copyWith(color: inProgressColor, fontSize: 16.sp)),
                  )
                : data.status == 3
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            tr("${tr("request_reject")} ${data.rejectReason}"),
                            style: TextStyles.subTitleStyle
                                .copyWith(color: circleColor, fontSize: 16.sp)),
                      )
                    : data.status == 4
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(tr("request_paid"),
                                style: TextStyles.subTitleStyle.copyWith(
                                    color: inProgressColor, fontSize: 16.sp)),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: MasterLoadButton(
                                      buttonHeight: 40.h,
                                      buttonWidth: 150.w,
                                      onPressed: acceptTap,
                                      buttonController: acceptController!,
                                      buttonColor: inProgressColor,
                                      buttonStyle: TextStyles.textView14SemiBold
                                          .copyWith(color: white),
                                      // borderColor: inProgressColor,
                                      buttonText: tr("accept")),
                                ),
                                Space(
                                  boxWidth: 10.w,
                                ),
                                Expanded(
                                  child: MasterLoadButton(
                                    buttonHeight: 40.h,
                                    buttonWidth: 150.w,
                                    buttonColor: lightColor,
                                    // borderColor: lightColor,
                                    onPressed: rejectTap,
                                    buttonText: tr("rejected"),
                                    buttonStyle: TextStyles.textView14SemiBold
                                        .copyWith(color: circleColor),
                                    buttonController: rejectController!,
                                  ),
                                ),
                              ],
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
