import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/components/common/bloc/greet_bloc.dart';
import 'package:stohp_driver_app/src/components/common/stohp_driver_icons.dart';
import 'package:stohp_driver_app/src/components/common/stop_code_argument.dart';
import 'package:stohp_driver_app/src/components/home/bloc/location_update_bloc.dart';
import 'package:stohp_driver_app/src/components/home/bloc/oversight_bloc.dart';
import 'package:stohp_driver_app/src/components/home/bloc/space_bloc.dart';
import 'package:stohp_driver_app/src/components/home/oversight_map.dart';
import 'package:stohp_driver_app/src/components/profile/profile_screen_argument.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _usableScreenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    List<Color> headerColor;
    Color fabColor;
    String fabText;
    VoidCallback spaceEvent;
    return SafeArea(
      child: BlocBuilder<SpaceBloc, SpaceState>(
        bloc: BlocProvider.of<SpaceBloc>(context),
        builder: (context, state) {
          if (state is NoSpace) {
            headerColor = [redSecondary, redPrimary];
            fabText = Strings.space;
            fabColor = greenPrimary;
            spaceEvent = () {
              BlocProvider.of<SpaceBloc>(context).add(SpaceHas());
              BlocProvider.of<OversightBloc>(context).add(ToggleIsFull());
            };
          } else {
            headerColor = [greenPrimary, bluePrimary];
            fabText = Strings.full;
            fabColor = colorPrimary;
            spaceEvent = () {
              BlocProvider.of<SpaceBloc>(context).add(SpaceFull());
              BlocProvider.of<OversightBloc>(context).add(ToggleIsFull());
            };
          }
          return Scaffold(
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: fabColor,
              onPressed: spaceEvent,
              child: Text(
                fabText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                      onPressed: () => Navigator.of(context).pushNamed(
                          "profile",
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
                Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: headerColor,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: _usableScreenHeight * .08,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: BlocBuilder<GreetBloc, GreetState>(
                            bloc: BlocProvider.of<GreetBloc>(context),
                            builder: (context, state) {
                              String greetings = Strings.greetingsDefault;
                              if (state is GreetMorning) {
                                greetings = Strings.greetingsMorning;
                              }
                              if (state is GreetAfternoon) {
                                greetings = Strings.greetingsAfternoon;
                              }
                              if (state is GreetEvening) {
                                greetings = Strings.greetingsEvening;
                              }
                              return RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: greetings,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                    children: [
                                      TextSpan(text: "\n"),
                                      TextSpan(
                                        text: "${user.firstName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.0),
                                      ),
                                    ]),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: BlocBuilder<LocationUpdateBloc,
                              LocationUpdateState>(
                            bloc: BlocProvider.of<LocationUpdateBloc>(context),
                            builder: (context, state) {
                              IconData icon;
                              Color color;
                              VoidCallback onPressed;
                              if (state is LocationTurnOffUpdate) {
                                icon = Icons.power_settings_new;
                                color = Colors.grey;
                                onPressed = () =>
                                    BlocProvider.of<LocationUpdateBloc>(context)
                                        .add(TurnOnUpdate());
                              } else if (state is LocationTurnOnUpdate) {
                                icon = Icons.power_settings_new;
                                color = Colors.white;
                                onPressed = () =>
                                    BlocProvider.of<LocationUpdateBloc>(context)
                                        .add(TurnOffUpdate());
                              }
                              return IconButton(
                                icon: Icon(
                                  icon,
                                  color: color,
                                ),
                                onPressed: onPressed,
                              );
                            },
                          ),
                        )
                      ],
                    )),
                Expanded(child: OversightMap())
              ],
            ),
          );
        },
      ),
    );
  }
}
