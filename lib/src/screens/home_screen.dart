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
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: null,
            child: Text(Strings.full),
          ),
          bottomNavigationBar: BottomAppBar(
              notchMargin: 8,
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    shape: CircleBorder(),
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
                          size: 20,
                        ),
                        Text(
                          Strings.navQrCode,
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  FlatButton(
                    shape: CircleBorder(),
                    textColor: Colors.black54,
                    onPressed: () => Navigator.of(context).pushNamed("profile",
                        arguments: ProfileScreenArguemnt(user)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          StohpDriver.user,
                          size: 20,
                        ),
                        Text(
                          Strings.navProfile,
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: Colors.black12,
              ))
            ],
          )),
    );
  }
}
