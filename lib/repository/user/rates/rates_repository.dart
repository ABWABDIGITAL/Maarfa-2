import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../failure.dart';
import '../../../layout/activity/user_screens/main/main_screen.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class RateRepository {
  addRate(Map<String, dynamic> data) async {
    try {
      final body = {
        "type": data["type"],
        "id": data["id"],
        "rate": data["rate"],
        "session_quality": data["session_quality"],
        "review": data["review"],
      };
      return DioService()
          .post('/clients/rates', body: body)
          .then((value) => value.fold((l) => showToast("$l"), (r) {
                showToast(r['messages']);
                Get.offAll(() => const MainScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
