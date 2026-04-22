import 'package:flutter/cupertino.dart';

import '../../../model/common/video_courses/video_courses_db_response.dart';
import '../../../model/user/video_purchases/video_purchase_model.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class VideoCourseRepository {
  getVideoCourses() async {
    try {
      return await DioService()
          .get('/clients/video-courses')
          .then((value) => value.fold((l) => showToast(l), (r) {
                VideoCoursesDbResponse response =
                    VideoCoursesDbResponse.fromJson(r);
                return response;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getVideoCourseDetails(int id) async {
    try {
      return await DioService()
          .get('/clients/video-courses/$id/show')
          .then((value) => value.fold((l) => showToast(l), (r) {
                VideoCourseDetailsDbResponse response =
                    VideoCourseDetailsDbResponse.fromJson(r);
                return response;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  purchaseCourse(int id) async {
    try {
      return await DioService()
          .post('/clients/video-courses/$id/purchase')
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  purchaseUnit(int id) async {
    try {
      return await DioService()
          .post('/clients/video-units/$id/purchase')
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getStreamUrl(int unitId) async {
    try {
      return await DioService()
          .get('/clients/video-units/$unitId/stream')
          .then((value) => value.fold((l) => showToast(l), (r) {
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getMyPurchases() async {
    try {
      return await DioService()
          .get('/clients/video-purchases')
          .then((value) => value.fold((l) => showToast(l), (r) {
                VideoPurchasesDbResponse response =
                    VideoPurchasesDbResponse.fromJson(r);
                return response;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
