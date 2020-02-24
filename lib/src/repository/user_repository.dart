import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String _tokenKey = "token";

  Future<String> authenticate({@required username, @required password}) async {
    String url = "192.168.0.111:8000/api/v1/auth/login/";
    var response = await http
        .post(url, body: {'username': username, 'password': password});
    return response.body;
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

  Future<bool> hasToken() async {
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: _tokenKey);
    if (value.length <= 0 || value != null) return true;
    return false;
  }
}
