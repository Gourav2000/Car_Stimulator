
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_platform_example/video.dart';
import 'package:panorama/panorama.dart';
import 'package:imageview360/imageview360.dart';
import 'package:background_stt/background_stt.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:restart_app/restart_app.dart';


class ThreeDViewPage extends StatefulWidget {
  ThreeDViewPage({Key key, this.title,this.loc}) : super(key: key);

  final String title;
  final int loc;

  @override
  _ThreeDViewPageState createState() => _ThreeDViewPageState();
}

class _ThreeDViewPageState extends State<ThreeDViewPage> {
  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;
  bool InstructionDisplay=true;
  BackgroundStt _service;
  bool infoDisplay=false;
  bool imagePrecached = false;
  int _panoId;
  ImagePicker picker = ImagePicker();
  List<ImageProvider> imageList = <ImageProvider>[];



  void updateImageList(BuildContext context) async {
    for (int i = 1; i <= 52; i++) {
      imageList.add(AssetImage('assets/car_models/$i.png'));
      //* To precache images so that when required they are loaded faster.
      await precacheImage(AssetImage('assets/car_models/$i.png'), context);
    }
    setState(() {
      imagePrecached = true;
    });
  }

  start()async
  {
    print('hmmm');
    _service = new BackgroundStt();
    await _service.startSpeechListenService;
    await _service.resumeListening();
    _service.getSpeechResults().onData((data) async {
      if(!data.isPartial) {
        print("getSpeechResults: ${data.result} , ${data.isPartial}");
        if (data.result.toLowerCase().contains('drive') || data.result.toLowerCase().contains('driving') ) {
          _service.speak('Virtual Ride initiated', true);
          _service.pauseListening();
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return VideoPage();
          })).then((value) async {
            print('came back');
            _service.startSpeechListenService;
           _service.resumeListening();});
        }
        else if (data.result.toLowerCase().contains('back view')) {
           _service.speak('Implementing Back view', true);
          if(_panoId==1)
            {
              setState(() {
                _panoId=2;
              });
            }
        }
        else if (data.result.toLowerCase().contains('front')) {
           _service.speak('Implementing Front view', true);
            if(_panoId==2)
              {
                setState(() {
                  _panoId=1;
                });
              }
        }
        else if (data.result.toLowerCase().contains('outside')) {
           _service.speak('going Out', true);
          if(_panoId==1 || _panoId==2 || _panoId==-1)
            {
              if(_panoId==-1)
                {
                  Navigator.of(context).pop();
                }

              setState(() {
                infoDisplay=false;
                _panoId=0;
              });
            }

        }
        else if (data.result.toLowerCase().contains('inside')) {
           _service.speak('going In', true);
          {
            if(_panoId==0)
              {
                print('what');
                setState(() {
                  _panoId=1;
                });
              }
          }

        }
        else if (data.result.toLowerCase().contains('info') || data.result.toLowerCase().contains('information')) {
           _service.speak('Displaying details', true);
            showInfo();
        }
        else if(data.result.toLowerCase().contains('bootspace') || data.result.toLowerCase().contains('capacity'))
          {
            _service.speak('Displaying details', true);
            showDickyInfo();
          }
      }
    });
  }


  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }
