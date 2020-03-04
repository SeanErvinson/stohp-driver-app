import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stohp_driver_app/src/models/personal_info.dart';
import 'package:stohp_driver_app/src/models/user.dart';
import 'package:stohp_driver_app/src/models/vehicle_info.dart';
import 'package:stohp_driver_app/src/services/api_service.dart';
import 'package:stohp_driver_app/src/services/app_exception.dart';

class UserRepository {
  final String _tokenKey = "token";

  Future<String> authenticate({@required username, @required password}) async {
    String url = "${ApiService.baseUrl}/api/v1/auth/login/";
    var response = await http
        .post(url, body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      Map<String, dynamic> token = jsonDecode(response.body);
      return token["token"];
    }
    return null;
  }

  Future<User> getUser(String token) async {
    String url = "${ApiService.baseUrl}/api/v1/users/access-user/";
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var user = User.fromJson(jsonData["user"]);
      return user;
    }
    return null;
  }

  Future<void> deleteToken() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: _tokenKey);
    return;
  }

  Future<void> persistToken(String token) async {
    if (token == null) return;
    final storage = new FlutterSecureStorage();
    await storage.write(key: _tokenKey, value: token);
    return;
  }

  Future<String> getToken() async {
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: _tokenKey);
    if (value != null) return value;
    return null;
  }

  Future<String> getStopCode() async {
    String url = "${ApiService.baseUrl}/api/v1/users/generate-stop-code/";
    var token = await getToken();
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    }
    throw BadRequestException(response.body.toString());
  }

  Future<String> uploadAvatar(String filename, String base64Image) async {
    String url = "${ApiService.baseUrl}/api/v1/users/upload/";
    Map body = {
      "avatar": base64Image,
    };
    var token = await getToken();
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["avatar"];
    } else {
      return null;
    }
  }

  Future<User> updatePersonalInfo(PersonalInfo personalInfo) async {
    String url = "${ApiService.baseUrl}/api/v1/users/${personalInfo.id}/";
    var token = await getToken();
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(personalInfo.toJson()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var resultUser = User.fromJson(jsonData);
      return resultUser;
    } else {
      return null;
    }
  }

  Future<User> updateVehicleInfo(VehicleInfo vehicleInfo) async {
    String url = "${ApiService.baseUrl}/api/v1/users/${vehicleInfo.id}/";
    var token = await getToken();
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(vehicleInfo.toJson()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var resultUser = User.fromJson(jsonData);
      return resultUser;
    } else {
      return null;
    }
  }
}
