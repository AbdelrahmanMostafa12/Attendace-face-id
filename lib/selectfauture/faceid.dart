import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(faceid());
}

class faceid extends StatefulWidget {
  static const String id = 'faceid';

  @override
  State<faceid> createState() => _faceidState();
}

class _faceidState extends State<faceid> {
  Object? data = "";
  bool keeplistening = true;
  String STDmac = "";

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
          STDmac = values['mac'];
          print(STDmac);
        });
      }
    }
    keeplisten(STDmac);
  }

  void keeplisten(String STDmac) {
    print("fffffffffffffffffffffff $STDmac");
    final DatabaseReference _databaseRef =
        FirebaseDatabase.instance.ref('Face/$STDmac/Statu');
    // Listen for changes to the data at the specified location
    _databaseRef.onValue.listen((event) {
      // The data in the event snapshot represents the current state of the data
      data = event.snapshot.value;
      // Check if the received data is equal to a certain value
      print(data);
      if (data == 'Accepted') {
        // Send new data to the database
        Fluttertoast.showToast(
          msg: "Verfication successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _databaseRef.set('no_request');
        keeplistening = false;
      }
      if (data == 'No face found in the provided image.') {
        // Send new data to the database
        Fluttertoast.showToast(
          msg: "No face found in the provided image.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _databaseRef.set('no_request');
        keeplistening = false;
      }
      if (data == 'Verification failed. The person is not') {
        // Send new data to the database
        Fluttertoast.showToast(
          msg:
              "Verification failed. The person is not the same that registed in our system",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _databaseRef.set('no_request');
        keeplistening = false;
      }
      if (data == 'wait...') {
        // Send new data to the database
        Fluttertoast.showToast(
          msg: "please wait...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellow,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _databaseRef.set('no_request');
        keeplistening = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FaceIdPage(),
    );
  }
}

class FaceIdPage extends StatefulWidget {
  @override
  _FaceIdPageState createState() => _FaceIdPageState();
}

class _FaceIdPageState extends State<FaceIdPage> {
  String STDId = "";
  String STDnaem = "";
  String STDmac = "";

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

  Future<void> createRequestNode(
      String usernaem, String userId, String usermac) async {
    try {
      await FirebaseDatabase.instance.ref().child('Face').update({
        '$usermac': {'name': usernaem, 'id': userId, 'Statu': "verification"}
      });
      print('Request node created successfully for user: $userId');
    } catch (e) {
      print('Error creating request node: $e');
    }
  }

  Future<void> openFrontCamera() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (image != null) {
        await uploadImage(STDId, File(image.path));
      } else {
        print('Image capture canceled or failed');
      }
      await createRequestNode(STDnaem, STDId, STDmac);
    } catch (e) {
      print('Error opening front camera: $e');
    }
  }

  Future<void> uploadImage(String userId, [File? imageFile]) async {
    try {
      if (imageFile == null) {
        print('No image file provided');
        return;
      }

      Reference authenticationFolder =
          FirebaseStorage.instance.ref().child('Authentication');
      Reference userFolder = authenticationFolder.child(userId);
      Reference imageRef = userFolder.child('verify.jpg');

      await imageRef.putFile(imageFile);

      print('Image captured and uploaded successfully for user: $userId');
    } catch (e) {
      print('Error capturing and uploading: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Wait for the administrator to start",
                style: GoogleFonts.sigmarOne(fontSize: 30, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            // Display the GIF
            Image.asset(
              'images/faceid1.gif',
              width: 1000.0,
              height: 350.0,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 140.0),
        child: FloatingActionButton.extended(
          onPressed: openFrontCamera,
          icon: Icon(Icons.face),
          label: Text("Scan"),
        ),
      ),
    );
  }
}
