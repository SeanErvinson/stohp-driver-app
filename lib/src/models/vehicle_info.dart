class VehicleInfo {
  String id;
  String username;
  String route;
  String vehicleType;

  VehicleInfo({this.id, this.username, this.route, this.vehicleType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': this.id,
      'username': this.username,
      'profile': {'route': this.route, 'vehicle': this.vehicleType}
    };
    return data;
  }
}
