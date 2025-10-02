import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../failure.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class ContactUsRepository {
  contactUs(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post22('/contact_us', body: data)
          .then((value) => value.fold((l) => showToast("$l"), (r) {
                showToast(r['messages'].toString());
                Get.back();
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
