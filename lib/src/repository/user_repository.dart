import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stohp_driver_app/src/models/user.dart';

class UserRepository {
  final String _tokenKey = "token";

  Future<String> authenticate({@required username, @required password}) async {
    String url = "http://192.168.0.111:8000/api/v1/auth/login/";
    var response = await http
        .post(url, body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      Map<String, dynamic> token = jsonDecode(response.body);
      return token["token"];
    }
    return null;
  }

  Future<User> getUser(String token) async {
    String url = "http://192.168.0.111:8000/api/v1/users/access-user/";
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var user = User.fromJson(jsonData);
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
}
