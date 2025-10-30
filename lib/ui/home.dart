import 'package:flutter/material.dart';
import 'package:task_tracker/database.dart';
import 'package:task_tracker/model.dart';
import 'package:task_tracker/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskRepository _taskRepository = TaskRepository(AppDatabase());
  late final _taskList = _taskRepository.getTasksList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _taskRepository.insertTask(Task(content: 'Avicii'));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Task Tracker'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _taskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading data'),
            );
          } else {
            final List<Task> taskList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(taskList[index].content),
              ),
            );
          }
        },
      ),
    );
  }
}
