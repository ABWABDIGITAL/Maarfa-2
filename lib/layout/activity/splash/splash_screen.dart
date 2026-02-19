import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/layout/view/connectivity/connectivity_view.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/widget/background/background_image.dart';
import 'package:my_academy/widget/logo/logo_lottie/logo_lottie.dart';

import '../../../res/drawable/image/images.dart';
import '../../view/nations/nation_splash/splash_nations_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
          child: ConnectivityView(
        child: Stack(
          alignment: FractionalOffset.bottomCenter,
          children: [
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LogoLottie(
                    logoHeight: 300,
                    logoWidth: 300,
                  ),
                  SplashNationsView(),
                ],
              ),
            ),
            Positioned(
                bottom: 30.h,
                child: Image.asset(vision,
                    height: 50.h, width: 200, fit: BoxFit.contain))
          ],
        ),
      )),
    );
  }
}
