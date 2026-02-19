import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/live/live_repository.dart';

part 'live_state.dart';

class LiveCubit extends Cubit<LiveState> {
  final LiveRepository liveRepository;
  LiveCubit(this.liveRepository) : super(LiveInitial());
  static LiveCubit get(BuildContext context) => BlocProvider.of(context);

  bool isLoad = false;

  Future<void> enterLive(bool isBroadcaster, int id, String type,
      {int? timeId, VoidCallback? onConferenceEnded}) async {
    isLoad = true;
    emit(EnterLiveLoadingState());
    final data = {"type": type, "id": id, "time_id": timeId};
    await liveRepository.enterLive(data, isBroadcaster,
        onConferenceEnded: onConferenceEnded);
    isLoad = false;
    emit(EnterLiveState());
  }
}
