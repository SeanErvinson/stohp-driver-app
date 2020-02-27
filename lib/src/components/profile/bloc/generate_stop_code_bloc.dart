import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';

part 'generate_stop_code_event.dart';
part 'generate_stop_code_state.dart';

class GenerateStopCodeBloc
    extends Bloc<GenerateStopCodeEvent, GenerateStopCodeState> {
  final UserRepository _userRepository;

  GenerateStopCodeBloc(UserRepository userRepository)
      : _userRepository = userRepository;
  @override
  GenerateStopCodeState get initialState => GenerateStopCodeInitial();

  @override
  Stream<GenerateStopCodeState> mapEventToState(
    GenerateStopCodeEvent event,
  ) async* {
    if (event is GenerateStopCode) {
      yield* _mapGenerateStopCode();
    }
  }

  Stream<GenerateStopCodeState> _mapGenerateStopCode() async* {
    try {
      String newStopCOde = await _userRepository.getStopCode();
      yield GenerateStopCodeFinished(newStopCOde);
    } catch (_) {
      yield GenerateStopCodeFailed();
    }
  }
}
