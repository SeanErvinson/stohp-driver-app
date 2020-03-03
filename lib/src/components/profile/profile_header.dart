import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/components/profile/profile_picture.dart';
import 'package:stohp_driver_app/src/models/user.dart';

import 'bloc/profile_picture_bloc.dart';
import 'edit_profile.dart';

class ProfileHeader extends StatelessWidget {
  static const String _defaultProfilePic =
      "assets/images/default-profile-pic.png";
  const ProfileHeader({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final _profilePictireBloc = ProfilePictureBloc();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
            child: ProfilePicture(
                profilePictireBloc: _profilePictireBloc, user: user),
          ),
          EditProfile(profilePictireBloc: _profilePictireBloc),
          Text(
            user.firstName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                user.profile.vehicle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              VerticalDivider(
                color: Colors.red,
                thickness: 14,
              ),
              Text(
                user.profile.route,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          boxShadow: []),
    );
  }
}
