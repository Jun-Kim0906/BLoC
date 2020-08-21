
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.Dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  final int duration;
  const SplashScreen({this.duration});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                height: height * 0.263,
                width: width * 0.538,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                      child: Image.asset('assets/launcher_icon2.png')
                  ),
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                height: height * 0.277,
                width: width * 0.702,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextLiquidFill(
                   text: '농플',
                    waveColor: Colors.blueAccent,
                    loadDuration: Duration(seconds: widget.duration),
                    waveDuration: Duration(seconds: widget.duration),
                    boxBackgroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
