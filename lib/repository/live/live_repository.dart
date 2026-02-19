import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../failure.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';
import '../../service/jitsi/jitsi_service.dart';

class LiveRepository {
  Future<Either<Failure, String>> getNewShareLinkForLive(
      Map<String, dynamic> data) async {
    try {
      final response =
          await DioService().post3('/agora/generate_token', body: data);
      late final Either<Failure, String> result;
      response.fold((l) {
        result = Left(Failure(l));
      }, (data) {
        result = Right(data["data"]['share_url']);
      });
      return result;
    } catch (_) {
      return Left(Failure(tr("try_again")));
    }
  }

  enterLive(Map<String, dynamic> data, bool isBroadcaster,
      {VoidCallback? onConferenceEnded}) async {
    try {
      return DioService()
          .post('/agora/generate_token', body: data)
          .then((value) => value.fold(
                  (l) => showToast(
                        '$l',
                      ), (r) {
                isBroadcaster
                    ? JitsiService().joinMeeting(
                        roomNo: r["data"]["channel_name"],
                        userId: r["data"]["user_id"],
                        token: r["data"]["token"],
                        timeId: data["time_id"],
                        onConferenceEnded: onConferenceEnded,
                      )
                    : JitsiService().joinUserMeeting(
                        roomNo: r["data"]["channel_name"],
                        userId: r["data"]["user_id"],
                        token: r["data"]["token"],
                        onConferenceEnded: onConferenceEnded,
                      );
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  endSession(bool timeId) async {
    try {
      return DioService().get('/provider/time/end/$timeId');
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
