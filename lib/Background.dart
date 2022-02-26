import 'package:flutter/material.dart';
import 'package:background_stt/background_stt.dart';
import 'package:flutter/services.dart';
import 'package:restart_app/restart_app.dart';

import 'HomePage.dart';

class BackgroundPage extends StatefulWidget {
  bool initialized;

   BackgroundPage({Key key,this.initialized}) : super(key: key);

  @override
  _BackgroundPageState createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {

  Map<String,Color> colors={'left':Colors.yellow,'right':Colors.red,'':Colors.white,'front':Colors.blue};
  String heardCommand='front';
  BackgroundStt _service;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    start();

  }
  start()async
  {

    _service = new BackgroundStt();

  if(widget.initialized==false) {
    await _service.startSpeechListenService;
    print('hello');
  }

    _service.getSpeechResults().onData((data) {
      if(mounted) {
        print("getSpeechResults: ${data.result} , ${data.isPartial}");
        if (data.result.toLowerCase().contains('left')) {
          _service.speak('going left', true);
          setState(() {
            heardCommand = 'left';
          });
        }
        else if (data.result.toLowerCase().contains('right')) {
          _service.speak('going right', true);
          setState(() {
            heardCommand = 'right';
          });
        }
        else if (data.result.toLowerCase().contains('front')) {
          _service.speak('going front', true);
          setState(() {
            heardCommand = 'front';
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await Restart.restartApp();
        return;
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/${heardCommand}.png')
            )
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text('$heardCommand',style:TextStyle(color: Colors.white,fontSize: 35) ,),
          //   ],
          // ),
      ),
      ),
    );
  }
}
