import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:try2/screens/Na_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Add await here
  await GetStorage.init();
  runApp(CameraScreen());
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);
  static const String id = 'camera';

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Object? data = "";
  bool keeplistening = true;
  String STDId = "";
  String STDnaem = "";
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
          STDId = values['id'];
          STDnaem = values['name'];
          STDmac = values['mac'];
          print(STDId);
          print(STDnaem);
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
    print(_databaseRef);
    if (keeplistening) {
      // Listen for changes to the data at the specified location
      _databaseRef.onValue.listen((event) {
        // The data in the event snapshot represents the current state of the data
        data = event.snapshot.value;
        // Check if the received data is equal to a certain value
        print(data);
        if (data == 'Add successful') {
          // Send new data to the database
          Fluttertoast.showToast(
            msg: "Enrollment successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          _databaseRef.set('no_request');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => na_bar(),
          ));
          keeplistening = false;
        } else if (data == "Add failed") {
          // Send new data to the database
          Fluttertoast.showToast(
            msg: "Failed enrollment",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          _databaseRef.set('no_request');
          keeplistening = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Exercises(onPressed: () async {
              await openFrontCamera(STDId, STDnaem, STDmac);
            }),
          ),
        ],
      ),
    );
  }

  Future<void> openFrontCamera(
      String userId, String usernaem, String usermac) async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (image != null) {
        await uploadImage(
          userId,
          usernaem,
          STDmac,
          File(image.path),
        );
      } else {
        print('Image capture canceled or failed');
      }
    } catch (e) {
      print('Error opening front camera: $e');
    }
  }

  Future<void> uploadImage(String userId, String usernaem, String usermac,
      [File? imageFile]) async {
    try {
      if (imageFile == null) {
        print('No image file provided');
        return;
      }

      Reference authenticationFolder =
          FirebaseStorage.instance.ref().child('Authentication');
      Reference userFolder = authenticationFolder.child(userId);
      Reference imageRef = userFolder.child('enrol.jpg');

      await imageRef.putFile(imageFile);

      print('Image captured and uploaded successfully for user: $userId');

      await FirebaseDatabase.instance.ref().child('Face').update({
        '$usermac': {'name': usernaem, 'id': userId, 'Statu': "enrollment"}
      });
    } catch (e) {
      print('Error capturing and uploading: $e');
    }
  }
}

class Exercises extends StatelessWidget {
  final VoidCallback onPressed;

  const Exercises({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Text(
            'Enrollment Process ',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Center(
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                height: MediaQuery.of(context).size.height * 1 / 10,
                width: MediaQuery.of(context).size.width * 3 / 5,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 193, 82, 234),
                      Color.fromARGB(255, 99, 74, 226),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(""),
                    const Text(
                      "Enrollment",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_right_alt_outlined,
                        size: 25.0,
                        color: Color.fromARGB(255, 136, 83, 207),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
