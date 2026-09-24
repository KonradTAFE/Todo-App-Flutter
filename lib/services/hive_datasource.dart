import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_datasource.dart';

class HiveDataSource implements IDataSource {
  late Box<Todo> _box;

  Future<void> initialise() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoAdapter());
    }

    _box = await Hive.openBox<Todo>('todos');
  }

  static Future<IDataSource> createAsync() async {
    final dataSource = HiveDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  @override
  Future<List<Todo>> browse() async {
    return _box.values.toList();
  }

  @override
  Future<Todo?> read(String id) async {
    final key = int.tryParse(id);
    if (key == null) return null;

    return _box.get(key);
  }

  @override
  Future<bool> add(Todo model) async {
    final id = await _box.add(model);

    // Save Hive's generated key inside the Todo as well.
    model.id = id.toString();
    await _box.put(id, model);

    return true;
  }

  @override
  Future<bool> edit(Todo model) async {
    final id = int.tryParse(model.id ?? '');
    if (id == null || !_box.containsKey(id)) return false;

    await _box.put(id, model);
    return true;
  }

  @override
  Future<bool> delete(Todo model) async {
    final id = int.tryParse(model.id ?? '');
    if (id == null || !_box.containsKey(id)) return false;

    await _box.delete(id);
    return true;
  }
}
