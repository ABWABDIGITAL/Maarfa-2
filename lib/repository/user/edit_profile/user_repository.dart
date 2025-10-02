import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../layout/activity/auth/register/user/code_screen.dart';
import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../layout/activity/user_screens/main/main_screen.dart';
import '../../../model/provider/provider/provider_response.dart';
import '../../../model/user/user/user_response.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class UserRepository {
  SharedPrefService prefService = SharedPrefService();

  /// get from api and save to shared
  getUserProfile() async {
    try {
      return await DioService()
          .get('/client/auth/profile')
          .then((value) => value.fold((l) => debugPrint(l.toString()), (r) {
                prefService.setValue("profile", json.encode(r));
                UserDbResponse userDbResponse = UserDbResponse.fromJson(r);
                return userDbResponse;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getProviderProfile() async {
    try {
      return await DioService()
          //Todo: get provider profile
          .get("/provider/auth/profile")
          .then((value) => value.fold((l) => showToast(l), (r) {
                prefService.setValue("profile", json.encode(r));
                ProviderDbResponse providerDbResponse =
                    ProviderDbResponse.fromJson(r);
                return providerDbResponse;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// get user details from shared
  getCacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('profile')) {
      var response = prefs.getString('profile');
      UserDbResponse userResponse =
          UserDbResponse.fromJson(json.decode(response!));
      return userResponse;
    }
  }

  getCacheProvider() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('profile')) {
      var response = prefs.getString('profile');
      ProviderDbResponse userResponse =
          ProviderDbResponse.fromJson(json.decode(response!));
      return userResponse;
    }
  }

  editProfile(File? image, Map<String, dynamic> data) async {
    try {
      return DioService()
          .requestWithFile(image, data, "/client/auth/editProfile", "image")
          .then((value) => value.fold((l) => showToast('$l'), (r) {
                showToast(r["messages"]);
                prefService.setValue('profile', json.encode(r));
                Get.offAll(() => const MainScreen());
              }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  validateEmail(String email, bool isUser) async {
    try {
      return DioService().post22(
          isUser
              ? "/client/auth/changeEmailRequest"
              : "/provider/auth/changeEmailRequest",
          body: {
            "email": email
          }).then((value) => value.fold((l) => showToast('$l'), (r) {
            Get.to(() => CodeScreen(
                  data: const {},
                  isUser: isUser,
                  isEdit: true,
                  email: email,
                ));
          }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  changeEmail(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getBool("isUser") ?? true;
    try {
      return DioService()
          .post(
              role ? "/client/auth/changeEmail" : "/provider/auth/changeEmail",
              body: data)
          .then((value) => value.fold((l) => showToast('$l'), (r) {
                prefService.setValue('profile', json.encode(r));
                role
                    ? Get.offAll(() => const MainScreen())
                    : Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  changePassword(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getBool("isUser") ?? true;
    try {
      return DioService()
          .post22(
              role
                  ? "/client/auth/changePassword"
                  : "/provider/auth/changePassword",
              body: data)
          .then((value) => value.fold((l) => showToast('$l'), (r) {
                showToast(r["messages"]);
                role
                    ? Get.offAll(() => const MainScreen())
                    : Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  editProviderProfile(File? image, Map<String, dynamic> data) async {
    try {
      return DioService()
          .requestWithFile(image, data, "/provider/auth/editProfile", "image")
          .then((value) => value.fold((l) => showToast('$l'), (r) {
                showToast('${r["messages"]}');
                prefService.setValue('profile', json.encode(r));
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  editBio(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post("/provider/auth/editBio", body: data)
          .then((value) => value.fold((l) => showToast('$l'), (r) {
                prefService.setValue('profile', json.encode(r));
                showToast('${r["messages"]}');
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }
}
