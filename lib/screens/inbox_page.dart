import 'package:flutter/material.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';
import '../widgets/new_todo_form.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final _todoRepository = TodoRepository();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _todoRepository.getInboxTodos();

    setState(() {
      _todos = todos;
    });
  }

  void _addTodo(String description) {
    _todoRepository.addTodo(description);
    _loadTodos();
  }

  void _toggleCompleteTodo(Todo todo) {
    _todoRepository.updateTodo(todo.toggleComplete());
    _loadTodos();
  }

  void _markTodoInProgress(Todo todo) {
    _todoRepository.updateTodo(todo.markInProgress());
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    final uncompletedTodos = _todos.where((todo) => todo.completedAt == null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Inbox')
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
                  final todo = _todos[index];

                  return ListTile(
                    leading: Checkbox(value: todo.completedAt != null, onChanged: (bool? value) { _toggleCompleteTodo(todo); }),
                    title: Text(todo.description),
                    subtitle: Text('Expires at: ${todo.expiresAt.toString()}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow_outlined),
                      onPressed: () { _markTodoInProgress(todo); }
                    )
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('You have ${uncompletedTodos.length} todos left.'),
            ),
          ],
        ),
      ),
    );
  }
}
