import 'package:uuid/uuid.dart';

class Task {
  String id;
  String userId;
  String title;
  String description;
  String category;
  String priority;
  bool isDone;
  DateTime? reminderDate;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isDone = false,
    this.reminderDate,
  });

  Task.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? const Uuid().v4(),
      userId = json['userId'] ?? '', // <-- set default empty string
      title = json['title'] ?? '',
      description = json['description'] ?? '',
      category = json['category'] ?? 'Umum',
      priority = json['priority'] ?? 'Medium',
      isDone = json['isDone'] ?? false,
      reminderDate = json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'category': category,
    'priority': priority,
    'isDone': isDone,
  };
}
