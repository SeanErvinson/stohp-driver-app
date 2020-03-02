import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:meta/meta.dart';
import 'package:vibration/vibration.dart';

part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  @override
  DialogState get initialState => InitialDialogState();

  @override
  Stream<DialogState> mapEventToState(
    DialogEvent event,
  ) async* {
    if (event is ShowDialog) {
      yield DialogVisible();
    } else {
      FlutterRingtonePlayer.stop();
      Vibration.cancel();
      yield DialogHidden();
    }
  }
}
