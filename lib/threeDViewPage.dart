
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';


class ThreeDViewPage extends StatefulWidget {
  ThreeDViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ThreeDViewPageState createState() => _ThreeDViewPageState();
}

class _ThreeDViewPageState extends State<ThreeDViewPage> {
  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;
  int _panoId = 0;


  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }



  @override
  Widget build(BuildContext context) {
    Widget panorama;
    panorama = Panorama(
      animSpeed: 1.0,
      zoom: 0.5,
      sensorControl: SensorControl.Orientation,
      onViewChanged: onViewChanged,
      onTap: (longitude, latitude, tilt) => print('onTap: $longitude, $latitude, $tilt'),
      onLongPressStart: (longitude, latitude, tilt) => print('onLongPressStart: $longitude, $latitude, $tilt'),
      onLongPressMoveUpdate: (longitude, latitude, tilt) => print('onLongPressMoveUpdate: $longitude, $latitude, $tilt'),
      onLongPressEnd: (longitude, latitude, tilt) => print('onLongPressEnd: $longitude, $latitude, $tilt'),
      child:  Image.asset('assets/car-inside.jpg'));


    return Scaffold(
      body: panorama,
    );
  }
}