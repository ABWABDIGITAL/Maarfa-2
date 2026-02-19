import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../layout/activity/intro/intro_screen.dart';
import '../../layout/activity/provider_screens/main/main_screen.dart';
import '../../layout/activity/role/role_screen.dart';
import '../../layout/activity/user_screens/main/main_screen.dart';

import '../../service/local/share_prefs_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());
  // bool alreadyLogged = false;
  static SplashCubit get(BuildContext context) => BlocProvider.of(context);
  SharedPrefService prefs = SharedPrefService();
  startApp() {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      prefs.getBool("seen").whenComplete(() {
        if (prefs.value == true) {
          prefs.getValue("token").whenComplete(() {
            if (prefs.value == null ||
                prefs.value == "" ||
                prefs.value == "0") {
              prefs.setValue("token", "0");
              // alreadyLogged = false;
              Get.offAll(() => const RoleScreen());
            } else {
              prefs.getValue("type").whenComplete(() {
                // alreadyLogged = true;
                if (prefs.value == "user") {
                  Get.offAll(() => const MainScreen());
                } else {
                  Get.offAll(() => const ProviderMainScreen());
                }
              });
            }
          });
        } else {
          Get.offAll(() => const IntroScreen());
        }
      });
      emit(StartAppState());
    });
  }
}
