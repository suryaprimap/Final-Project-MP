import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/local_storage.dart';
import 'add_edit_task_page.dart';

enum FilterOption { All, Done, NotDone }

class HomePage extends StatefulWidget {
  final Function(bool)? onToggleTheme; // callback dari main.dart
  const HomePage({super.key, this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  FilterOption filter = FilterOption.All;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await LocalStorageService.loadTasks();
    setState(() {});
  }

  void saveTasks() {
    LocalStorageService.saveTasks(tasks);
  }

  void addOrEditTask(Task task, [int? index]) {
    setState(() {
      if (index == null) {
        tasks.add(task);
      } else {
        tasks[index] = task;
      }
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  List<Task> get filteredTasks {
    switch (filter) {
      case FilterOption.Done:
        return tasks.where((t) => t.isDone).toList();
      case FilterOption.NotDone:
        return tasks.where((t) => !t.isDone).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: [
          // Toggle dark/light mode
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              if (widget.onToggleTheme != null) {
                widget.onToggleTheme!(!isDark);
              }
            },
          ),
          // Filter menu
          PopupMenuButton<FilterOption>(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: FilterOption.All, child: Text("All")),
              const PopupMenuItem(
                value: FilterOption.Done,
                child: Text("Done"),
              ),
              const PopupMenuItem(
                value: FilterOption.NotDone,
                child: Text("Not Done"),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.isDone,
              onChanged: (value) {
                setState(() {
                  task.isDone = value!;
                });
                saveTasks();
              },
            ),
            title: Text(task.title),
            subtitle: Text("${task.description}\nCategory: ${task.category}"),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final editedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskPage(task: task),
                      ),
                    );
                    if (editedTask != null) {
                      addOrEditTask(editedTask, tasks.indexOf(task));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteTask(tasks.indexOf(task));
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskPage()),
          );
          if (newTask != null) {
            addOrEditTask(newTask);
          }
        },
      ),
    );
  }
}
