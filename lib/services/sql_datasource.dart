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
  Future<bool> add(Todo model) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> browse() {
    // TODO: implement browse
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Todo model) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> edit(Todo model) {
    // TODO: implement edit
    throw UnimplementedError();
  }

  @override
  Future<bool> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }
}