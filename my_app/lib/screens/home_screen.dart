import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'statistics_screen.dart';
import '../data/task_repository.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  final TaskRepository taskRepository;

  const HomeScreen({super.key, required this.taskRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _advices = [
    'Сосредоточьтесь на одной задаче за раз. Многозадачность снижает продуктивность на 40%.',
    'Начинайте день с самой сложной задачи (метод "съесть лягушку").',
    'Используйте технику Pomodoro: 25 минут работы, 5 минут отдыха.',
    'Планируйте следующий день вечером. Это освобождает ум и улучшает сон.',
    'Регулярно делайте перерывы для поддержания концентрации.',
  ];
  String _currentAdvice = '';

  @override
  void initState() {
    super.initState();
    _currentAdvice = _advices[0];
  }

  void _refreshAdvice() {
    setState(() {
      _currentAdvice = _advices[(DateTime.now().second % _advices.length)];
    });
  }

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      widget.taskRepository.toggleTaskCompletion(taskId);
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      widget.taskRepository.deleteTask(taskId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Задача удалена')));
  }

  void _showDeleteDialog(String taskId, String taskTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить задачу?'),
        content: Text('Вы уверены, что хотите удалить задачу "$taskTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(taskId);
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      // Главный экран
      Scaffold(
        appBar: AppBar(
          title: const Text('Мои задачи'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshAdvice,
              tooltip: 'Обновить совет',
            ),
          ],
        ),
        body: Column(
          children: [
            // Виджет совета
            _buildAdviceWidget(),

            // Список задач
            Expanded(child: _buildTasksList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToAddTask(context),
          child: const Icon(Icons.add),
          tooltip: 'Добавить задачу',
        ),
      ),

      // Экран статистики
      StatisticsScreen(taskRepository: widget.taskRepository),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Задачи'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceWidget() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'Совет дня',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshAdvice,
                  tooltip: 'Обновить совет',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_currentAdvice, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    final categories = ['Работа', 'Дом', 'Личное', 'Покупки'];

    return ListView(
      children: [
        for (final category in categories)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              leading: _getCategoryIcon(category),
              title: Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${widget.taskRepository.getTasksByCategory(category).length} задачи',
              ),
              children: [
                for (final task in widget.taskRepository.getTasksByCategory(
                  category,
                ))
                  ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleTaskCompletion(task.id),
                    ),
                    title: Text(
                      task.title,
                      style: task.isCompleted
                          ? TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    subtitle: Text('${task.priority} приоритет'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Удалить'),
                        ),
                      ],
                      onSelected: (_) => _showDeleteDialog(task.id, task.title),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToAddTask(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить задачу'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _navigateToAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onTaskAdded: (newTask) {
            setState(() {
              widget.taskRepository.addTask(newTask);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Задача "${newTask.title}" добавлена')),
            );
          },
        ),
      ),
    );
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Работа':
        return const Icon(Icons.work, color: Colors.blue);
      case 'Дом':
        return const Icon(Icons.home, color: Colors.green);
      case 'Личное':
        return const Icon(Icons.person, color: Colors.purple);
      case 'Покупки':
        return const Icon(Icons.shopping_cart, color: Colors.orange);
      default:
        return const Icon(Icons.category);
    }
  }
}
