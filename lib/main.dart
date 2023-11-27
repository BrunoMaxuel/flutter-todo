import 'package:flutter/material.dart';
import 'src/components/home_screen.dart';
import 'src/components/add_task_screen.dart';
import 'src/components/categories.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const TaskListScreen(),
        '/addTask': (context) => AddTaskScreen(),
        '/categories': (context) => categories()
      },
    );
  }
}
