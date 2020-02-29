import 'package:flutter/material.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class SplashScreen extends StatelessWidget {
  static const String _foregroundImage =
      "assets/icons/logo-banner-foreground.png";
  @override
  Widget build(BuildContext context) {
    final double _usableScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Center(
                child: Image.asset(_foregroundImage, width: 180.0),
              ),
            ),
            Container(
              height: _usableScreenHeight * .05,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colorSecondary, colorPrimary])),
            ),
          ],
        ),
      ),
    );
  }
}
