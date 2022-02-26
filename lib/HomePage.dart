import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_platform_example/Background.dart';
import 'package:multi_platform_example/DrivingPage.dart';
import 'package:multi_platform_example/scanCode.dart';
import 'package:multi_platform_example/threeDViewPage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool initialized=false;
  bool qrScanned=false;
  String Modelno='';
  @override
  void initState() {
    // TODO: implement initState

    getPrefs();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs. setString('modelNo', '');
    Modelno=prefs.getString('modelNo');
    if(Modelno!='' && Modelno!=null)
      {
        setState(() {
          qrScanned=true;
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Car Simulator'),),
      body: Container(
      width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/isuzu-dmax_bg.jpg'),
            fit: BoxFit.cover
          )
        ),
        //color: Colors.black,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2,sigmaY: 2),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              Image.asset('assets/heading.png'),
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,right: 8),
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ThreeDViewPage())).then((value) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.portraitUp,
                          ]);
                        });
                      },
                      child: Container(

                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0,right: 15,left: 15,bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ImageIcon(AssetImage('assets/360_icon.png'),color: Colors.white,size: 37.5,),
                              Text(
                                ' View Of The Showroom',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20, shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(7.0, 7.0),
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  Shadow(
                                    offset: Offset(7.0, 7.0),
                                    blurRadius: 8.0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ThreeDViewPage(loc: 1,))).then((value){
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.portraitUp,
                          ]);
                          initialized=value;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(top: 8.0,right: 15,left: 15,bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.drive_eta_rounded,color: Colors.white,),
                              Text(
                                  ' Start your virtual Ride',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(7.0, 7.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        Shadow(
                                          offset: Offset(7.0, 7.0),
                                          blurRadius: 8.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ])
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>scanCode())).then((value){
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitDown,
                            DeviceOrientation.portraitUp,
                          ]);
                          //initialized=value;
                          setState(() {
                            Modelno=value['modelNo'];
                            qrScanned=true;

                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(top: 8.0,right: 15,left: 15,bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.qr_code_2_rounded,color: Colors.white,),
                              Text(
                                  ' Scan your DIY headset QR',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(7.0, 7.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        Shadow(
                                          offset: Offset(7.0, 7.0),
                                          blurRadius: 8.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ])
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.005),
                  qrScanned==true?Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // decoration: BoxDecoration(
                      //     color: Colors.black.withOpacity(0.5),
                      //     borderRadius: BorderRadius.all(Radius.circular(15))
                      // ),
                      child: Padding(
                        padding:  EdgeInsets.only(top: 8.0,right: 15,left: 15,bottom: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.qr_code_2_rounded,color: Colors.white,),
                            Text(
                                'Verified Qr is $Modelno ',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontStyle: FontStyle.italic,fontSize: 20,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(7.0, 7.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      Shadow(
                                        offset: Offset(7.0, 7.0),
                                        blurRadius: 8.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ])
                            ),
                            Icon(Icons.check_circle,color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                  ):SizedBox(),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
