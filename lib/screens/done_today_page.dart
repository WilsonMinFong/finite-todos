import 'package:flutter/material.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

class DoneTodayPage extends StatefulWidget {
  const DoneTodayPage({super.key});

  @override
  State<DoneTodayPage> createState() => _DoneTodayPageState();
}

class _DoneTodayPageState extends State<DoneTodayPage> {
  final _todoRepository = TodoRepository();
  List<Todo> _todosCompletedToday = [];

  @override
  void initState() {
    super.initState();
    _loadTodosCompletedToday();
  }  Future<void> _loadTodosCompletedToday() async {
    final todos = await _todoRepository.getTodosCompletedToday();

    setState(() {
      _todosCompletedToday = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Done Today 🎉',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 32,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_todosCompletedToday.length}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tasks Completed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
            Expanded(
              child: ListView.builder(
                itemCount: _todosCompletedToday.length,
                itemBuilder: (context, index) {
                  final todo = _todosCompletedToday[index];

                  return ListTile(
                    leading: Checkbox(value: todo.completedAt != null, onChanged: (bool? value) { }),
                    title: Text(
                      todo.description,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey[600],
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
