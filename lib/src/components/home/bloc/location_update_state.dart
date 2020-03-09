part of 'location_update_bloc.dart';

@immutable
abstract class LocationUpdateState {}

class LocationUpdateInitial extends LocationUpdateState {}

class LocationTurnOnUpdate extends LocationUpdateState {}

class LocationTurnOffUpdate extends LocationUpdateState {}
