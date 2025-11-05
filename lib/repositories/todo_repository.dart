import '../models/todo.dart';
import '../services/database_helper.dart';

class TodoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Todo>> getAllTodos() async {
    return await _dbHelper.getTodos();
  }

  Future<Todo?> getTodo(int id) async {
    return await _dbHelper.getTodo(id);
  }
  
  Future<void> addTodo(String description) async {
    final todo = Todo(description: description);
    await _dbHelper.insertTodo(todo);
  }
}