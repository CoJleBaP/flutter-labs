class Task {
  final String id;
  final String title;
  final String category;
  final String priority;
  final String? description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.description,
    this.isCompleted = false,
  });

  // Метод для создания задачи из формы
  factory Task.fromForm({
    required String title,
    required String category,
    required String priority,
    String? description,
  }) {
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      priority: priority,
      description: description,
    );
  }
}
