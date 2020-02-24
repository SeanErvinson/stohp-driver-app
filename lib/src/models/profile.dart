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
    vehicle = json['vehicle'];
    route = json['route'];
    stopCode = json['stop_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['vehicle'] = this.vehicle;
    data['route'] = this.route;
    data['stop_code'] = this.stopCode;
    return data;
  }
}