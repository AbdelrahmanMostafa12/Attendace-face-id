import 'package:flutter/material.dart';
import 'package:try2/selectfauture/faceid.dart';

import '../selectfauture/QR.dart';
import '../selectfauture/fingerprint.dart';

void main() {
  runApp(Www());
}

class Www extends StatelessWidget {
  static const String id = 'www';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ToggleButtonsPage(),
        '/www': (context) => WwwPageContent(),
        '/welcome': (context) => WelcomePageContent(),
        '/qr': (context) => QrPageContent(),
      },
    );
  }
}

class ToggleButtonsPage extends StatefulWidget {
  @override
  _ToggleButtonsPageState createState() => _ToggleButtonsPageState();
}

class _ToggleButtonsPageState extends State<ToggleButtonsPage> {
  List<bool> isSelected = [false, false, false];
  bool areToggleButtonsVisible = true; // Track visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 156, 115, 226),
        title: Center(child: Text(' Attendance')),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: _getCurrentPageContent(),
              ),
            ),
            Visibility(
              visible: areToggleButtonsVisible,
              child: ToggleButtonsWidget(isSelected, (index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    isSelected[buttonIndex] = buttonIndex == index;
                  }
                });
              }),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  areToggleButtonsVisible = !areToggleButtonsVisible;
                });
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                      color: Colors.grey,
                      width: 1.0), // Set the border color and width
                ),
                primary: Colors.white, // Set the button color to gray
              ),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  areToggleButtonsVisible
                      ? Icons.keyboard_arrow_down // Arrow up icon
                      : Icons.keyboard_arrow_up, // Arrow down icon
                  color: Colors.black, // Icon color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCurrentPageContent() {
    if (isSelected[0]) {
      return WwwPageContent();
    } else if (isSelected[1]) {
      return WelcomePageContent();
    } else if (isSelected[2]) {
      return QrPageContent();
    } else {
      return Container(); // Empty container for no page selected
    }
  }
}

class ToggleButtonsWidget extends StatelessWidget {
  final List<bool> isSelected;
  final Function(int) onPressed;

  ToggleButtonsWidget(this.isSelected, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Colors.black.withOpacity(0.60),
      selectedColor: Color(0xFF6200EE),
      selectedBorderColor: Color(0xFF6200EE),
      fillColor: Color(0xFF6200EE).withOpacity(0.08),
      splashColor: Color(0xFF6200EE).withOpacity(0.12),
      hoverColor: Color(0xFF6200EE).withOpacity(0.04),
      borderRadius: BorderRadius.circular(8.0),
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: 110.0,
      ),
      isSelected: isSelected,
      onPressed: onPressed,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('QrCode'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('FaceID'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('FingerPrint'),
        ),
      ],
    );
  }
}

class WwwPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return qr(); // Replace with actual content
  }
}

class WelcomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return faceid();
  }
}

class QrPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return fingerprint();
  }
}
