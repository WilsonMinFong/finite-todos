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
    _todoRepository.updateTodo(todo.toggleInProgress());
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: NewTodoForm(onTodoAdded: _addTodo),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tasks in your inbox will expire after one week.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  final now = DateTime.now();
                  final timeRemaining = todo.expiresAt.difference(now);
                  final isExpired = timeRemaining.isNegative;

                  // Calculate the most appropriate time unit
                  String timeText;
                  bool isExpiringSoon = false;

                  if (isExpired) {
                    final timeOverdue = now.difference(todo.expiresAt);
                    if (timeOverdue.inDays > 0) {
                      timeText = 'Expired ${timeOverdue.inDays} days ago';
                    } else if (timeOverdue.inHours > 0) {
                      timeText = 'Expired ${timeOverdue.inHours} hours ago';
                    } else {
                      timeText = 'Expired ${timeOverdue.inMinutes} minutes ago';
                    }
                    isExpiringSoon = true;
                  } else {
                    if (timeRemaining.inDays > 0) {
                      timeText = 'Expires in ${timeRemaining.inDays} days';
                      isExpiringSoon = timeRemaining.inDays < (Todo.expireDays / 2);
                    } else if (timeRemaining.inHours > 0) {
                      timeText = 'Expires in ${timeRemaining.inHours} hours';
                      isExpiringSoon = true;
                    } else {
                      timeText = 'Expires in ${timeRemaining.inMinutes} minutes';
                      isExpiringSoon = true;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Checkbox(value: todo.completedAt != null, onChanged: (bool? value) { _toggleCompleteTodo(todo); }),
                        title: Text(todo.description),
                        subtitle: Row(
                          children: [
                            if (isExpiringSoon) ...[
                              Icon(
                                Icons.hourglass_bottom,
                                size: 16,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              timeText,
                              style: TextStyle(
                                color: isExpiringSoon
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow_outlined),
                          onPressed: () { _markTodoInProgress(todo); }
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}
