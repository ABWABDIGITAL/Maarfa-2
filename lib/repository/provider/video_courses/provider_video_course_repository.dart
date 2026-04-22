import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../model/common/video_courses/video_courses_db_response.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class ProviderVideoCourseRepository {
  getMyVideoCourses() async {
    try {
      return await DioService()
          .get('/provider/video-courses')
          .then((value) => value.fold((l) => showToast(l), (r) {
                VideoCoursesDbResponse response =
                    VideoCoursesDbResponse.fromJson(r);
                return response;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  createVideoCourse(Map<String, dynamic> data) async {
    try {
      return await DioService()
          .post('/provider/video-courses', body: data)
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateVideoCourse(int id, Map<String, dynamic> data) async {
    try {
      return await DioService()
          .put('/provider/video-courses/$id', body: data)
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteVideoCourse(int id) async {
    try {
      return await DioService()
          .delete('/provider/video-courses/$id')
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addUnit(int courseId, File video, Map<String, dynamic> data) async {
    try {
      return await DioService()
          .requestWithFile(
              video, data, '/provider/video-courses/$courseId/units', 'video')
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addUnitWithUrl(int courseId, Map<String, dynamic> data) async {
    try {
      return await DioService()
          .post('/provider/video-courses/$courseId/units', body: data)
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateUnit(int id, Map<String, dynamic> data) async {
    try {
      return await DioService()
          .put('/provider/video-units/$id', body: data)
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteUnit(int id) async {
    try {
      return await DioService()
          .delete('/provider/video-units/$id')
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]?.toString() ?? "");
                return r;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
