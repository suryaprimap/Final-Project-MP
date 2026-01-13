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

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 12),

              // Description Field
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (value) => description = value ?? "",
              ),
              const SizedBox(height: 12),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: "Category"),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => category = value!),
              ),
              const SizedBox(height: 12),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(labelText: "Priority"),
                items: priorities
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              const SizedBox(height: 16),

              // Reminder Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.tealAccent : Colors.blue,
                ),
                child: Text(
                  reminderDate == null
                      ? "Set Reminder"
                      : "Reminder: ${reminderDate!.toLocal().toString().substring(0, 16)}",
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

              // Save/Add Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.tealAccent : Colors.green,
                ),
                child: Text(widget.task == null ? "Add" : "Save"),
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