@override
  void initState() {
    // TODO: implement initState
  _panoId=widget.loc??0;

  WidgetsBinding.instance
      .addPostFrameCallback((_) => updateImageList(context));
  Future.delayed(Duration(seconds: 7),(){
    try{
      setState(() {
        InstructionDisplay=false;
      });
    }catch(e){

    }
  });
    super.initState();
  start();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  }

  Widget hotspotButton({String text, IconData icon, VoidCallback onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.black38),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Icon(icon),
          onPressed: onPressed,
        ),
        text != null
            ? Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Center(child: Text(text,style: TextStyle(color:Colors.white),)),
        )
            : Container(),
      ],
    );
  }
  Widget hotspotButton2({String text, IconData icon, VoidCallback onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.black38),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Icon(icon),
          onPressed: onPressed,
        ),
        text != null
            ? Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Center(child: Text(text,style: TextStyle(color:Colors.white,fontSize: 7),)),
        )
            : Container(),
      ],
    );
  }
  showInfo()
  {
    setState(() {
      print('pressed');
      _panoId=-1;
      infoDisplay=true;
    });

    showDialog(context: context, builder: (context){
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Spacer(
                  ),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        _panoId=0;
                        infoDisplay=false;
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear,color: Colors.white,),
                  )
                ],
              ),
             Row(
               children: [
                 Container(
                   //color: Colors.blue,
                   child: Column(
                     children: [
                       Container(
                         height: MediaQuery.of(context).size.width*0.23,
                         width: MediaQuery.of(context).size.width*0.4,
                         //color: Colors.yellow,
                         child:  (imagePrecached == true)
                             ? ImageView360(
                           key: UniqueKey(),
                           imageList: imageList,
                           rotationCount: 2,
                           autoRotate: true,
                         )
                             : Text("Loading..."),

                       ),
                       Padding(
                         padding: EdgeInsets.only(left: 10),
                         child: Text('Isuzu Dmax',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:40 ),),
                       )
                     ],
                   ),
                 ),
                 Container(
                   //color: Colors.yellow,
                   height: MediaQuery.of(context).size.width*0.29,
                   width: MediaQuery.of(context).size.width*0.5,
                   child: SingleChildScrollView(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Engine:',style: TextStyle(color: Colors.white,fontSize: 20),),
                         Divider(thickness: 2,height: 10,color: Colors.white,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Type:',style: TextStyle(color: Colors.white),),
                                 Text('4 cylinder, Common Rail, VGT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                 Text('Intercooled Diesel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                 //\n
                               ],
                             ),
                             Divider(height: 10,thickness: 3,color: Colors.white,),
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Engine Displacement:',style: TextStyle(color: Colors.white),),
                                 Text('2499 cm^3',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Max Power:',style: TextStyle(color: Colors.white),),
                                 Text('58 kW(78hp)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                 Text('@ 398 rad/s(3800rpm)',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                 //\n
                               ],
                             ),
                             Divider(height: 10,thickness: 3,color: Colors.white,),
                             SizedBox(width: 130,),
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Max Torque:',style: TextStyle(color: Colors.white),),
                                 Text('1500-2400 rpm',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Text('Transmission:',style: TextStyle(color: Colors.white,fontSize: 20),),
                         Divider(thickness: 2,height: 10,color: Colors.white,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Drive Type:',style: TextStyle(color: Colors.white),),
                                 Text('2WD',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                 //\n
                               ],
                             ),

                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('No. of Speeds, shift type',style: TextStyle(color: Colors.white),),
                                 Text('5 speed, Manual',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Text('Suspension:',style: TextStyle(color: Colors.white,fontSize: 20),),
                         Divider(thickness: 2,height: 10,color: Colors.white,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Front Type:',style: TextStyle(color: Colors.white),),
                                 Text('Double Wishbone, Coil Spring',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                 //\n
                               ],
                             ),

                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Rear Type',style: TextStyle(color: Colors.white),),
                                 Text('Semi-Elliptic Leaf Spring',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Text('Capacity:',style: TextStyle(color: Colors.white,fontSize: 20),),
                         Divider(thickness: 2,height: 10,color: Colors.white,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Fuel Tank Capacity:',style: TextStyle(color: Colors.white),),
                                 Text('55 litre',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                 //\n
                               ],
                             ),

                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Seating Capacity',style: TextStyle(color: Colors.white),),
                                 Text('D+1',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Text('Dimensions:',style: TextStyle(color: Colors.white,fontSize: 20),),
                         Divider(thickness: 2,height: 10,color: Colors.white,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Overall Vehicle (LXWXH):',style: TextStyle(color: Colors.white),),
                                 Text('5375 mm x 1860 mm x 1800 mm',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                 //\n
                               ],
                             ),

                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Wheelbase:',style: TextStyle(color: Colors.white),),
                                 Text('3095 mm',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Cargo Deck (Inner) (LXWXH):',style: TextStyle(color: Colors.white),),
                                 Text('2440 mm x 1725 mm x 510 mm',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                 //\n
                               ],
                             ),

                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Turning Circle Radius:',style: TextStyle(color: Colors.white),),
                                 Text('6.3 m',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                               ],
                             ),
                           ],
                         ),
                         SizedBox(height: 20,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Ground Clearance',style: TextStyle(color: Colors.white),),
                                 Text('220 mm',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                 //\n
                               ],
                             ),

                           ],
                         ),
                       ],
                     ),
                   ),
                 )
               ],
             ),

            ],
          ),
        ),
      );
    });

  }

  showDickyInfo()
  {
    setState(() {
      print('pressed');
      _panoId=-1;
      infoDisplay=true;
    });

    showDialog(context: context, builder: (context){
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Spacer(
                  ),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        _panoId=0;
                        infoDisplay=false;
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear,color: Colors.white,),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    //color: Colors.blue,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width*0.23,
                          width: MediaQuery.of(context).size.width*0.4,
                          //color: Colors.yellow,
                          child:  Image.asset('assets/DickyyImg2.png',scale: 1.5,)

                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Isuzu Dmax',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:40 ),),
                        )
                      ],
                    ),
                  ),
                  Container(
                    //color: Colors.yellow,
                    height: MediaQuery.of(context).size.width*0.29,
                    width: MediaQuery.of(context).size.width*0.5,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payload Capacity:',style: TextStyle(color: Colors.white,fontSize: 20),),
                          Divider(thickness: 2,height: 10,color: Colors.white,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Payload:',style: TextStyle(color: Colors.white),),
                                  Text('1240 kg',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                  //\n
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GWW',style: TextStyle(color: Colors.white),),
                                  Text('2990Kg',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kerb Weight',style: TextStyle(color: Colors.white),),
                                  Text('1750kg/ 1550kg',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),

                                  //\n
                                ],
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      );
    });

  }
  @override
  Widget build(BuildContext context) {
    Widget panorama;
    switch(_panoId){
      case 0:
        panorama = Panorama(
            animSpeed: 1.0,
            zoom: 1,
            sensorControl: SensorControl.Orientation,
            onViewChanged: onViewChanged,
            onTap: (longitude, latitude, tilt) => print('onTap: $longitude, $latitude, $tilt'),
            onLongPressStart: (longitude, latitude, tilt) => print('onLongPressStart: $longitude, $latitude, $tilt'),
            onLongPressMoveUpdate: (longitude, latitude, tilt) => print('onLongPressMoveUpdate: $longitude, $latitude, $tilt'),
            onLongPressEnd: (longitude, latitude, tilt) => print('onLongPressEnd: $longitude, $latitude, $tilt'),
            hotspots: [
              Hotspot(
                latitude: -9.16,
                longitude: 64.58,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -7.79,
                longitude: 170.29,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -10.59,
                longitude: -136.39,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -5.01,
                longitude: -31.59,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -12.71,
                longitude: 7.32,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -2.87,
                longitude:  -9.70,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Show Info", icon: Icons.info_outline, onPressed: () =>showInfo()),
              ),
              Hotspot(
                latitude: -7.54,
                longitude:  -148.27,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Show Info", icon: Icons.info_outline, onPressed: () =>showInfo()),
              ),
              Hotspot(
                latitude: -8.25,
                longitude: 50.15,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Show Info", icon: Icons.info_outline, onPressed: () =>showInfo()),
              ),
              Hotspot(
                latitude: -7.60,
                longitude: 153.93,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Show Info", icon: Icons.info_outline, onPressed: () =>showInfo()),
              ),
              Hotspot(
                latitude: -4.30,
                longitude: -45.95,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Show Info", icon: Icons.info_outline, onPressed: () =>showInfo()),
              ),
              Hotspot(
                latitude: -5.67,
                longitude: -176.46,
                width: 90,
                height: 75,
                widget: hotspotButton2(text: "BootSpace Capacity", icon: Icons.arrow_circle_up, onPressed: () =>showDickyInfo()),
              ),
            ],
            child:  Image.asset('assets/car_showroom/car_showroom4.jpg'));
        break;
      case 1:
        panorama = Panorama(
            animSpeed: 1.0,
            zoom: -100,
            sensorControl: SensorControl.Orientation,
            onViewChanged: onViewChanged,
            onTap: (longitude, latitude, tilt) => print('onTap: $longitude, $latitude, $tilt'),
            onLongPressStart: (longitude, latitude, tilt) => print('onLongPressStart: $longitude, $latitude, $tilt'),
            onLongPressMoveUpdate: (longitude, latitude, tilt) => print('onLongPressMoveUpdate: $longitude, $latitude, $tilt'),
            onLongPressEnd: (longitude, latitude, tilt) => print('onLongPressEnd: $longitude, $latitude, $tilt'),
            hotspots: [
              Hotspot(
                latitude: -19.99,
                longitude: 85.1144,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Back", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=0)),
              ),
              Hotspot(
                latitude: -18.80,
                longitude: -178.470,
                width: 150,
                height: 100,
                widget: hotspotButton(text: "View From Back", icon: Icons.remove_red_eye_outlined, onPressed: () =>setState(() => _panoId=2)),
              ),
              Hotspot(
                latitude: -18.72,
                longitude: -42.75,
                width: 150,
                height: 100,
                widget: hotspotButton(text: "Start Driving", icon: Icons.drive_eta, onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoPage()));
                }),
              ),
            ],
            child:  Image.asset('assets/car-inside/car-inside3.jpg'));
        break;
      case 2:
        panorama=panorama = Panorama(
            animSpeed: 1.0,
            zoom: 1,
            sensorControl: SensorControl.Orientation,
            onViewChanged: onViewChanged,
            onTap: (longitude, latitude, tilt) => print('onTap: $longitude, $latitude, $tilt'),
            onLongPressStart: (longitude, latitude, tilt) => print('onLongPressStart: $longitude, $latitude, $tilt'),
            onLongPressMoveUpdate: (longitude, latitude, tilt) => print('onLongPressMoveUpdate: $longitude, $latitude, $tilt'),
            onLongPressEnd: (longitude, latitude, tilt) => print('onLongPressEnd: $longitude, $latitude, $tilt'),
            hotspots: [
              Hotspot(
                latitude: -7.71,
                longitude: -20.47,
                width: 150,
                height: 100,
                widget: hotspotButton(text: "View From Front", icon: Icons.remove_red_eye_outlined, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: 4.69,
                longitude:  52.98,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Back", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=0)),
              ),
            ],
            child:  Image.asset('assets/car-inside/car-inside_back_view.jpg'));
        break;
      case -1:
        panorama=Panorama(
            animSpeed: 0.000001,
            zoom: -100,
            sensorControl: SensorControl.None,
            onViewChanged: onViewChanged,
            onTap: (longitude, latitude, tilt) => print('onTap: $longitude, $latitude, $tilt'),
            onLongPressStart: (longitude, latitude, tilt) => print('onLongPressStart: $longitude, $latitude, $tilt'),
            onLongPressMoveUpdate: (longitude, latitude, tilt) => print('onLongPressMoveUpdate: $longitude, $latitude, $tilt'),
            onLongPressEnd: (longitude, latitude, tilt) => print('onLongPressEnd: $longitude, $latitude, $tilt'),
            hotspots: [
              Hotspot(
                latitude: -9.16,
                longitude: 64.58,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -7.79,
                longitude: 170.29,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -10.59,
                longitude: -136.39,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -5.01,
                longitude: -31.59,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -12.71,
                longitude: 7.32,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Go Inside", icon: Icons.open_in_browser, onPressed: () =>setState(() => _panoId=1)),
              ),
              Hotspot(
                latitude: -2.87,
                longitude:  -9.70,
                width: 90,
                height: 75,
                widget: hotspotButton(text: "Show Info", icon: Icons.info_outline, onPressed: () =>setState(() => infoDisplay=true)),
              ),
            ],
            child:  Image.asset('assets/car_showroom/car_showroom4.jpg'));
        break;
    }



    return WillPopScope(
      onWillPop: ()async{
        await Restart.restartApp();
        return;
      },
      child: Scaffold(
        body: Stack(
          children: [
            panorama,
            InstructionDisplay==true?
            Positioned(
                left: MediaQuery.of(context).size.width*0.15,
                top: MediaQuery.of(context).size.height*0.3,
                right: MediaQuery.of(context).size.width*0.15,
                child: Column(
                  children: [
                    ImageIcon(AssetImage('assets/rotate icon.png'),color: Colors.white,size: 150,),
                    Text('The view is horizontal',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                    Divider(height: 20,color: Colors.white,thickness: 2,),
                    Text('Please rotate your phone for better experience',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,),textAlign: TextAlign.center,),

                  ],
                )):SizedBox()
          ],
        ),
      ),
    );
  }
}