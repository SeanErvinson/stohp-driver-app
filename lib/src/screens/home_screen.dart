import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/components/common/stohp_driver_icons.dart';
import 'package:stohp_driver_app/src/components/common/stop_code_argument.dart';
import 'package:stohp_driver_app/src/components/profile/profile_screen_argument.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: null,
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text(Strings.navTrip), Text("0")],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.black54,
                    onPressed: () => Navigator.of(context).pushNamed(
                        "stop-code",
                        arguments: StopCodeArgument(user.profile.stopCode)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          StohpDriver.qr,
                          size: 16,
                        ),
                        Text(Strings.navQrCode)
                      ],
                    ),
                  ),
                  FlatButton(
                    textColor: Colors.black54,
                    onPressed: () => Navigator.of(context).pushNamed("profile",
                        arguments: ProfileScreenArguemnt(user)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          StohpDriver.user,
                          size: 16,
                        ),
                        Text(Strings.navProfile)
                      ],
                    ),
                  ),
                ],
              )),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: Colors.white,
              ))
            ],
          )),
    );
  }
}
