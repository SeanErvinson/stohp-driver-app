import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:stohp_driver_app/src/models/commuter_oversight_info.dart';
import 'package:stohp_driver_app/src/models/driver_oversight_info.dart';
import 'package:stohp_driver_app/src/services/api_service.dart';
import 'package:web_socket_channel/io.dart';

part 'oversight_event.dart';
part 'oversight_state.dart';

class OversightBloc extends Bloc<OversightEvent, OversightState> {
  DriverOversightInfo _driverOversightInfo;
  Map<MarkerId, Marker> markers = {};
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  IOWebSocketChannel _driverCommuterSocket;
  IOWebSocketChannel _commuterDriverSocket;

  StreamSubscription _userLocationSubscription;

  StreamSubscription _driverCommuterSocketSubscription;
  StreamSubscription _commuterDriverSocketSubscription;

  final StreamController<Map<MarkerId, Marker>> _markersController =
      StreamController<Map<MarkerId, Marker>>();

  Stream<Map<MarkerId, Marker>> get outMarkers => _markersController.stream;

  static const String _iconPinAsset = 'assets/icons/dot.png';
  BitmapDescriptor pinCommuterIcon;

  OversightBloc(DriverOversightInfo driverOversightInfo) {
    _driverOversightInfo = driverOversightInfo;

    if (pinCommuterIcon == null) {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 2.5), _iconPinAsset)
          .then((onValue) {
        pinCommuterIcon = onValue;
      });
    }
  }

  @override
  OversightState get initialState => OversightInitial();

  @override
  Stream<OversightState> mapEventToState(
    OversightEvent event,
  ) async* {
    if (event is ConnectRoom) {
      yield* _mapConnectRoom();
    } else if (event is UpdateDriverPosition) {
      yield* _mapUpdateDriverPosition(event.position);
    } else if (event is UpdateCommuterPositions) {
      yield* _mapUpdateCommuterPositions(event.commuterPosition);
    } else if (event is ToggleIsFull) {
      yield* _mapToggleIsFull();
    }
  }

  Stream<OversightState> _mapConnectRoom() async* {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    yield OversightUpdate(position);
    _commuterDriverSocket =
        IOWebSocketChannel.connect('${ApiService.baseWsUrl}/ws/cd_beta/');
    _driverCommuterSocket =
        IOWebSocketChannel.connect('${ApiService.baseWsUrl}/ws/dc_beta/');
    _userLocationSubscription =
        geolocator.getPositionStream().listen((currentPosition) {
      add(UpdateDriverPosition(currentPosition));
    });
    _commuterDriverSocketSubscription =
        _commuterDriverSocket.stream.listen((value) {
      Map jsonData = jsonDecode(value);
      var commuter = CommuterOversightInfo.fromJson(jsonData["cd_info"]);
      if (jsonData["action"] == "disconnect")
        _removeMarker(commuter.id);
      else
        add(UpdateCommuterPositions(commuter));
    });
  }

  Stream<OversightState> _mapUpdateDriverPosition(Position position) async* {
    _driverOversightInfo.lat = position.latitude;
    _driverOversightInfo.lng = position.longitude;
    Map driverData = {
      "dc_info": _driverOversightInfo.toJson(),
      "action": null,
    };
    var jsonData = jsonEncode(driverData);
    _driverCommuterSocket.sink.add(jsonData);
    yield OversightUpdate(position);
  }

  Stream<OversightState> _mapToggleIsFull() async* {
    _driverOversightInfo.isFull = !_driverOversightInfo.isFull;
  }

  Stream<OversightState> _mapUpdateCommuterPositions(
      CommuterOversightInfo commuterPosition) async* {
    _createUpdateMarker(commuterPosition);
    _markersController.sink.add(markers);
  }

  void _createUpdateMarker(CommuterOversightInfo position) {
    final MarkerId _markerId = MarkerId(position.id.toString());
    markers.update(_markerId, (marker) {
      return marker.copyWith(positionParam: LatLng(position.lat, position.lng));
    }, ifAbsent: () {
      return Marker(
        draggable: false,
        markerId: _markerId,
        position: LatLng(position.lat, position.lng),
        icon: pinCommuterIcon,
      );
    });
  }

  void _removeMarker(String id) {
    final MarkerId _markerId = MarkerId(id);
    markers.remove(_markerId);
    _markersController.sink.add(markers);
  }

  @override
  Future<void> close() {
    var jsonData = _driverOversightInfo.toJson();
    jsonData["action"] = "disconnect";
    print(jsonData);
    _driverCommuterSocket.sink.add(jsonEncode(jsonData));
    _closeSockets();
    return super.close();
  }

  void _closeSockets() {
    _driverCommuterSocket.sink.close();
    _commuterDriverSocket.sink.close();
    _userLocationSubscription?.cancel();
    _driverCommuterSocketSubscription?.cancel();
    _commuterDriverSocketSubscription?.cancel();
    _markersController.close();
  }
}
