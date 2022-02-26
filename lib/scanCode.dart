import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class scanCode extends StatefulWidget {
  const scanCode({Key key}) : super(key: key);

  @override
  _scanCodeState createState() => _scanCodeState();
}

class _scanCodeState extends State<scanCode> {
  bool qrFound=false;


  scanQr()async
  {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        false,
        ScanMode.QR);
    if(barcodeScanRes=='https://www.google.com/')
      {
        print('###$barcodeScanRes');
        setState(() {
          qrFound=true;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('modelNo', '78A67GHYHJ');
      }

    Future.delayed(Duration(seconds: 5),(){
      if(qrFound==true)
      Navigator.pop(context,{'modelNo':'78A67GHYHJ'});
      else
        Navigator.pop(context,{'modelNo':''});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    scanQr();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:qrFound==true? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
            colors: [Color.fromRGBO(2,43,69,1),Color.fromRGBO(2,19,35,1)]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:  EdgeInsets.all(20),
              child: Image.asset('assets/iszu_illustration.png'),
            ),
            Text('Congratulations!',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
            Padding(
              padding:  EdgeInsets.only(top: 10),
              child: Text('Qr code found Headset model no.-78A67GHYHJ',style: TextStyle(color: Colors.white),),
            ),
            Padding(
              padding:  EdgeInsets.only(top: 30),
              child: Text('Welcome to the Virtual Ride',style: TextStyle(color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding:  EdgeInsets.only(top: 30,left: 5,right: 5),
              child: Column(
                children: [
                  Text('You won a free Test Drive at nearest Isuzu Showroom',style: TextStyle(color: Colors.white,fontSize: 20,),textAlign: TextAlign.center,),
                  Icon(Icons.drive_eta,color: Colors.white,size: 20,),
                  Container()
                ],
              ),
            ),
          ],
        ),
      ):Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                colors: [Color.fromRGBO(2,43,69,1),Color.fromRGBO(2,19,35,1)]
            )
        ),
        child: Center(
          child: Text('Qr code given is incorrect :-(',style: TextStyle(color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
