import 'package:enum_to_string/enum_to_string.dart';

class Profile {
  String gender;
  String avatar;
  String vehicle;
  String route;
  String stopCode;

  Profile({this.gender, this.avatar, this.vehicle, this.route, this.stopCode});

  Profile.fromJson(Map<String, dynamic> json) {
    vehicle = json["vehicle"];
    avatar = json['avatar'];
    gender = json["gender"];
    route = json['route'];
    stopCode = json['stop_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['vehicle'] = this.vehicle;
    data['gender'] = this.gender;
    data['route'] = this.route;
    data['stop_code'] = this.stopCode;
    return data;
  }
}