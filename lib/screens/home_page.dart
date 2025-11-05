import 'package:flutter/material.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';
import '../widgets/new_todo_form.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _todoRepository = TodoRepository();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _todoRepository.getAllTodos();

    setState(() {
      _todos = todos;
    });
  }

  void _addTodo(String description) {
    _todoRepository.addTodo(description);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: NewTodoForm(onTodoAdded: _addTodo),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_todos[index].description),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('You have ${_todos.length} todos left.'),
            ),
          ],
        ),
      ),
    );
  }
}
