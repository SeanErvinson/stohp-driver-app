import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/services/api_service.dart';

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
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
            child: CircleAvatar(
              maxRadius: 28,
              backgroundImage: user.profile.avatar != null
                  ? NetworkImage(ApiService.baseUrl + user.profile.avatar)
                  : AssetImage(_defaultProfilePic),
            ),
          ),
          Text(
            user.firstName,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          boxShadow: []),
    );
  }
}
