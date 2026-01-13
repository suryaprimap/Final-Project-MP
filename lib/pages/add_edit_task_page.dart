import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

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

  final categories = ["Umum", "Kuliah", "Pribadi", "Kerja"];
  final priorities = ["Low", "Medium", "High"];

  @override
  void initState() {
    super.initState();
    title = widget.task?.title ?? "";
    description = widget.task?.description ?? "";
    category = widget.task?.category ?? "Umum";
    priority = widget.task?.priority ?? "Normal";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (value) => description = value ?? "",
              ),
              DropdownButtonFormField(
                initialValue: category,
                decoration: const InputDecoration(labelText: "Category"),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => category = value!,
              ),
              DropdownButtonFormField(
                initialValue: priority,
                decoration: const InputDecoration(labelText: "Priority"),
                items: priorities
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => priority = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.task == null ? "Add" : "Save"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newTask = Task(
                      id: widget.task?.id ?? const Uuid().v4(),
                      title: title,
                      description: description,
                      category: category,
                      priority: priority,
                      isDone: widget.task?.isDone ?? false,
                    );
                    Navigator.pop(context, newTask);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
