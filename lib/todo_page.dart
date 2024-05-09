import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'task_list_page.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  Future<void> addItem(BuildContext context) async {
    final String title = _titleController.text.trim();
    final String dueDate = _dueDateController.text.trim();

    if (title.isNotEmpty && dueDate.isNotEmpty) {
      final ParseObject newTask = ParseObject('TodoItem')
        ..set('title', title)
        ..set('dueDate', dueDate);

      final ParseResponse response = await newTask.save();

      if (response.success) {
        Navigator.push(
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter task details!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addItem(context),
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
