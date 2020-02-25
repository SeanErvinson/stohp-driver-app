import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/components/common/bloc/authentication_bloc.dart';
import 'package:stohp_driver_app/src/components/login/bloc/login_bloc.dart';
import 'package:stohp_driver_app/src/components/login/form.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository userRepository;

  LoginScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            userRepository: userRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 20,
                      color: Colors.black54,
                    ),
                    Text(
                      Strings.login,
                      style: navigationDarkTitle,
                    ),
                  ],
                ),
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
