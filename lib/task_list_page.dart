import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'update_task_page.dart';
import 'delete_task_page.dart';

class TaskListPage extends StatefulWidget {
  final ParseObject task;

  TaskListPage({required this.task});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.get('completed') ?? false;
  }

  Future<void> updateTaskCompletion(bool isComplete) async {
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
            Text('Title: ${widget.task.get('title')}'),
            Text('Due Date: ${widget.task.get('dueDate')}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateTaskPage(task: widget.task),
                  ),
                );
              },
              child: Text('Update Task'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeleteTaskPage(task: widget.task),
                  ),
                );
              },
              child: Text('Delete Task'),
            ),
            SizedBox(height: 20),
            Text('Mark as Complete:'),
            Switch(
              value: _isCompleted,
              onChanged: updateTaskCompletion,
            ),
          ],
        ),
      ),
    );
  }
}
