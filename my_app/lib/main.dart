import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'data/task_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(
        taskRepository: TaskRepository(),
      ), // Передаём репозиторий
    );
  }
}
