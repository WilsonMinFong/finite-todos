import 'package:flutter/material.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({super.key});

  @override
  State<InProgressPage> createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> {
  final _todoRepository = TodoRepository();
  List<Todo> _inProgressTodos = [];

  @override
  void initState() {
    super.initState();
    _loadInProgressTodos();
  }

  Future<void> _loadInProgressTodos() async {
    final todos = await _todoRepository.getInProgressTodos();

    setState(() {
      _inProgressTodos = todos;
    });
  }

  Future<void> _toggleCompleteTodo(Todo todo) async {
    _todoRepository.updateTodo(todo.toggleComplete());
    _loadInProgressTodos();
  }

  Future<void> _toggleInProgress(Todo todo) async {
    _todoRepository.updateTodo(todo.toggleInProgress());
    _loadInProgressTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('In Progress')
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text('${_inProgressTodos.length} in-progress todos (max: ${Todo.maxNumInProgress})'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(value: _inProgressTodos.length / Todo.maxNumInProgress)
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _inProgressTodos.length,
                itemBuilder: (context, index) {
                  final todo = _inProgressTodos[index];

                  return ListTile(
                    leading: Checkbox(value: todo.completedAt != null, onChanged: (bool? value) { _toggleCompleteTodo(todo); }),
                    title: Text(todo.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.inbox),
                      onPressed: () { _toggleInProgress(todo); }
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
