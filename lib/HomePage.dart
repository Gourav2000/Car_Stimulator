import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_platform_example/DrivingPage.dart';
import 'package:multi_platform_example/threeDViewPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car Simulator'),),
      body: Container(
      width: MediaQuery.of(context).size.width,
        //color: Colors.black,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0,right: 8),
              child: InkWell(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ThreeDViewPage()));
                },
                child: Container(

                    decoration: BoxDecoration(
                    color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0,right: 15,left: 15,bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '3D View ',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        Icon(Icons.remove_red_eye_sharp,color: Colors.white,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DrivePage(title: 'Drive',)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 8.0,right: 15,left: 15,bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Drive ',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)
                        ),
                        Icon(Icons.drive_eta_rounded,color: Colors.white,)
                      ],
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
