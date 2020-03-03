part of 'vehicle_info_bloc.dart';

@immutable
abstract class VehicleInfoState {}

class VehicleInfoInitial extends VehicleInfoState {}

class VehicleInfoSuccess extends VehicleInfoInitial {
  final User user;

  VehicleInfoSuccess(this.user);
}

class VehicleInfoFailed extends VehicleInfoInitial {
  final User user;

  VehicleInfoFailed(this.user);
}

class VehicleInfoSaving extends VehicleInfoInitial {}
