import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/drawable/image/images.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/logo/logo/logo.dart';

class RequestAdviceCard extends StatelessWidget {
  const RequestAdviceCard(
      {super.key,
      this.id,
      this.date,
      this.title,
      this.requestsCount,
      this.onTap,
      this.isRequest = true,
      this.lessonPlace});
  final String? title;
  final String? id;
  final String? date;
  final String? lessonPlace;
  final String? requestsCount;
  final bool? isRequest;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(
                  logoHeight: 100,
                  logoWidth: 70,
                ),
                const Space(
                  boxWidth: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LimitedBox(
                      maxWidth: 100.w,
                      child: Text(title ?? "",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.appBarStyle.copyWith(
                              color: blackColor, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      lessonPlace ?? "",
                      // e.tr("legal_advice"),
                      style: TextStyles.errorStyle.copyWith(color: secColor),
                    ),
                    Text(id ?? "",
                        // "#123456",
                        style: TextStyles.errorStyle
                            .copyWith(color: textfieldColor)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: enterColor.withValues(alpha: 0.1),
                        border: Border.all(
                          color: enterColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          e.tr("subject"),
                          style:
                              TextStyles.errorStyle.copyWith(color: enterColor),
                        ),
                      ),
                    ),
                    const Space(
                      boxHeight: 20,
                    ),
                    Text(
                      e.DateFormat("d/MM/yy h:m:s", "en")
                          .format(DateTime.parse(date ?? "")),
                      // "22-2-2020 . 02:00",
                      style: TextStyles.contentStyle,
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ],
            ),
            isRequest == false
                ? const SizedBox()
                : Row(
                    children: [
                      Text(e.tr("view_requests"),
                          style: TextStyles.subTitleStyle),
                      const Space(
                        boxWidth: 5,
                      ),
                      Image.asset(moreInfo, height: 10.h, fit: BoxFit.contain),
                      const Spacer(),
                      Container(
                        height: 30.h,
                        width: 30.w,
                        decoration: const BoxDecoration(
                            color: circleColor, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            requestsCount ?? "0",
                            style:
                                TextStyles.subTitleStyle.copyWith(color: white),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
