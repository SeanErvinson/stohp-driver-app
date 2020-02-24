import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStarted();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event.token);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStarted() async* {
    final String token = await userRepository.getToken();

    if (token != null) {
      try {
        User user = await userRepository.getUser(token);
        yield Authenticated(user);
      } catch (_) {
        yield Unauthenticated();
      }
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(token) async* {
    await userRepository.persistToken(token);
    User user = await userRepository.getUser(token);
    yield (Authenticated(user));
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield (Unauthenticated());
    await userRepository.deleteToken();
  }
}
