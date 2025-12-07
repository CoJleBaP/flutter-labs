import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Пока без навигации
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Виджет совета по продуктивности
          _buildAdviceWidget(),

          // Список категорий и задач
          Expanded(child: _buildTasksList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Пока без навигации
        },
        child: const Icon(Icons.add),
        tooltip: 'Добавить задачу',
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
              tooltip: 'Главная',
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                // Пока без навигации
              },
              tooltip: 'Статистика',
            ),
          ],
        ),
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
                  onPressed: () {},
                  tooltip: 'Обновить совет',
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Сосредоточьтесь на одной задаче за раз. Многозадачность снижает продуктивность на 40%.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    final categories = {
      'Работа': ['Подготовить отчёт', 'Совещание в 15:00'],
      'Дом': ['Купить продукты', 'Убраться в квартире'],
      'Личное': ['Сходить в спортзал', 'Прочитать книгу'],
      'Покупки': ['Новый монитор', 'Канцелярия'],
    };

    return ListView(
      children: [
        for (final category in categories.entries)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              leading: _getCategoryIcon(category.key),
              title: Text(
                category.key,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('${category.value.length} задачи'),
              children: [
                for (final task in category.value)
                  ListTile(
                    leading: Checkbox(
                      value: false, // Пока статично
                      onChanged: (value) {},
                    ),
                    title: Text(task),
                    subtitle: const Text('Средний приоритет'),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {},
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
