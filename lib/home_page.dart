import 'package:flutter/material.dart';
import 'package:flutter_todo/database.dart';
import 'package:flutter_todo/dialog.dart';
import 'package:flutter_todo/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _myBox = Hive.box('mybox');
  TodoDatabase todoDatabase = TodoDatabase();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      todoDatabase.createInitialData();
    } else {
      todoDatabase.loadData();
    }
    super.initState();
  }

  // set task completed
  void onChanged(bool value, int index) {
    setState(() {
      todoDatabase.todoList[index][1] = value;
    });
    todoDatabase.updateDatabase();
  }

  // save task
  void onSave() {
    setState(() {
      // add task to list
      todoDatabase.todoList.add([_controller.text, false]);
      // clear input text
      _controller.clear();
    });
    Navigator.of(context).pop();
    todoDatabase.updateDatabase();
  }

  // create a new task
  void createTask() {
    showDialog(
      context: context,
      builder: (context) {
        return MyDialog(
          controller: _controller,
          onSave: onSave,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      todoDatabase.todoList.removeAt(index);
    });
    todoDatabase.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'TODO',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTask,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
              itemCount: todoDatabase.todoList.length,
              itemBuilder: ((context, index) {
                return TodoTile(
                  taskName: todoDatabase.todoList[index][0],
                  completed: todoDatabase.todoList[index][1],
                  onChanged: (value) => onChanged(value!, index),
                  deleteAction: (ctx) => deleteTask(index),
                );
              })),
        ),
      ),
    );
  }
}
