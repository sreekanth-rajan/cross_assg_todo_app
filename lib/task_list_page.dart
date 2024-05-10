import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'update_task_page.dart';
import 'delete_task_page.dart';
import 'todo_page.dart'; // Import TodoPage

class TaskListPage extends StatefulWidget {
  final ParseObject task;

  TaskListPage({required this.task});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late bool _isCompleted;
  List<String> taskDetails = [];

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.get('completed') ?? false;
    taskDetails = [
      'Title: ${widget.task.get('title')}',
      'Due Date: ${widget.task.get('dueDate')}'
    ];
  }

  Future<void> updateTaskCompletion(bool? isComplete) async {
    if (isComplete != null) {
      widget.task.set('completed', isComplete);
      final ParseResponse response = await widget.task.save();

      if (response.success) {
        setState(() {
          _isCompleted = isComplete;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task marked as ${isComplete ? 'complete' : 'incomplete'}!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error marking task: ${response.error!.message}')),
        );
      }
    }
  }

  Future<void> navigateToAddTaskPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TodoPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final newTask = ParseObject('Task')
        ..set('title', result['title'])
        ..set('dueDate', result['dueDate'])
        ..set('completed', result['completed']);

      final ParseResponse response = await newTask.save();

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );

        // Navigate to TaskListPage with the new task
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TaskListPage(task: newTask),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding task: ${response.error!.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var detail in taskDetails) Text(detail),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateTaskPage(task: widget.task),
                  ),
                );
              },
              child: Icon(Icons.edit),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeleteTaskPage(task: widget.task),
                  ),
                );
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 20),
            Checkbox(
              value: _isCompleted,
              onChanged: updateTaskCompletion,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddTaskPage,
        child: Icon(Icons.add),
      ),
    );
  }
}
