import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stohp_driver_app/src/services/api_service.dart';
import 'package:vibration/vibration.dart';
import 'package:web_socket_channel/io.dart';

part 'stop_event.dart';
part 'stop_state.dart';

class StopBloc extends Bloc<StopEvent, StopState> {
  IOWebSocketChannel _socket;
  StreamSubscription _wsSubscription;

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    return super.close();
  }

  @override
  StopState get initialState => StopInitial();

  @override
  Stream<StopState> mapEventToState(
    StopEvent event,
  ) async* {
    if (event is StopConnect) {
      yield* _mapStopConnect(event.stopCode);
    } else if (event is StopListen) {
      yield* _mapStopListen(event.data);
    } else if (event is StopDisconnect) {
      yield* _mapStopDisconnect();
    }
  }

  Stream<StopState> _mapStopConnect(String stopCode) async* {
    _socket = IOWebSocketChannel.connect(
        'ws://${ApiService.baseUrl}/ws/stop/$stopCode/');
    _wsSubscription = _socket.stream.listen((data) => add(StopListen(data)));
  }

  Stream<StopState> _mapStopListen(String data) async* {
    Vibration.vibrate();
    yield StopListening();
  }

  Stream<StopState> _mapStopDisconnect() async* {
    _socket.sink.close();
    _wsSubscription?.cancel();
    yield StopInitial();
  }
}
