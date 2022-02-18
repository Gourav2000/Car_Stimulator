import 'package:flutter/material.dart';
import 'package:multi_platform_example/HomePage.dart';
import 'package:multi_platform_example/threeDViewPage.dart';


import 'DrivingPage.dart';

void main() {
  runApp(MyApp());
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
      home: HomePage()
      // DrivePage(title: 'Speech To Text Demo Home Page'),
    );
  }
}


