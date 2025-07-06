import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/connectivity/connectivity_cubit.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../background/background_image.dart';
import '../../buttons/master_load/master_load_button.dart';
import '../../space/space.dart';

class ErrorWifi extends StatelessWidget {
  const ErrorWifi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ConnectivityCubit(),
      child: BlocConsumer<ConnectivityCubit, ConnectivityState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = ConnectivityCubit.get(context);
          return BackgroundImage(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      size: 130.h, color: mainColor.withValues(alpha: 0.4)),
                  const Space(
                    boxHeight: 10,
                  ),
                  Text(
                    tr("connection_lost"),
                    style: TextStyles.hintStyle.copyWith(color: white),
                  ),
                  Space(
                    boxHeight: 10.h,
                  ),
                  Text(
                    tr("connection_message"),
                    style: TextStyles.subTitleStyle,
                  ),
                  const Space(
                    boxHeight: 25,
                  ),
                  MasterLoadButton(
                    buttonController: bloc.connectivityController,
                    buttonColor: mainColor,
                    sidePadding: 15,
                    buttonText: tr("try_again"),
                    onPressed: () {
                      Phoenix.rebirth(context);
                      bloc.connectivityController.reset();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
