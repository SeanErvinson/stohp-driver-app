import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/models/vehicle_info.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';

part 'vehicle_info_event.dart';
part 'vehicle_info_state.dart';

class VehicleInfoBloc extends Bloc<VehicleInfoEvent, VehicleInfoState> {
  @override
  VehicleInfoState get initialState => VehicleInfoInitial();
  final UserRepository _userRepository = UserRepository();

  @override
  Stream<VehicleInfoState> mapEventToState(
    VehicleInfoEvent event,
  ) async* {
    if (event is SaveVehicleInfo) {
      yield* _mapSavePersonalInfo(event.vehicleInfo);
    }
  }

  Stream<VehicleInfoState> _mapSavePersonalInfo(VehicleInfo vehicleInfo) async* {
    yield VehicleInfoSaving();
    User updatedUser = await _userRepository.updateVehicleInfo(vehicleInfo);
    if (updatedUser != null) {
      yield VehicleInfoSuccess(updatedUser);
    } else {
      yield VehicleInfoFailed(updatedUser);
    }
  }
}
