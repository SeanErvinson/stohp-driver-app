import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stohp_driver_app/src/components/common/stop_code_argument.dart';
import 'package:stohp_driver_app/src/values/values.dart';

class StopCodeScreen extends StatefulWidget {
  @override
  _StopCodeScreenState createState() => _StopCodeScreenState();
}

class _StopCodeScreenState extends State<StopCodeScreen> {
  GlobalKey globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    final StopCodeArgument args = ModalRoute.of(context).settings.arguments;
    print(args);
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  label: Text("Back"),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Center(
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                      data: args.stopCode,
                      size: 320,
                      version: QrVersions.auto,
                      padding: EdgeInsets.all(16),
                      embeddedImage: AssetImage('assets/icons/logo-banner.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(64, 64),
                      ),
                    ),
                  ),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.save_alt),
                  onPressed: _captureAndSharePng,
                  textColor: bluePrimary,
                  label: Text(Strings.saveImage),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: Strings.generateInstruction1,
                  children: [
                    TextSpan(
                        text: Strings.generateInstruction2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87))
                  ],
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final pathDir = await getExternalStorageDirectory();
      final file = await new File('${pathDir.path}/stop-code.png').create();
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      print(e.toString());
    }
  }
}
