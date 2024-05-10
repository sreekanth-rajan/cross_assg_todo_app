import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:todo_app/task_list_page.dart'; // Import TaskListPage

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
      final ParseObject newTask = ParseObject('Task')
        ..set('title', title)
        ..set('dueDate', dueDate)
        ..set('completed', false); // Assuming new tasks are initially incomplete

      final ParseResponse response = await newTask.save();

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );
        
        // Navigate to TaskListPage with the new task
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TaskListPage(task: newTask)),
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
        title: Text('Add Task'),
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
              onPressed: () => addItem(context), // Pass context to addItem function
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
