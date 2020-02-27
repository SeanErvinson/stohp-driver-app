import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/components/stop/bloc/stop_bloc.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';
import 'package:stohp_driver_app/src/values/values.dart';

import 'bloc/generate_stop_code_bloc.dart';

class GenerateStopCodeDialog extends StatelessWidget {
  final User _user;
  final UserRepository _userRepository;
  const GenerateStopCodeDialog(
      {Key key, UserRepository userRepository, User user})
      : _userRepository = userRepository,
        _user = user,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bloc = GenerateStopCodeBloc(_userRepository);
    return BlocBuilder<GenerateStopCodeBloc, GenerateStopCodeState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is GenerateStopCodeRunning) {
          return AlertDialog(
            content: CircularProgressIndicator(),
          );
        } else if (state is GenerateStopCodeFinished) {
          _user.profile.stopCode = state.newStopCode;
          BlocProvider.of<StopBloc>(context).add(StopDisconnect());
          BlocProvider.of<StopBloc>(context)
              .add(StopConnect(state.newStopCode));
          return AlertDialog(
            content: Text(Strings.generateStopCodeSuccess),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  Strings.okOption,
                  style: secondaryAppText.copyWith(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else if (state is GenerateStopCodeFailed) {
          return AlertDialog(
            content: Text(Strings.generateStopCodeFailed),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  Strings.okOption,
                  style: secondaryAppText.copyWith(fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentTextStyle: primaryBaseText.copyWith(fontSize: 14.0),
            content: Text(
              Strings.generateConfirmation,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  Strings.noOption,
                  style: secondaryBaseText.copyWith(fontSize: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(
                  Strings.yesOption,
                  style: secondaryAppText.copyWith(fontSize: 12),
                ),
                onPressed: () {
                  _bloc.add(GenerateStopCode());
                },
              ),
            ],
          );
        }
      },
    );
  }
}
