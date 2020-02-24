import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/screens/screens.dart';
import 'package:stohp_driver_app/src/values/values.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "welcome": (context) => WelcomeScreen(),
        "login": (context) => LoginScreen(),
        "registration": (context) => RegistrationScreen(),
        "setting": (context) => SettingScreen(),
        "home": (context) => HomeScreen(),
        "splash": (context) => SplashScreen(),
      },
      home: HomeScreen()
    );
  }
}
