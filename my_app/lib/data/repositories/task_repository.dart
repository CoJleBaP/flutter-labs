import '../../domain/models/task.dart';
import '../services/storage_service.dart';

class TaskRepository {
  final StorageService _storageService;
  List<Task> _tasks = [];

  TaskRepository(this._storageService);

  // Инициализация (загрузка из хранилища)
  Future<void> initialize() async {
    _tasks = await _storageService.loadTasks();

    // Если нет сохранённых задач, создаём демо-данные
    if (_tasks.isEmpty) {
      _tasks = _createDemoTasks();
      await _saveTasks();
    }
  }

  List<Task> _createDemoTasks() {
    return [
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
  }

  Future<void> _saveTasks() async {
    await _storageService.saveTasks(_tasks);
  }

  // CRUD операции
  List<Task> getTasks() => List.from(_tasks);

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    await _saveTasks();
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
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
