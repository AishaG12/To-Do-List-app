import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_flutter_app/model/task.dart';

import '../widgets/task_item.dart';

class TaskViewModel extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;


  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      final List decoded = jsonDecode(tasksString);
      _tasks.clear();
      _tasks.addAll(decoded.map((item) => TaskModel(
        id: item['id'],
        title: item['title'],
        date: item['date'],
        isDone: item['isDone'],
      )));
      notifyListeners();
    }
  }


  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> data = _tasks
        .map((t) => {
      'id': t.id,
      'title': t.title,
      'date': t.date,
      'isDone': t.isDone,
    })
        .toList();
    prefs.setString('tasks', jsonEncode(data));
  }

  // Add task
  Future<void> addTask(String title) async {
    final task = TaskModel(
      id: DateTime.now().toIso8601String(),
      title: title,
      date: _formattedDate(),
    );
    _tasks.add(task);
    await saveTasks();
    notifyListeners();
  }


  Future<void> toggleTaskStatus(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isDone = !task.isDone;
    await saveTasks();
    notifyListeners();
  }


  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await saveTasks();
    notifyListeners();
  }
  void updateTask(String id, String newTitle) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle;
    notifyListeners();
    saveTasks();
  }

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} (${_dayName(now.weekday)})";
  }

  String _dayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }
}
