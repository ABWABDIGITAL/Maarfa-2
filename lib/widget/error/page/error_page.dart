import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../background/background_image.dart';
import '../../space/space.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded,
                size: 130.h, color: mainColor.withValues(alpha: 0.4)),
            const Space(
              boxHeight: 10,
            ),
            Text(
              tr("warning"),
              style: TextStyles.hintStyle.copyWith(color: white),
            ),
            const Space(
              boxHeight: 10,
            ),
            Text(
              tr("warning_message"),
              style: TextStyles.subTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
