import 'package:flutter/material.dart';

import 'Task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<Task> _tasks = [];

  TextEditingController _taskController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _addTask(String taskName, String taskTime) {
    setState(() {
      _tasks.add(Task(taskName, time: taskTime, isCompleted: false));
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _showTimePickerDialog() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_tasks[index].name),
            onDismissed: (direction) {
              _removeTask(index);
            },
            child: ListTile(
              leading: Checkbox(
                value: _tasks[index].isCompleted,
                onChanged: (value) {
                  setState(() {
                    _tasks[index].isCompleted = value!;
                  });
                },
              ),
              title: Text(
                _tasks[index].name,
                style: TextStyle(
                  decoration: _tasks[index].isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(_tasks[index].time),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removeTask(index);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(labelText: 'Enter a task'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Select time: '),
                        TextButton(
                          onPressed: _showTimePickerDialog,
                          child: Text(
                            '${_selectedTime.hour}:${_selectedTime.minute}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        _addTask(
                          _taskController.text,
                          '${_selectedTime.hour}:${_selectedTime.minute}',
                        );
                        _taskController.clear();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
