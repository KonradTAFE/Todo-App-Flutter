import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_datasource.dart';
import 'package:path/path.dart';

class SQLDataSource implements IDataSource {
  late Database _database;

  Future initialise() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)',
        );
      }
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
    int id = await _database.insert("todo", data);
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
        "todo",
        where: 'id=?',
        whereArgs: [model.id],
      );
    return deleted == 1;
  }

  @override
  Future<bool> edit(Todo model) async {
     int editted = await _database.update(
      "todo",
      model.toMap(),
      where: 'id=?',
      whereArgs: [model.id],
    );
    return editted == 1;
  }

  @override
  Future<Todo?> read(String id) async {
    List<Map<String, dynamic>> items = await _database.query(
      'todo',
      where: 'id=?',
      whereArgs: [id],
    );
    return items.isEmpty ? null : Todo.fromMap(items.first);
  }
}