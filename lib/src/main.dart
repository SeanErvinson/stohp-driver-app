import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/components/common/bloc/dialog_bloc.dart';
import 'package:stohp_driver_app/src/components/common/stop_dialog.dart';
import 'package:stohp_driver_app/src/components/home/bloc/space_bloc.dart';
import 'package:stohp_driver_app/src/components/stop/bloc/stop_bloc.dart';
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
      child: BlocProvider<DialogBloc>(
        create: (context) => DialogBloc(),
        child: BlocProvider<StopBloc>(
          create: (context) => StopBloc(BlocProvider.of<DialogBloc>(context)),
          child: StohpDriverApp(userRepository: userRepository),
        ),
      ),
    ),
  );
}

class StohpDriverApp extends StatelessWidget {
  final UserRepository userRepository;

  StohpDriverApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: Colors.blue,
      ),
      routes: {
        "welcome": (context) => WelcomeScreen(),
        "login": (context) => LoginScreen(
              userRepository: userRepository,
            ),
        "registration": (context) => RegistrationScreen(),
        "profile": (context) => ProfileScreen(),
        "home": (context) => HomeScreen(),
        "stop-code": (context) => StopCodeScreen(),
        "splash": (context) => SplashScreen(),
      },
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            BlocProvider.of<StopBloc>(context)
                .add(StopConnect(state.user.profile.stopCode));
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Authenticated) {
              return BlocBuilder<DialogBloc, DialogState>(
                condition: (previousState, state) {
                  if (previousState is DialogVisible &&
                      state is DialogVisible) {
                    return false;
                  }
                  return true;
                },
                bloc: BlocProvider.of<DialogBloc>(context),
                builder: (context, dialogState) {
                  if (dialogState is DialogVisible) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StopDialog(
                            bloc: BlocProvider.of<DialogBloc>(context),
                          );
                        },
                      );
                    });
                  }
                  return BlocProvider<SpaceBloc>(
                    create: (context) => SpaceBloc()..add(SpaceHas()),
                    child: HomeScreen(
                      user: state.user,
                    ),
                  );
                },
              );
            }
            if (state is Unauthenticated) {
              return WelcomeScreen();
            }
            if (state is AuthenticationLoading) {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
