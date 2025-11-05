import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern - private constructor
  DatabaseHelper._init();
  
  // Single instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  // Database instance (nullable until initialized)
  static Database? _database;
  
  // Getter for database - initializes if not already done
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finite_todos.db');
    return _database!;
  }
  
  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  // Create database tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL
      )
    ''');
  }
  
  Future<int> insertItem(String tableName, Map<String, Object?> itemMap) async {
    final db = await database;

    return await db.insert(
      tableName,
      itemMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<List<Map<String, dynamic>>> getItemMaps(String tableName) async {
    final db = await database;

    return await db.query(tableName);
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}