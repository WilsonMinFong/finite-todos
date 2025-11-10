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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Focus Capacity',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${_inProgressTodos.length} / ${Todo.maxNumInProgress}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: _inProgressTodos.length / Todo.maxNumInProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14b8a6)),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _inProgressTodos.length,
              itemBuilder: (context, index) {
                final todo = _inProgressTodos[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(value: todo.completedAt != null, onChanged: (bool? value) { _toggleCompleteTodo(todo); }),
                      title: Text(todo.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.inbox),
                        onPressed: () { _toggleInProgress(todo); }
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
