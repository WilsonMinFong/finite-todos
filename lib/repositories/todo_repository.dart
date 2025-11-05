import '../models/todo.dart';
import '../services/database_helper.dart';

class TodoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final String tableName = 'todos';

  Future<List<Todo>> getAllTodos() async {
    final itemMaps = await _dbHelper.getItemMaps(tableName);

    return List.generate(itemMaps.length, (i) {
      return Todo.fromMap(itemMaps[i]);
    });
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