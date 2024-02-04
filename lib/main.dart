import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:try2/screens/Na_bar.dart';
import 'package:try2/screens/Table.dart';
import 'package:try2/screens/introduction_screen.dart';
import 'package:try2/screens/registration_screen.dart';
import 'package:try2/screens/selectfauture.dart';
import 'package:try2/screens/signin_screen.dart';
import 'package:try2/screens/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try2/biometric/face_camera_enrollment.dart';
import 'package:try2/selectfauture/fingerprint.dart';
import 'selectfauture/QR.dart';
import 'selectfauture/faceid.dart';
import 'screens/welcome_screen.dart';
import 'tasks/add_task_page.dart';
late String prime_screen = WelcomeScreen.id;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await GetStorage.init();
  await chack_if_is_acc();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Masary app',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF6F35A5),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color(0xFF6F35A5),
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFF1E6FF),
            iconColor: Color(0xFF6F35A5),
            prefixIconColor: Color(0xFF6F35A5),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      initialRoute: prime_screen,
     routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        introduction_screen.id: (context) => introduction_screen(),
        task.id: (context) => task(),
        na_bar.id: (context) => na_bar(),
        Www.id: (context) => Www(),
        faceid.id: (context) => faceid(),
        CameraScreen.id: (context) => CameraScreen(),
        qr.id: (context) => qr(),
        fingerprint.id: (context) => fingerprint(),
        AddTaskPage.id: (context) => AddTaskPage(),
        TableY.id: (context) => TableY(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
},
    );
  }
}

Future chack_if_is_acc() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  print("Email from SharedPreferences: $email");
  if (email == "" || email == null) {
    prime_screen = WelcomeScreen.id;
  } else {
    prime_screen = na_bar.id;
  }
  print("Selected prime_screen: $prime_screen");
}



/*routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        task.id: (context) => task(),
        task.id: (context) => na_bar(),
        Www.id: (context) => Www(),
        faceid.id: (context) => faceid(),
        CameraScreen.id: (context) => CameraScreen(),
        qr.id: (context) => qr(),
        fingerprint.id: (context) => fingerprint(),
        AddTaskPage.id: (context) => AddTaskPage(),
        TableY.id: (context) => TableY(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
      },*/