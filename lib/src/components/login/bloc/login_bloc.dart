import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';
import 'package:stohp_driver_app/src/validation/validation.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! OnUsernameChanged && event is! OnPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is OnUsernameChanged || event is OnPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is OnUsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is OnPasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        username: event.username,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapUsernameChangedToState(String username) async* {
    yield state.update(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String username,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      final token = await _userRepository.authenticate(
        username: username,
        password: password,
      );
      await _userRepository.persistToken(token);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
