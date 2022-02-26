import 'package:flutter/material.dart';
import 'package:multi_platform_example/Background.dart';
import 'package:multi_platform_example/HomePage.dart';
import 'package:multi_platform_example/scanCode.dart';
import 'package:multi_platform_example/threeDViewPage.dart';
import 'package:multi_platform_example/video.dart';
import 'package:splashscreen/splashscreen.dart';




import 'DrivingPage.dart';

void main() {

  runApp(MyApp(),);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech To Text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      // VideoPage()
      SplashScreen(
          seconds: 5,
          navigateAfterSeconds:  HomePage(),
          //title: new Text('The Virtual Ride',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
          image: new Image.asset('assets/heading.png',),
          backgroundColor: Colors.black,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 200.0,
          loaderColor: Colors.red
      ),
      //HomePage()
      // DrivePage(title: 'Speech To Text Demo Home Page'),
    );
  }
}


