class Task {
  String id;
  String title;
  String description;
  bool isDone;
  String category; // fitur opsional
  String priority; // Low / Medium / High

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.category = "Umum",
    this.priority = "Normal",
  });

  // Convert object ke JSON untuk disimpan di shared_preferences
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "isDone": isDone,
    "category": category,
    "priority": priority,
  };

  // Convert JSON ke object Task
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    isDone: json["isDone"],
    category: json["category"],
    priority: json["priority"],
  );
}
