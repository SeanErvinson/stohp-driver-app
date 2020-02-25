import 'package:flutter/material.dart';
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
              notchMargin: 4.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                        "stop-code",
                        arguments: StopCodeArgument(user.profile.stopCode)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.code,
                          size: 32,
                        ),
                        Text(Strings.navQrCode)
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pushNamed("profile",
                        arguments: ProfileScreenArguemnt(user)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.person_outline,
                          size: 32,
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
                color: Colors.deepPurple,
              ))
            ],
          )),
    );
  }
}
