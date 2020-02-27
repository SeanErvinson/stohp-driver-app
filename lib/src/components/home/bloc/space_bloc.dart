import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'space_event.dart';
part 'space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  @override
  SpaceState get initialState => SpaceInitial();

  @override
  Stream<SpaceState> mapEventToState(
    SpaceEvent event,
  ) async* {
    if (event is SpaceFull) {
      yield NoSpace();
    } else if (event is SpaceHas) {
      yield HasSpace();
    }
  }
}
