import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;
  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String category;
  late String priority;
  DateTime? reminderDate;

  final categories = ["Umum", "Kuliah", "Pribadi", "Kerja"];
  final priorities = ["Low", "Medium", "High"];

  @override
  void initState() {
    super.initState();
    title = widget.task?.title ?? "";
    description = widget.task?.description ?? "";
    category = widget.task?.category ?? "Umum";
    priority = widget.task?.priority ?? "Medium";
    reminderDate = widget.task?.reminderDate;
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
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
        elevation: 0,
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  labelText: "Title",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSaved: (value) => description = value ?? "",
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Category
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(
                  labelText: "Category",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: categoryColor(c),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(c),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => category = value!),
              ),
              const SizedBox(height: 12),

              // Priority
              DropdownButtonFormField<String>(
                value: priority,
                decoration: InputDecoration(
                  labelText: "Priority",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: priorities
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              const SizedBox(height: 16),

              // Reminder Button
              ElevatedButton.icon(
                icon: const Icon(Icons.notifications),
                label: Text(
                  reminderDate == null
                      ? "Set Reminder"
                      : "Reminder: ${reminderDate!.toLocal().toString().substring(0, 16)}",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color.fromARGB(255, 255, 143, 7)
                      : theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate == null) return;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime == null) return;

                  setState(() {
                    reminderDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                child: Text(widget.task == null ? "Add Task" : "Save Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color.fromARGB(255, 255, 143, 7)
                      : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  final newTask = Task(
                    id: widget.task?.id ?? const Uuid().v4(),
                    title: title,
                    description: description,
                    category: category,
                    priority: priority,
                    isDone: widget.task?.isDone ?? false,
                    reminderDate: reminderDate,
                  );

                  // Schedule notification if reminder is set
                  if (reminderDate != null) {
                    await NotificationService.scheduleNotification(
                      id: newTask.id.hashCode,
                      title: newTask.title,
                      body: newTask.description,
                      scheduledDate: reminderDate!,
                    );
                  }

                  if (!mounted) return;
                  Navigator.pop(context, newTask);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
