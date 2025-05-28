import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task_view_model.dart';
import '../widgets/task_item.dart';

class TodoHomeScreen extends StatelessWidget {
  const TodoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          'Hello Aisha,',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),

      ),



      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Never do tomorrow what you can do today.\nLet’s get some things done!",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Consumer<TaskViewModel>(
                builder: (context, taskVM, _) {
                  final total = taskVM.tasks.length;
                  final completed = taskVM.tasks.where((t) => t.isDone).length;
                  final remaining = total - completed;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statBox("Total", total, Colors.blue),
                      _statBox("Done", completed, Colors.green),
                      _statBox("Left", remaining, Colors.orange),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<TaskViewModel>(
                builder: (context, taskVM, _) {
                  final tasks = taskVM.tasks;

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks yet!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return TaskItem(
                        title: task.title,
                        date: task.date,
                        isDone: task.isDone,
                        onToggleDone: () {
                          taskVM.toggleTaskStatus(task.id);
                        },
                        onDelete: () {
                          taskVM.deleteTask(task.id);
                        },
                        onEdit: () {
                          final controller = TextEditingController(text: task.title);

                          showDialog(
                            context: context,
                            builder: (context) {
                              final mediaQuery = MediaQuery.of(context);
                              return Padding(
                                padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
                                child: AlertDialog(
                                  title: const Text('Edit Task'),
                                  content: TextField(controller: controller),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final newTitle = controller.text.trim();
                                        if (newTitle.isNotEmpty) {
                                          Provider.of<TaskViewModel>(context, listen: false).updateTask(task.id, newTitle);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Update'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final titleController = TextEditingController();

              return AlertDialog(
                title: const Text('Add New Task'),
                content: TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Enter task title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newTitle = titleController.text.trim(); // ← استخدم المتغير الصحيح

                      if (newTitle.isNotEmpty) {
                        Provider.of<TaskViewModel>(context, listen: false)
                            .addTask(newTitle);
                      }

                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),

                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _statBox(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
