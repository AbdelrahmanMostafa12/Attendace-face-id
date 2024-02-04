import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:try2/biometric/fingerprintcode.dart';

void main() {
  runApp(fingerprint());
}

class fingerprint extends StatelessWidget {
  static const String id = 'fingerprint';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Wait for the administrator to start",
                    style: GoogleFonts.sigmarOne(
                        fontSize: 30, color: Colors.black),
                    textAlign: TextAlign.center),
              ),
              // Display the GIF
              Image.asset(
                'images/fingerprintgif.gif', // Make sure to place your gif in the assets folder
                width: 1000.0,
                height: 350.0,
              ),
              SizedBox(height: 5.0),
              // Button to navigate to another page
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 137.0),
        child: FloatingActionButton.extended(
          icon: Icon(Icons.fingerprint),
          label: Text("Scan"),
          onPressed: () async {
            Get.to(() => FingerApp(), transition: Transition.downToUp);
          },
        ),
      ),
    );
  }
}
