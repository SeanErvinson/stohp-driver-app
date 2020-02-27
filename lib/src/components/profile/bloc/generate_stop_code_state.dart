part of 'generate_stop_code_bloc.dart';

@immutable
abstract class GenerateStopCodeState {}

class GenerateStopCodeInitial extends GenerateStopCodeState {}

class GenerateStopCodeRunning extends GenerateStopCodeState {}

class GenerateStopCodeFinished extends GenerateStopCodeState {
  final String newStopCode;

  GenerateStopCodeFinished(this.newStopCode);
}

class GenerateStopCodeFailed extends GenerateStopCodeState {}
