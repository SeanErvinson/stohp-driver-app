part of 'vehicle_info_bloc.dart';

@immutable
abstract class VehicleInfoEvent {}

class SaveVehicleInfo extends VehicleInfoEvent {
  final User user;

  SaveVehicleInfo(this.user);
}
