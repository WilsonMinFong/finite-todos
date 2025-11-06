import '../models/todo.dart';
import '../services/database_helper.dart';

class TodoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final String tableName = 'todos';

  Future<List<Todo>> getAllTodos() async {
    final itemMaps = await _dbHelper.getItemMaps(tableName);

    return itemMaps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<List<Todo>> getUncompletedTodos() async {
    final itemMaps = await _dbHelper.getItemMaps(
      tableName,
      where: 'completed_at IS NULL'
    );

    return itemMaps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<List<Todo>> getTodosCompletedToday() async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(Duration(days: 1));

    final itemMaps = await _dbHelper.getItemMaps(
      tableName,
      where: 'completed_at >= ? AND completed_at < ?',
      whereArgs: [
        startOfToday.millisecondsSinceEpoch,
        startOfTomorrow.millisecondsSinceEpoch,
      ],
      orderBy: 'completed_at DESC',
    );

    return itemMaps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<void> addTodo(String description) async {
    final todo = Todo(
      description: description,
      createdAt: DateTime.now()
    );

    await _dbHelper.insertItem(tableName, todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    await _dbHelper.updateItem(tableName, todo.toMap());
  }
}