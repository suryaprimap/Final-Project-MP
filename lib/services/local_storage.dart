import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class LocalStorageService {
  static const String taskKey = "TASKS_LIST";

  // Simpan list task ke shared_preferences
  static Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();
    await prefs.setStringList(taskKey, taskList);
  }

  // Load list task dari shared_preferences
  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList(taskKey);
    if (taskList == null) return [];
    return taskList
        .map((taskString) => Task.fromJson(jsonDecode(taskString)))
        .toList();
  }

  // Hapus semua task (opsional)
  static Future<void> clearTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(taskKey);
  }
}
