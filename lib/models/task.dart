class Task {
  String id;
  String title;
  String description;
  String category;
  String priority;
  bool isDone;
  DateTime? reminderDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isDone = false,
    this.reminderDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    priority: json['priority'],
    isDone: json['isDone'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'priority': priority,
    'isDone': isDone,
  };
}
