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
              ImageConfiguration(devicePixelRatio: 1.75), _iconPinAsset)
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
    } else if (event is DisconnectRoom) {
      yield* _mapDisconnectRoom();
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
      _parseCommuterData(jsonData);
    });
  }

  Stream<OversightState> _mapDisconnectRoom() async* {
    markers.clear();
    _sendDisconnectRequest();
    _closeSockets();
    yield OversightInitial();
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
      CommuterOversightInfo commuter) async* {
    if (_driverOversightInfo.vehicleType != commuter.vehicleType &&
        commuter.vehicleType != null) {
      _removeMarker(commuter.id);
      return;
    }
    if (commuter.route != null &&
        !_driverOversightInfo.route
            .toLowerCase()
            .contains(commuter.route.toLowerCase())) {
      _removeMarker(commuter.id);
      return;
    }
    _createUpdateMarker(commuter);
    _markersController.sink.add(markers);
  }

  void _parseCommuterData(Map jsonData) {
    if (jsonData["cd_info"] == null) return;
    var commuter = CommuterOversightInfo.fromJson(jsonData["cd_info"]);
    if (jsonData["action"] == "disconnect") {
      _removeMarker(commuter.id);
      return;
    }
    add(UpdateCommuterPositions(commuter));
  }

  void _sendDisconnectRequest() {
    Map driverData = {
      "dc_info": {
        "id": _driverOversightInfo.id,
      },
      "action": "disconnect",
    };
    var jsonData = jsonEncode(driverData);
    _driverCommuterSocket.sink.add(jsonData);
  }

  void _createUpdateMarker(CommuterOversightInfo commuter) {
    final MarkerId _markerId = MarkerId(commuter.id.toString());
    markers.update(_markerId, (marker) {
      return marker.copyWith(positionParam: LatLng(commuter.lat, commuter.lng));
    }, ifAbsent: () {
      return Marker(
        draggable: false,
        consumeTapEvents: true,
        markerId: _markerId,
        position: LatLng(commuter.lat, commuter.lng),
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
    _sendDisconnectRequest();
    _closeSockets();
    return super.close();
  }

  Future<void> _closeSockets() async {
    await _driverCommuterSocket.sink?.close();
    await _userLocationSubscription?.cancel();
    await _commuterDriverSocketSubscription?.cancel();
    await _commuterDriverSocket.sink?.close();
  }
}
