part of 'live_cubit.dart';

abstract class LiveState extends Equatable {
  const LiveState();

  @override
  List<Object> get props => [];
}

class LiveInitial extends LiveState {}

class EnterLiveLoadingState extends LiveState {}

class EnterLiveState extends LiveState {}

class EnterLiveErrorState extends LiveState {
  final String message;
  const EnterLiveErrorState(this.message);

  @override
  List<Object> get props => [message];
}
