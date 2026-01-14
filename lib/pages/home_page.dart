import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/local_storage.dart';
import 'add_edit_task_page.dart';

enum FilterOption { All, Done, NotDone }

class HomePage extends StatefulWidget {
  final Function(bool)? onToggleTheme;
  const HomePage({super.key, this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  FilterOption filter = FilterOption.All;
  String selectedCategory = "All";

  final List<String> categories = ["All", "Kuliah", "Pribadi", "Kerja"];

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
    List<Task> filtered = tasks;

    // Apply Done/NotDone filter
    switch (filter) {
      case FilterOption.Done:
        filtered = filtered.where((t) => t.isDone).toList();
        break;
      case FilterOption.NotDone:
        filtered = filtered.where((t) => !t.isDone).toList();
        break;
      default:
        break;
    }

    // Apply Category filter
    if (selectedCategory != "All") {
      filtered = filtered
          .where(
            (t) => t.category.toLowerCase() == selectedCategory.toLowerCase(),
          )
          .toList();
    }

    return filtered;
  }

  Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case "kuliah":
        return Colors.blueAccent;
      case "pribadi":
        return Colors.greenAccent;
      case "kerja":
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("To-Do List"),
        elevation: 0,
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.onBackground,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              if (widget.onToggleTheme != null) {
                widget.onToggleTheme!(!isDark);
              }
            },
          ),
          PopupMenuButton<FilterOption>(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            icon: const Icon(Icons.filter_list),
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Category filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: theme.colorScheme.primary,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      labelStyle: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onBackground,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Task list
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks yet",
                        style: theme.textTheme.titleMedium,
                      ),
                    )
                  : ReorderableListView.builder(
                      itemCount: filteredTasks.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = filteredTasks.removeAt(oldIndex);
                          filteredTasks.insert(newIndex, item);
                          saveTasks();
                        });
                      },
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return Card(
                          key: ValueKey(task.id),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: theme.cardColor,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (value) {
                                setState(() {
                                  task.isDone = value!;
                                });
                                saveTasks();
                              },
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.description),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: categoryColor(
                                      task.category,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    task.category,
                                    style: TextStyle(
                                      color: categoryColor(task.category),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () async {
                                    final editedTask = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AddEditTaskPage(task: task),
                                      ),
                                    );
                                    if (editedTask != null) {
                                      addOrEditTask(
                                        editedTask,
                                        tasks.indexOf(task),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () {
                                    deleteTask(tasks.indexOf(task));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
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
