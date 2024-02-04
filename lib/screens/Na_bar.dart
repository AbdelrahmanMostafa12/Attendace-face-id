import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try2/screens/Na_bar.dart';
import 'package:try2/screens/Table.dart';
import 'package:try2/screens/selectfauture.dart';
import 'package:try2/screens/task.dart';
import 'package:try2/screens/welcome_screen.dart';
import 'package:try2/tasks/add_task_page.dart';
import 'package:try2/tasks/task.dart';
import 'package:try2/tasks/task_controller.dart';
import 'package:try2/theme.dart';
import 'package:try2/widgets/button.dart';
import 'package:try2/widgets/task_tile.dart';

class na_bar extends StatefulWidget {
  static const String id = 'na_bar';

  @override
  State<na_bar> createState() => _na_barState();
}

class _na_barState extends State<na_bar> {
  int index = 0;

  List pages = [
    task(), // Updated to use _TaskPage instead of task
    Www(),
    TableY(),
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      home :SafeArea(child: Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: pages.elementAt(index),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4e5ae8),
        ),
        child: SafeArea(
          child: FlashyTabBar(
            selectedIndex: index,
            onItemSelected: (Value) async {
              if (Value == 3) {
                SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('email');
                await prefs.remove('password');

                Navigator.pushNamed(context, WelcomeScreen.id);
              } else {
                setState(() {
                  index = Value;
                });
              }
            },
            items: [
              FlashyTabBarItem(
                icon: Icon(
                  Icons.home,
                  color: Color(0xFF4e5ae8),
                ),
                title: Text('Home',
                    style: TextStyle(
                      color: Color(0xFF4e5ae8),
                    )),
              ),
              FlashyTabBarItem(
                icon: Icon(
                  Icons.qr_code,
                  color: Color(0xFF4e5ae8),
                ),
                title: Text('attendance',
                    style: TextStyle(
                      color: Color(0xFF4e5ae8),
                    )),
              ),
              FlashyTabBarItem(
                icon: Icon(
                  Icons.table_view_outlined,
                  color: Color(0xFF4e5ae8),
                ),
                title: Text('Time Table',
                    style: TextStyle(
                      color: Color(0xFF4e5ae8),
                    )),
              ),
              FlashyTabBarItem(
                icon: Icon(
                  Icons.logout,
                  color: Color(0xFF4e5ae8),
                ),
                title: Text('log out',
                    style: TextStyle(
                      color: Color(0xFF4e5ae8),
                    )),
              ),
            ],
          ),
        ),
      ),
    ),
    ),
    );
  }
}

class _TaskPage extends StatefulWidget {
  @override
  State<_TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<_TaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  double? screenHeight = 200;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    _taskController.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 170, 99, 179),
        body: Column(
          children: [
            // Add the necessary widgets from your original task class here

            // Example:
            Text('Task Page'),

            // ...
          ],
        ),
      ),
    );
  }
}
