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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _taskTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              bool isCompleted = false;
              bool isSubmitButtonEnabled = false;
              bool isLoading = false;
              return Dialog(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: StatefulBuilder(
                      builder: (context, setState) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              IconButton(
                                tooltip: 'Close',
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _taskTitleController,
                            decoration: InputDecoration(
                              isDense: true,
                              hintStyle: TextTheme.of(context).titleLarge,
                              hintText: 'Add Title',
                              border: null,
                              contentPadding: null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                isSubmitButtonEnabled = value.trim().isNotEmpty;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Completed',
                              ),
                              const Spacer(),
                              Switch(
                                value: isCompleted,
                                onChanged: (bool value) {
                                  setState(() {
                                    isCompleted = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              FilledButton(
                                onPressed: (isSubmitButtonEnabled)
                                    ? () async {
                                        setState(() {
                                          isSubmitButtonEnabled = false;
                                          isLoading = true;
                                        });
                                        try {
                                          final Task task = Task(
                                            content: _taskTitleController.text
                                                .trim(),
                                            completed: isCompleted,
                                          );
                                          final result = await _taskRepository
                                              .insertTask(
                                                task,
                                              );
                                          if (result.isError()) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Error adding task',
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        } finally {
                                          if (context.mounted) {
                                            setState(() {
                                              isSubmitButtonEnabled = true;
                                              isLoading = false;
                                            });

                                            Navigator.pop(context);
                                          }
                                        }
                                      }
                                    : null,
                                child: (isLoading)
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Add Task'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Task Tracker'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _taskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
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
