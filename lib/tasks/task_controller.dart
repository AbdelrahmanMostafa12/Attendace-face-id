import 'package:get/get.dart';

import 'package:try2/tasks/task.dart';

import 'db.dart';

class TaskController extends GetxController {
  RxList taskList = <Task>[].obs;
  DB db = DB();

  Future<void> getTasks() async {
    final tasks = await db.query();

    taskList.assignAll(tasks.map((e) => Task.fromMap(e)).toList());

    update();
  }

  void addTask({required Task? task}) async {
    await db.insert(task!);
    getTasks();
  }

  void deleteask({required Task task}) async {
    await db.delete(task.id!);
    getTasks();
  }

  void markTaskAsCompleted({required Task task}) async {
    var value = await db.update(task.id!);
    getTasks();
  }

  void deleteAllTask() async {
    await db.deleteAll();
    taskList.clear();
    update();
  }

  void deleteTask({required Task task}) {}
}
