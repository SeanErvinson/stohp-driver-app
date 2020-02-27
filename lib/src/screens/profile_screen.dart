import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stohp_driver_app/src/components/common/bloc/authentication_bloc.dart';
import 'package:stohp_driver_app/src/components/common/stohp_driver_icons.dart';
import 'package:stohp_driver_app/src/components/profile/generate_stop_code_dialog.dart';
import 'package:stohp_driver_app/src/components/profile/profile_header.dart';
import 'package:stohp_driver_app/src/components/profile/profile_screen_argument.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/repository/user_repository.dart';
import 'package:stohp_driver_app/src/services/api_service.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class ProfileScreen extends StatelessWidget {
  final userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    final ProfileScreenArguemnt args =
        ModalRoute.of(context).settings.arguments;
    final User user = args.user;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            BackAppBar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileHeader(user: user),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              Strings.accountSettings,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              itemExtent: 40,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(Strings.personalInfo),
                                  trailing: Icon(
                                    StohpDriver.user,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(Strings.vehicleInfo),
                                  trailing: Icon(
                                    Icons.directions_car,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return GenerateStopCodeDialog(
                                          user: user,
                                          userRepository: userRepository,
                                        );
                                      },
                                    );
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(Strings.generateStopCode),
                                  trailing: Icon(
                                    StohpDriver.arrows_cw,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(Strings.logout),
                            trailing: Icon(
                              Icons.exit_to_app,
                              size: 24,
                              color: Colors.black87,
                            ),
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  titlePadding: EdgeInsets.zero,
                                  contentTextStyle:
                                      primaryBaseText.copyWith(fontSize: 14.0),
                                  content: Text(
                                    Strings.logoutConfirmation,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        Strings.cancel,
                                        style: secondaryBaseText.copyWith(
                                            fontSize: 12),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        Strings.logout,
                                        style: secondaryAppText.copyWith(
                                            fontSize: 12),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        BlocProvider.of<AuthenticationBloc>(
                                                context)
                                            .add(LoggedOut());
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackAppBar extends StatelessWidget {
  const BackAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(Strings.navProfile),
      ],
    );
  }
}