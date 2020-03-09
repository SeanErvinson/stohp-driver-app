import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stohp_driver_app/src/components/home/bloc/oversight_bloc.dart';

part 'location_update_event.dart';
part 'location_update_state.dart';

class LocationUpdateBloc
    extends Bloc<LocationUpdateEvent, LocationUpdateState> {
  final OversightBloc _oversightBloc;

  LocationUpdateBloc(OversightBloc oversightBloc)
      : _oversightBloc = oversightBloc;
  @override
  LocationUpdateState get initialState => LocationTurnOnUpdate();

  @override
  Stream<LocationUpdateState> mapEventToState(
    LocationUpdateEvent event,
  ) async* {
    if (event is TurnOffUpdate) {
      yield* _mapTurnOffUpdate();
    } else if (event is TurnOnUpdate) {
      yield* _mapTurnOnUpdate();
    }
  }

  Stream<LocationUpdateState> _mapTurnOnUpdate() async* {
    _oversightBloc.add(ConnectRoom());
    yield LocationTurnOnUpdate();
  }

  Stream<LocationUpdateState> _mapTurnOffUpdate() async* {
    _oversightBloc.add(DisconnectRoom());
    yield LocationTurnOffUpdate();
  }
}
