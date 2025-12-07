import '../models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Подготовить отчёт',
      category: 'Работа',
      priority: 'Высокий',
      description: 'Ежеквартальный отчёт для руководства',
    ),
    Task(
      id: '2',
      title: 'Купить продукты',
      category: 'Дом',
      priority: 'Средний',
    ),
    Task(
      id: '3',
      title: 'Сходить в спортзал',
      category: 'Личное',
      priority: 'Средний',
    ),
    Task(
      id: '4',
      title: 'Новый монитор',
      category: 'Покупки',
      priority: 'Низкий',
    ),
  ];

  List<Task> getTasks() => List.from(_tasks);

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void toggleTaskCompletion(String taskId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
  }

  // Статистика
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  double get completionPercentage =>
      totalTasks > 0 ? completedTasks / totalTasks : 0;

  Map<String, double> getCategoryProgress() {
    final categories = ['Работа', 'Дом', 'Личное', 'Покупки'];
    final progress = <String, double>{};

    for (final category in categories) {
      final categoryTasks = getTasksByCategory(category);
      if (categoryTasks.isEmpty) {
        progress[category] = 0;
      } else {
        final completed = categoryTasks.where((t) => t.isCompleted).length;
        progress[category] = completed / categoryTasks.length;
      }
    }

    return progress;
  }
}
