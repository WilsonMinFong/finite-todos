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
  }

  Future<void> _loadTodosCompletedToday() async {
    final todos = await _todoRepository.getTodosCompletedToday();

    setState(() {
      _todosCompletedToday = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Done Today')
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text('Completed ${_todosCompletedToday.length} todos today'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todosCompletedToday.length,
                itemBuilder: (context, index) {
                  final todo = _todosCompletedToday[index];

                  return ListTile(
                    leading: Checkbox(value: todo.completedAt != null, onChanged: (bool? value) { }),
                    title: Text(todo.description),
                    subtitle: Text(todo.completedAt.toString())
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
