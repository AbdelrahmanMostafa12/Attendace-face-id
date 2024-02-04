import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:try2/tasks/task.dart';
import 'package:try2/tasks/task_controller.dart';
import 'package:try2/widgets/input_field.dart';

import '../theme.dart';
import '../widgets/button.dart';

class AddTaskPage extends StatefulWidget {
  static const String id = 'AddTaskPage';
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late DateTime _selecteDate = DateTime.now();
  late String _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  List<Color> colorList = [bluishClr, pinkClr, orangeClr, darkGreyClr];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        )),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //SizedBox(height: 50,),
                  //Title
                  InputField(
                    title: 'Title',
                    hint: 'Enter your title here...',
                    fieldController: _titleController,
                  ),
                  //Note
                  InputField(
                    title: 'Note',
                    hint: 'Enter your note here...',
                    fieldController: _noteController,
                  ),
                  //Date
                  InputField(
                    title: 'Date',
                    hint: DateFormat.yMd().format(_selecteDate),
                    child: IconButton(
                      onPressed: () => _getDateFromUser(),
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  //Date Range
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          title: 'Start Time',
                          hint: _startTime,
                          child: IconButton(
                            onPressed: () =>
                                _getTimeFromUser(isStartTime: true),
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InputField(
                          title: 'End Time',
                          hint: _endTime,
                          child: IconButton(
                            onPressed: () =>
                                _getTimeFromUser(isStartTime: false),
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Color
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color',
                          style: titleStyle,
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: List.generate(
                            colorList.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.only(right: 5.0, top: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = index;
                                  });
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: CircleAvatar(
                                  backgroundColor: colorList[index],
                                  child: index == _selectedColor
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: MyButton(
            label: 'Create Task',
            onTap: () {
              _validateDate();
            }),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      print(1);
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      print(2);
      Get.snackbar(
        'Required',
        'All fileds are required',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      print('######## Error Here ! ########');
    }
  }

  _addTaskToDb() {
    _taskController.addTask(
      task: Task(
        id: null,
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selecteDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selecteDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() {
        _selecteDate = _pickedDate;
      });
    } else
      print('picked date empty !');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = _pickedTime.format(context);
          print(_startTime);
        } else {
          _endTime = _pickedTime.format(context);
          print(_endTime);
        }
      });
    }
  }
}
