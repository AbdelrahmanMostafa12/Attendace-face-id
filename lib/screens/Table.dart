import 'dart:math';

import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class TableY extends StatelessWidget {
  static const String id = 'TableY';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time planner Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Time planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TimePlannerTask> tasks = [];
  int day = 0;
  int hour = 6;
  int minute = 00;
  int event_time = 0;
  String Title_lable = 'this is a task';
  void _addObject(BuildContext context) {
    List<Color?> colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.lime[600]
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: AlertDialog(
            title: Text('Add New Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    onChanged: (value) => setState(() => day = value!),
                    value: day,
                    items: [
                      DropdownMenuItem(value: 0, child: Text('Saturday')),
                      DropdownMenuItem(value: 1, child: Text('Sunday')),
                      DropdownMenuItem(value: 2, child: Text('Mmonday')),
                      DropdownMenuItem(value: 3, child: Text('tuesday')),
                      DropdownMenuItem(value: 4, child: Text('wednesday')),
                      DropdownMenuItem(value: 5, child: Text('Thursday')),
                      DropdownMenuItem(value: 6, child: Text('friday')),
                    ],
                  ),
                  // Text field to enter Text
                  SingleChildScrollView(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          Title_lable = value;
                        });
                      },
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Hour 1-->24'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        hour = int.parse(value);
                      });
                    },
                  ),
                  // Text field to enter minute
                  TextField(
                    decoration: InputDecoration(labelText: 'Minute 0-->59'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        minute = int.parse(value);
                      });
                    },
                  ),
                  // Text field to enter event time
                  TextField(
                    decoration: InputDecoration(labelText: 'event time 1-->24'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        event_time = int.parse(value) * 60;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(
                    () {
                      tasks.add(
                        TimePlannerTask(
                          key: ValueKey(context),
                          color: colors[Random().nextInt(colors.length)],
                          dateTime: TimePlannerDateTime(
                            day: day,
                            hour: hour,
                            minutes: minute,
                          ),
                          minutesDuration: event_time,
                          daysDuration: 1,
                          onTap: () {
                            setState(() {
                              for (int i = 0; i < tasks.length; i++) {
                                if (tasks[i].key.toString().contains(context.toString())) {
                                  tasks.removeAt(i);
                                }
                              }
                            });
                          },
                          child: Text(
                            Title_lable,
                            style: TextStyle(
                                color: Color.fromARGB(255, 237, 237, 237),
                                fontSize: 18),
                          ),
                        ),
                      );
                    },
                  );
                  // Close the dialog box
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF4e5ae8),
        centerTitle: true,
      ),
      body: Center(
        child: TimePlanner(
          startHour: 0,
          endHour: 23,
          headers: [
            TimePlannerTitle(
              title: "saturday",
            ),
            TimePlannerTitle(
              title: "sunday",
            ),
            TimePlannerTitle(
              title: "monday",
            ),
            TimePlannerTitle(
              title: "tuesday",
            ),
            TimePlannerTitle(
              title: "wednesday",
            ),
            TimePlannerTitle(
              title: "thursday",
            ),
            TimePlannerTitle(
              title: "friday",
            ),
          ],
          tasks: tasks,
          style: TimePlannerStyle(
            cellHeight: 100,
            cellWidth: 100,
            showScrollBar: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4e5ae8),
        onPressed: () => _addObject(context),
        tooltip: 'Add random task',
        child: Icon(Icons.add),
      ),
    );
  }
}
