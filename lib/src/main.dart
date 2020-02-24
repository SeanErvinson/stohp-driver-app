import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';
import 'package:stohp_driver_app/src/screens/screens.dart';
import 'package:stohp_driver_app/src/values/values.dart';

import 'components/common/DefualtBlocDelegate.dart';
import 'components/common/bloc/authentication_bloc.dart';

void main() {
  BlocSupervisor.delegate = DefaultBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: StohpDriverApp(userRepository: userRepository),
    ),
  );
}

class StohpDriverApp extends StatelessWidget {
  final UserRepository userRepository;

  StohpDriverApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "welcome": (context) => WelcomeScreen(),
        "login": (context) => LoginScreen(
              userRepository: userRepository,
            ),
        "registration": (context) => RegistrationScreen(),
        "setting": (context) => SettingScreen(),
        "home": (context) => HomeScreen(),
        "splash": (context) => SplashScreen(),
      },
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            return HomeScreen(
              user: state.user,
            );
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
