import 'package:flutter/material.dart';
import 'package:task_tracker/ui/home.dart';

void main() => runApp(TaskTrackerApp());

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Trackr',
      home: HomeScreen(),
    );
  }
}
