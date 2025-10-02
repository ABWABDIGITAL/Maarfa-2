import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../layout/activity/user_screens/payment/payment_screen.dart';
import '../../../model/pay/pay_response.dart';
import '../../../model/payment_method/payment_method_response/payment_method_response.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/alert/alert_messege.dart';
import '../../../widget/toast/toast.dart';

class PayRepository {
  getPay(int id) async {
    try {
      return await DioService()
          .get("/clients/requests/$id/show")
          .then((value) => value.fold((l) => showToast(l), (r) {
                PayDbResponse subjectSubscriptions = PayDbResponse.fromJson(r);
                return subjectSubscriptions;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getPaymentMethod() async {
    try {
      return await DioService()
          .get("/clients/requests/showPaymentMethods")
          .then((value) => value.fold((l) => showToast(l), (r) {
                PymentMethodDbResponse paymentMethod =
                    PymentMethodDbResponse.fromJson(r);
                return paymentMethod;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // goToPay({
  //   int? id,
  //   String? amount,
  //   required bool wallet,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     return await DioService().post('/pay', body: {}).then(
  //       (value) => value.fold(
  //         (l) => showToast(l.toString()),
  //         (r) {
  //           // PayDbResponse pay = PayDbResponse.fromJson(r);
  //           // if (r['data'] != null) {

  //           // } else {

  //           Get.to(() => PaymentScreen(paymentUrl: r["data"], id: id));
  //           // }
  //           // return pay;
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future<void> pay({
    required int id,
    required BuildContext context,
    required Map<String, dynamic> data,
    required int type,
  }) async {
    try {
      final response = await DioService().post22(
        '/clients/requests/$id/pay',
        body: data,
      );

      // ❌ متشيّكش على null هنا، سيب fold يتصرف
      return response.fold(
            (l) {
          if (l is DioError) {
            final res = l.response;
            if (res != null && res.data != null) {
              final msg = res.data["messages"] ?? "حدث خطأ غير متوقع";
              showToast(msg); // ✅ هيعرض "الطلب منتهي الصلاحية"
            } else {
              showToast("فشل الاتصال بالسيرفر");
            }
          } else {
            showToast(l.toString());
          }
          return;
        },
            (r) {
          debugPrint("✅ Server response: $r");

          final bool success = r["success"] ?? false;
          final String msg = r["messages"] ?? "حدث خطأ غير متوقع";

          if (!success) {
            showToast(msg);
            return;
          }

          // ✅ نجاح
          if (type == 1) {
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const WalletSimpleAlert();
              },
            );
          } else {
            if (r["data"] != null) {
              Get.to(() => PaymentScreen(
                paymentUrl: r["data"],
                payMethodID: data["payMethodID"],
              ));
            } else {
              showToast("لم يتم استلام رابط الدفع");
            }
          }
        },
      );
    } catch (e) {
      debugPrint("❌ pay error: $e");
      showToast("حدث خطأ أثناء عملية الدفع");
    }
  }







  // pay({
  //   required int id,
  //   required BuildContext context,
  //   required Map<String, dynamic> data,
  //   required int type,
  // }) async {
  //   try {
  //     return await DioService()
  //         .post('/clients/requests/$id/pay', body: data)
  //         .then(
  //           (value) => value.fold(
  //             (l) => showToast(l.toString()),
  //             (r) {
  //               // PayDbResponse pay = PayDbResponse.fromJson(r);
  //               // if (r['data'] != null) {
  //
  //               // } else {
  //
  //               // showToast(r['messages']);
  //               type == 1
  //                   ? showDialog(
  //                       context: Get.context!,
  //                       barrierDismissible: false,
  //                       builder: (BuildContext context) {
  //                         return const WalletSimpleAlert();
  //                       })
  //                   : Get.to(() => PaymentScreen(
  //                       paymentUrl: r["data"],
  //                       payMethodID: data["payMethodID"]));
  //               // }
  //               // return pay;
  //             },
  //           ),
  //         );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  cancelLesson(int id) async {
    try {
      return await DioService()
          .get("/clients/lessons/$id/stop")
          .then((value) => value.fold((l) => showToast(l), (r) {
                // showToast(tr("cancel_sub_success"));
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  cancelCourse(int id) async {
    try {
      return await DioService()
          .get("/clients/courses/$id/stop")
          .then((value) => value.fold((l) => showToast(l), (r) {
                // showToast(tr("cancel_sub_success"));
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
