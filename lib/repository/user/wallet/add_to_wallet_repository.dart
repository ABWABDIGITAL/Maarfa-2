import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:my_academy/service/network/dio/dio_service.dart';
import 'package:my_academy/widget/toast/toast.dart';

import '../../../layout/activity/user_screens/payment/payment_screen.dart';

class WalletRepository {
  SharedPrefService prefService = SharedPrefService();

  // addToWallet({
  //   required int id,
  //   String? amount,
  // }) async {
  //   try {
  //     return await DioService().post('/client/auth/addToWallet',
  //         body: {"amount": amount, "payMethodID": id}).then((value) {
  //       return value.fold((l) => showToast("$l"), (r) {
  //         // if(r["status"]==400){
  //         //
  //         // }else{
  //         // prefService.setValue('profile', json.encode(r["data"])).then((value) =>Get.back());
  //         // Get.offAll(()=>
  //         // const MainScreen());
  //         Get.to(() => PaymentScreen(
  //               paymentUrl: r["data"],
  //               payMethodID: id,
  //             ));
  //
  //         //     WalletCharging(
  //         //   isUser: true,
  //         //   walletCredit: r["data"]["wallet"],
  //         // )
  //         return;
  //       });
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  Future<void> addToWallet({
    required int id,
    String? amount,
  }) async {
    try {
      final response = await DioService().post(
        '/client/auth/addToWallet',
        body: {
          "amount": amount,
          "payMethodID": id,
        },
      );

      if (response == null) {
        showToast("فشل الاتصال بالسيرفر");
        return;
      }

      print('----------------------------------------');
      print("response--: $response");
      print('----------------------------------------');

      return response.fold(
            (l) {
          // ❌ خطأ Dio أو شبكة
          showToast(l.toString());
          return;
        },
            (r) {
          // ✅ رد السيرفر (حتى لو خطأ)
          final bool success = r["success"] ?? false;
          final int status = r["status"] ?? 0;
          final String message = r["messages"] ?? "حدث خطأ غير متوقع";



          if (!success || status == 400 || status == 422) {
            // ❌ حالة فشل (زي: الطلب منتهي الصلاحية)
            showToast(message);
            return;
          }

          // ✅ حالة نجاح
          if (r["data"] != null) {
            Get.to(() => PaymentScreen(
              paymentUrl: r["data"],
              payMethodID: id,
            ));
          } else {
            showToast("لم يتم استلام رابط الدفع");
          }
        },
      );
    } catch (e) {
      debugPrint("addToWallet error: $e");
      showToast("حدث خطأ أثناء الإضافة للمحفظة");
    }
  }



}
