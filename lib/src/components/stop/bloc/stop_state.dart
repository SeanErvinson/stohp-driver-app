part of 'stop_bloc.dart';

abstract class StopState extends Equatable {
  const StopState();

  @override
  List<Object> get props => [];
}

class StopInitial extends StopState {}

class StopListening extends StopState {}

class StopReceived extends StopState {}