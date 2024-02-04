import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try2/biometric/face_camera_enrollment.dart';
import 'package:try2/screens/signin_screen.dart';
import 'package:try2/screens/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:try2/screens/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String id = 'registration_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  late String email = "";
  late String password = "";
  late String name = ""; // Changed to lowercase for consistency
  late String id = "";
  late String mac = "";
  late int number_Empty_filled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/main_top.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Text(
                                "SIGN UP",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  const Spacer(),
                                  Expanded(
                                    flex: 8,
                                    child: SvgPicture.asset("icons/signup.svg"),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Expanded(
                                flex: 8,
                                child: Form(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        cursorColor: Color(0xFF6F35A5),
                                        decoration: InputDecoration(
                                          hintText: "Your Full Name",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(
                                                Icons.account_circle_outlined),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          name = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        cursorColor: Color(0xFF6F35A5),
                                        decoration: InputDecoration(
                                          hintText: "Your Student ID",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(Icons.numbers),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          id = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        cursorColor: Color(0xFF6F35A5),
                                        decoration: InputDecoration(
                                          hintText: "Your phone MAC address",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(
                                                Icons.network_wifi_outlined),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          mac = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        cursorColor: Color(0xFF6F35A5),
                                        onSaved: (email) {},
                                        decoration: InputDecoration(
                                          hintText: "Your email",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          email = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        textInputAction: TextInputAction.done,
                                        obscureText: true,
                                        cursorColor: Color(0xFF6F35A5),
                                        decoration: InputDecoration(
                                          hintText: "Your password",
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Icon(Icons.lock),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          password = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () async {
                                          name = name.trim();
                                          id = id.trim();
                                          mac = mac.trim();
                                          email = email.trim();
                                          number_Empty_filled = [
                                            name,
                                            id,
                                            mac,
                                            email,
                                            password
                                          ].where((str) => str.isEmpty).length;
                                          try {
                                            if (isIDMatch(email, id) &&
                                                macForm(mac) &&
                                                isValidGmailFormat(email)) {
                                              final new_user = await _auth
                                                  .createUserWithEmailAndPassword(
                                                email: email,
                                                password: password,
                                              );

                                              // Store user information in the database
                                              storeUserData(email, id, name,
                                                  password, mac);

                                              Navigator.pop(
                                                  context, WelcomeScreen.id);
                                              Navigator.pop(context);
                                              Navigator.pushNamed(context,
                                                  introduction_screen.id);

                                              Fluttertoast.showToast(
                                                msg:
                                                    "saccessfully created an account!",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else if (!isValidGmailFormat(
                                                email)) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Incorrect Email. Please provide the correct Email.\nthe correct format: \"(Your ID)@pua.edu.eg\"",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else if (!isIDMatch(email, id)) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Incorrect ID. Please provide the correct ID.",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else if (!macForm(mac)) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Wrong format for Mac Address.\nthe correct format: \"00:00:00:00:00:00\"",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else if (number_Empty_filled >
                                                0) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "There are $number_Empty_filled fields that must be filled out",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          } catch (e) {
                                            if (e is FirebaseAuthException &&
                                                e.code ==
                                                    'email-already-in-use') {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "This email is already registered. Please use a different email.",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else if (e
                                                .toString()
                                                .contains("invalid-email")) {
                                              Fluttertoast.showToast(
                                                msg: "invalid-email",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            } else if (e.toString().contains(
                                                "Invalid value: Only valid value is")) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "There is a problem with the email",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                            print(e);
                                          }
                                        },
                                        child: Text(
                                          "SIGN UP",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return LoginScreen();
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Already have an Account ? Sign In",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void storeUserData(
      String email, String id, String name, String password, String mac) async {
    try {
      // Store user information in the 'emails' node
      await _database.child('emails').child(email.replaceAll('.', ',')).set({
        'id': id,
        'name': name,
        'mac': mac,
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', '$email');
      await prefs.setString('password', '$password');
      await prefs.setString('mac', '$mac');
      await prefs.setString('name', '$name');
      await prefs.setString('id', '$id');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  bool isIDMatch(String email, String providedID) {
    String emailID = email.substring(0, 9);
    return emailID == providedID;
  }

  bool macForm(String mac) {
    if (mac.length == 17) {
      if (mac[2] == mac[5] &&
          mac[5] == mac[8] &&
          mac[8] == mac[11] &&
          mac[11] == mac[14] &&
          mac[14] == ":") {
        return true;
      }
    }
    return false;
  }

  bool isValidGmailFormat(String email) {
    RegExp regex_pharos = RegExp(r'^\d{9}@pua\.edu\.eg$');
    // Check if the email matches the regular expression
    return regex_pharos.hasMatch(email);
  }
}
