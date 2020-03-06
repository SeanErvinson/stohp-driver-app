part of 'oversight_bloc.dart';

@immutable
abstract class OversightEvent {}

class ConnectRoom extends OversightEvent {}

class UpdateDriverPosition extends OversightEvent {
  final Position position;

  UpdateDriverPosition(this.position);
}

class UpdateCommuterPositions extends OversightEvent {
  final CommuterPosition commuterPosition;

  UpdateCommuterPositions(this.commuterPosition);
}

class DisconnectRoom extends OversightEvent {}

class ToggleIsFull extends OversightEvent {}
