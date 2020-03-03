import 'package:enum_to_string/enum_to_string.dart';

class Profile {
  String gender;
  String avatar;
  String vehicle;
  String route;
  String stopCode;

  Profile({this.gender, this.avatar, this.vehicle, this.route, this.stopCode});

  Profile.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    avatar = json['avatar'];
    var vehicleCode = json['vehicle'];
    switch (vehicleCode) {
      case "U":
        vehicle = "UV Express";
        break;
      case "J":
        vehicle = "Jeep";
        break;
      case "B":
        vehicle = "Bus";
        break;
      default:
        vehicle = null;
    }
    route = json['route'];
    stopCode = json['stop_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    if (this.vehicle == "UV Express") {
      data['vehicle'] = EnumToString.parse(Vehicle.U);
    } else if (this.vehicle == "Bus") {
      data['vehicle'] = EnumToString.parse(Vehicle.B);
    } else if (this.vehicle == "Jeep") {
      data['vehicle'] = EnumToString.parse(Vehicle.J);
    }
    data['route'] = this.route;
    data['stop_code'] = this.stopCode;
    return data;
  }
}

enum Vehicle { U, B, J }
