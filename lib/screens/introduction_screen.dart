import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:try2/biometric/face_camera_enrollment.dart';

void main() {
  runApp(introduction_screen ());
}

class introduction_screen  extends StatelessWidget {
  static const String id = 'introduction_screen';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Enrollment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroductionScreenPage(),
    );
  }
}

class IntroductionScreenPage extends StatefulWidget {
  @override
  _IntroductionScreenPageState createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            title: "Welcome to Face Enrollment",
            body: "Securely enroll your face for authentication.",
            image: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset('images/introduction1.png'),
            ), // Replace with your image asset
          ),
          PageViewModel(
            title: "Enrollment",
            body: "Follow the instructions to complete the enrollment process.",
            image: Image.asset('images/faceimage3.png'), // Replace with your image asset
          ),
        ],
        onDone: () {
          // Navigate to the face enrollment page or perform necessary actions
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );
        },
        
        onSkip: () {
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );
        },
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class FaceEnrollmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your face enrollment UI and logic here
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Enrollment'),
      ),
      body: Center(
        child: Text('Face Enrollment Page'),
      ),
    );
  }
}
