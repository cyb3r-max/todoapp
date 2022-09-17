import 'package:get/get.dart';
import 'package:todoapp/model/tasks.dart';

import '../database/dbHelper.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.inserttoDB(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    update();
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  void markAsCompleted(int id) async {
    await DBHelper.taskUpdate(id);
    getTasks();
  }
}
