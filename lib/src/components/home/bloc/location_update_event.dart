part of 'location_update_bloc.dart';

@immutable
abstract class LocationUpdateEvent {}

class TurnOnUpdate extends LocationUpdateEvent {}

class TurnOffUpdate extends LocationUpdateEvent {}
