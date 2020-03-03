import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';

part 'personal_info_event.dart';
part 'personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  @override
  PersonalInfoState get initialState => PersonalInfoInitial();
  final UserRepository _userRepository = UserRepository();
  @override
  Stream<PersonalInfoState> mapEventToState(
    PersonalInfoEvent event,
  ) async* {
    if (event is SavePersonalInfo) {
      yield* _mapSavePersonalInfo(event.user);
    }
  }

  Stream<PersonalInfoState> _mapSavePersonalInfo(User user) async* {
    yield PersonalInfoSaving();
    User updatedUser = await _userRepository.updatePersonalInfo(user);
    if (updatedUser != null) {
      yield PersonalInfoSuccess(updatedUser);
    } else {
      yield PersonalInfoFailed(user);
    }
  }
}
