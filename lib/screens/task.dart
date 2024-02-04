import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:try2/screens/Na_bar.dart';

import 'package:try2/tasks/task.dart';
import 'package:try2/theme.dart';

import 'package:try2/widgets/button.dart';
import 'package:try2/widgets/task_tile.dart';

import '../tasks/add_task_page.dart';
import '../tasks/task_controller.dart';
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
    );
    
  }
}

class task extends StatefulWidget {

  static const String id = 'task';
  const task({super.key});

  @override
  State<task> createState() => _historybageState();
}

class _historybageState extends State<task> {
  
  final TaskController _taskController = Get.put(TaskController());
  double? screenHeight = 200;
  DateTime selectedDate = DateTime.now();
  void initState() {
    _taskController.getTasks();
    super.initState();
  }

  Color? ccc = Color.fromARGB(255, 49, 47, 53);
  @override
  Widget build(BuildContext context) {
    return SafeArea(      
      child: Scaffold(
        backgroundColor: Colors.white,

        // ignore: prefer_const_constructors
        body: Column(children: [
          Container(
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            DateFormat.yMMMMd().format(DateTime.now()),
                            style: GoogleFonts.alumniSans(
                              textStyle: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "today",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 27,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyButton(
                      label: '+ Add Task',
                      onTap: () {
                        Get.to(() => const AddTaskPage(),
                            transition: Transition.downToUp);
                      })
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.black87,
            indent: 80,
            endIndent: 80,
            thickness: 2,
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: DatePicker(
              DateTime.now(),
              height: 110,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Color(0xFF4e5ae8),
              selectedTextColor: Colors.white,
              //daaaaaaaaaaaaate style
              dateTextStyle: GoogleFonts.actor(
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
              //mooooonth style
              monthTextStyle: GoogleFonts.akshar(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
              ),
              daysCount: 60,
              onDateChange: (newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
          ),
          Divider(
            color: Colors.black87,
            indent: 25,
            endIndent: 25,
            thickness: 2,
            height: 1,
          ),
          _showTasks(),
        ]),
      
      ),
      
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () => _taskController.taskList.isEmpty
            ? _noTaskMsg()
            : ListView.builder(
                itemCount: _taskController.taskList.length,
                itemBuilder: (context, index) {
                  var task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(selectedDate) ||
                      (task.repeat == 'Weekly' &&
                          selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date))
                                      .inDays %
                                  7 ==
                              0) ||
                      (task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date).day ==
                              selectedDate.day)) {
                    var timeFormat = DateFormat('hh:mm a');
                    var date = timeFormat.parse(task.startTime);
                    var myTime = DateFormat('HH:mm').format(date);
                    print(myTime);
                    print(myTime);

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 700),
                      child: SlideAnimation(
                        verticalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container(height: 0);
                }),
      ),
    );
  }

  _noTaskMsg() {
    return ListView(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 2),
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0, left: 20),
                        child: Center(
                            child: Image(
                                image: AssetImage('images/1.gif'),
                                height: 150)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Text(
                          "you DON'T have any tasks YET!\nTry to ADD new TASKS .",
                          style: subTitleStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        width: 200,
        height: (screenHeight == 210)
            ? (task.isCompleted == 1)
                ? 600
                : 300
            : (task.isCompleted == 1)
                ? 210
                : 600,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 10),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task completed',
                    onTap: () {
                      _taskController.markTaskAsCompleted(task: task);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'Delete task',
              onTap: () async {
                _taskController.deleteask(task: task);
                Get.back();
              },
              clr: Colors.red[300]!,
            ),
            Divider(color: Colors.black87),
            _buildBottomSheet(
              label: 'cancel',
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
  
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: 400 * 0.9,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(25),
            color:  clr),
        child: Center(
          child: Text(
            label,
            style:
                 titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}


