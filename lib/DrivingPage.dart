import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class DrivePage extends StatefulWidget {
  DrivePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DrivePageState createState() => _DrivePageState();
}

class _DrivePageState extends State<DrivePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _ready = false;
  bool _listening = false;
  String _lastWords = '';
  String _lastStatus = '';
  String _lastError = '';
  bool isShaking=false;

  @override
  void initState() {

    _init();
    ShakeDetector detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 1.75,
        onPhoneShake: () {
          // Do stuff on phone shake
          print('its shaking bruv!');
          _stop();
          _start();
          setState(() {
            isShaking=true;
          });
        }
    );
    super.initState();
  }

  void _init() async {
    _ready =
    await _speechToText.initialize(onError: _onError, onStatus: _onStatus);
    setState(() {});
  }

  void _start() async {
    await _speechToText.listen(onResult: _speechResult,pauseFor:Duration(minutes: 5));
    _listening = true;
    setState(() {});
  }

  void _stop() async {
   await _speechToText.stop();
    _listening = false;
    setState(() {});
  }

  void _cancel() async {
    _speechToText.cancel();
    _listening = false;
    setState(() {});
  }

  void _speechResult(SpeechRecognitionResult result) {
    print(result);
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(child: Column(
          children: [
            Text('$isShaking'),
            _lastWords.contains('left')?Container(
                color: Colors.yellowAccent,
                child: Text('left')):_lastWords.contains('right')?Container(
                color: Colors.yellowAccent,
                child: Text('right')):SizedBox(),
          ],
        )),
      )
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           TextButton(
      //               onPressed: _ready ? null : _init,
      //               child: Text('Initialize')),
      //           TextButton(
      //               onPressed: _ready && !_listening ? _start : null,
      //               child: Text('Listen')),
      //           TextButton(
      //               onPressed: _listening ? _stop : null, child: Text('Stop')),
      //           TextButton(
      //               onPressed: _listening ? _cancel : null,
      //               child: Text('Cancel')),
      //         ],
      //       ),
      //       Expanded(
      //         child: Column(
      //           children: [
      //             Divider(),
      //             Text(
      //               'Speech to text initialized: $_ready',
      //             ),
      //             Text(
      //               'Status: $_lastStatus',
      //             ),
      //             Text(
      //               'Error: $_lastError',
      //             ),
      //             Divider(),
      //             Text(
      //               'Words: $_lastWords',
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  void _onStatus(String status) {
    _lastStatus = status;

  }

  void _onError(SpeechRecognitionError errorNotification) {
    _lastError = errorNotification.errorMsg;
  }
}