part of 'stop_bloc.dart';

abstract class StopEvent extends Equatable {
  const StopEvent();

  @override
  List<Object> get props => null;
}

class StopConnect extends StopEvent {
  final String stopCode;

  StopConnect(this.stopCode);

  @override
  List<Object> get props => [stopCode];
}

class StopListen extends StopEvent {
  final String data;

  StopListen(this.data);

  @override
  List<Object> get props => [data];
}

class StopDisconnect extends StopEvent {}
