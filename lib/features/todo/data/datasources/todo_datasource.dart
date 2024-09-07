import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todo_model.dart';

class TodoDataSource {
  static Database? _database;
  static final TodoDataSource db = TodoDataSource._();

  TodoDataSource._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'TodoDB.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Todo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL,
        imageUrl TEXT NOT NULL,
        completionDate TEXT NULL
      )
    ''');
  }

  Future<List<TodoModel>> getTodos() async {
    try {
      final db = await database;
      final res = await db.query('Todo');
      return res.isNotEmpty
          ? res.map((c) => TodoModel.fromMap(c)).toList()
          : [];
    } catch (e) {
      print('Error retrieving todos: $e');
      return [];
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      final db = await database;
      await db.insert('Todo', todo.toMap());
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    try {
      final db = await database;
      await db.update('Todo', todo.toMap(),
          where: 'id = ?', whereArgs: [todo.id]);
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final db = await database;
      await db.delete('Todo', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}
