import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
    // show sqfliteFfiInit, databaseFactoryFfi;
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_datasource.dart';
import 'package:path/path.dart';

class SQLDataSource implements IDataSource {
  late Database _database;

  Future<void> initialise() async {
    // Windows and Linux need the desktop SQLite factory.
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await openDatabase(
  join(await getDatabasesPath(), 'todo_data.db'),
  version: 1,
  onCreate: (db, version) async {
    await db.execute(
      '''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        complete INTEGER,
        created_at TEXT,
        updated_at TEXT,
        due_date TEXT
      )
      ''',
    );
  },
);
  }

  static Future<IDataSource> createAsync() async {
    SQLDataSource dataSource = SQLDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  @override
  Future<bool> add(Todo model) async {
    Map<String, dynamic> data = model.toMap();
    data.remove("id");
    int id = await _database.insert("todos", data);
    model.id = id;
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    List<Map<String, dynamic>> maps = await _database.query('todos');
    return List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
  }

  @override
  Future<bool> delete(Todo model) async {
    int deleted = await _database.delete(
      "todos",
      where: 'id=?',
      whereArgs: [model.id],
    );
    return deleted == 1;
  }

  @override
  Future<bool> edit(Todo model) async {
    int editted = await _database.update(
      "todos",
      model.toMap(),
      where: 'id=?',
      whereArgs: [model.id],
    );
    return editted == 1;
  }

  @override
  Future<Todo?> read(String id) async {
    List<Map<String, dynamic>> items = await _database.query(
      'todos',
      where: 'id=?',
      whereArgs: [id],
    );
    return items.isEmpty ? null : Todo.fromMap(items.first);
  }
}
