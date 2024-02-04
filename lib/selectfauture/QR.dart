import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majascan/majascan.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

String? name;
String? id;
String result = "Wait for the administrator to start";
String image_state = 'images/qr-code-scanning.gif';
late String resultQr;
Color Colortext = Colors.black;

class qr extends StatefulWidget {
  static const String id = 'qr';

  @override
  qrState createState() {
    image_state = 'images/qr-code-scanning.gif';
    result = "Wait for the administrator to start";
    Colortext = Colors.black;
    return new qrState();
  }
}

class qrState extends State<qr> {
  String STDId = "";
  String STDnaem = "";
  String STDmac = "";
  final df = FirebaseDatabase.instance.ref('/');

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      String email = user.email ?? '';
      print('User email: $email');
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      email = email.replaceAll('.', ',');
      DataSnapshot snapshot = await ref.child('emails/$email').get();
      print(snapshot);
      print("sssssssssssssssssssssssssss");
      Map<dynamic, dynamic>? values = snapshot.value as Map?;
      print(values);
      if (values != null) {
        setState(() {
          STDId = values['id'];
          STDnaem = values['name'];
          STDmac = values['mac'];
          print(STDId);
          print(STDnaem);
          print(STDmac);
        });
      }
    }
  }

  Future _scanQR() async {
    try {
      String? qrResult = await MajaScan.startScan(
          title: "QRcode scanner",
          titleColor: Colors.amberAccent[700],
          qRCornerColor: Colors.red,
          qRScannerColor: Colors.blue,
          scanAreaScale: 0.5);
      setState(() {
        resultQr = qrResult ?? 'null string';
        _senddata(resultQr);
      });
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
          image_state = "images/qr-code-scan-failed.gif";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
          image_state = "images/qr-code-scan-failed.gif";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
        image_state = "images/qr-code-scan-failed.gif";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
        image_state = "images/qr-code-scan-failed.gif";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(result,
                    style:
                        GoogleFonts.sigmarOne(fontSize: 30, color: Colortext),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                child: Image(image: AssetImage(image_state)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.qr_code),
        label: Text("Scan"),
        onPressed: () async {
          _scanQR();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _senddata(String X) async {
    List<String> stringParts = X.split('#');
    print(stringParts);
    checkItemExistence(STDmac);
    if (stringParts.length == 4) {
      df.child('${stringParts[2]} ${stringParts[3]}').child(STDmac).update({
        'name': STDnaem,
        'id': STDId,
      });
      checkItemExistence(STDmac);
    } else {
      setState(() {
        result = 'Attendance failed';
        image_state = "images/qr-code-scan-failed.gif";
        Colortext = Colors.red;
      });
    }
  }

  void checkItemExistence(mac) {
    setState(() {
      df.child('chack add').onValue.listen((event) {
        if (event.snapshot.value
            .toString()
            .contains(mac.toString().toLowerCase())) {
          result = 'Succeeded in registering attendance';
          image_state = "images/qr-code-scan-successful.gif";
          Colortext = Colors.green;
        } else {
          result = 'Attendance failed';
          image_state = "images/qr-code-scan-failed.gif";
          Colortext = Colors.red;
        }
      });
    });
  }
}
