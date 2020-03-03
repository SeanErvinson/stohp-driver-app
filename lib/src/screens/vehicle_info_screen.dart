import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/components/profile/user_screen_argument.dart';
import 'package:stohp_driver_app/src/components/profile/vehicle_info_form.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class ProfileVehicleInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserArgument args = ModalRoute.of(context).settings.arguments;
    final User user = args.user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AppBar(
            titleSpacing: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black87,
            ),
            title: Text(
              Strings.vehicleInfoHeader,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ),
        body: VehicleInfoForm(user: user),
      ),
    );
  }
}
