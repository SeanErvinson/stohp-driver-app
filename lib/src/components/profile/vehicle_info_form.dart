import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/values/values.dart';

import 'bloc/vehicle_info_bloc.dart';

class VehicleInfoForm extends StatefulWidget {
  final User _user;

  const VehicleInfoForm({Key key, User user})
      : this._user = user,
        super(key: key);

  @override
  _VehicleInfoFormState createState() => _VehicleInfoFormState(_user);
}

class _VehicleInfoFormState extends State<VehicleInfoForm> {
  User user;
  final TextEditingController _routeController = TextEditingController();
  final VehicleInfoBloc _bloc = VehicleInfoBloc();
  _VehicleInfoFormState(this.user);
  String _dropDownValue;
  List<String> _vehicleType = [
    "UV Express",
    "Bus",
    "Jeep",
  ];
  @override
  void initState() {
    _routeController.text =
        user.profile.route != null ? user.profile.route : "";
    _dropDownValue = user.profile.vehicle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleInfoBloc, VehicleInfoState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is VehicleInfoSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.updateSuccess,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Icon(Icons.error, size: 20.0)
                  ],
                ),
                backgroundColor: greenPrimary,
              ),
            );
        } else if (state is VehicleInfoFailed) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.updateFailed,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Icon(Icons.error, size: 20.0)
                  ],
                ),
                backgroundColor: redPrimary,
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _routeController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: Strings.route,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, size: 14.0),
                      onPressed: () => _routeController.clear(),
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  isDense: true,
                  hint: _dropDownValue == null
                      ? Text(Strings.vehicleType)
                      : Text(_dropDownValue,
                          style: TextStyle(color: Colors.blue)),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: Strings.vehicleType,
                  ),
                  value: _dropDownValue,
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValue = val;
                      },
                    );
                  },
                  items: _vehicleType
                      .map((value) => DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          Container(
            width: double.infinity,
            child: BlocBuilder<VehicleInfoBloc, VehicleInfoState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is VehicleInfoSuccess) {
                  user = state.user;
                }
                return FlatButton(
                  child: Text(
                    Strings.save,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  color: colorSecondary,
                  onPressed: () {
                    User newUser = user;
                    newUser.profile.route = _routeController.text.length != 0
                        ? _routeController.text
                        : user.profile.route;
                    newUser.profile.vehicle = _dropDownValue;
                    _bloc.add(SaveVehicleInfo(newUser));
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _routeController.dispose();
    super.dispose();
  }
}
