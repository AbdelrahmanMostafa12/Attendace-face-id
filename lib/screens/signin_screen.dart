import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:try2/screens/Na_bar.dart';
import 'package:try2/screens/registration_screen.dart';
import 'package:try2/screens/task.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:try2/screens/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'signin_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/main_top.png"),
                        fit: BoxFit.fill))),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "LOGIN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16 * 2),
                        Row(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: SvgPicture.asset("icons/login.svg"),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(height: 16 * 2),
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
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: Color(0xFF6F35A5),
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
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextFormField(
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
                                ),
                                const SizedBox(height: 16),
                                Hero(
                                  tag: "login_btn",
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        if (isValidGmailFormat(email)) {
                                          final newUser = await _auth
                                              .signInWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          storeData(email, password);
                                          Navigator.pop(
                                              context, WelcomeScreen.id);
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, na_bar.id);
                                          Fluttertoast.showToast(
                                            msg: "saccessfully logged in",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else if (!isValidGmailFormat(email)) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Incorrect Email.\nPlease provide the correct Email.",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      } catch (e) {
                                        if (e
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
                                        } else if (e
                                            .toString()
                                            .contains("user-not-found")) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "this email is not registered with us\n sign up to get started",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else if (e
                                            .toString()
                                            .contains("wrong-password")) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "wrong password\nPlease try again",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else if (e
                                            .toString()
                                            .contains("too-many-requests")) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "many requests\nPlease try again later",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                        print("xxxxxxxxxxxxxxxxx  $e");
                                      }
                                    },
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(color: Colors.white),
                                    ),
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
                                          return SignUpScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Don’t have an Account ? Sign Up",
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
    );
  }

  void storeData(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Store user information in the 'emails' node
      await _database
          .child('emails/${email.replaceAll('.', ',')}')
          .onValue
          .listen((event) async {
        var id = event.snapshot.child("id").value;
        var mac = event.snapshot.child("mac").value;
        var name = event.snapshot.child("name").value;
        await prefs.setString('email', '$email');
        await prefs.setString('password', '$password');
        await prefs.setString('mac', '$mac');
        await prefs.setString('name', '$name');
        await prefs.setString('id', '$id');
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error try again later',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  bool isValidGmailFormat(String email) {
    RegExp regex_pharos = RegExp(r'^\d{9}@pua\.edu\.eg$');
    // Check if the email matches the regular expression
    return regex_pharos.hasMatch(email);
  }
}
