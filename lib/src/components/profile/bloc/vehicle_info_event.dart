part of 'vehicle_info_bloc.dart';

@immutable
abstract class VehicleInfoEvent {}

class SaveVehicleInfo extends VehicleInfoEvent {
  final VehicleInfo vehicleInfo;

  SaveVehicleInfo(this.vehicleInfo);
}
