import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_datasource.dart';

class FirebaseDatasource implements IDataSource{
  late FirebaseDatabase _database;

  Future<void> initialise() async {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _database = FirebaseDatabase.instanceFor(
      app: app,
      databaseURL: DefaultFirebaseOptions.currentPlatform.databaseURL,
    );
  }

  static Future<IDataSource> createAsync() async {
    final dataSource = FirebaseDatasource();
    await dataSource.initialise();
    return dataSource;
  }

  Map<String, dynamic> _toFirebaseMap(Todo todo, String id) {
    return {
      'id': id,
      'name': todo.name,
      'description': todo.description,
      'complete': todo.completed,
    };
  }

  Todo _fromSnapshot(DataSnapshot snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);

    // The child key identifies this record in Firebase.
    data['id'] = snapshot.key;

    return Todo.fromMap(data);
  }

  @override
  Future<List<Todo>> browse() async {
    final snapshot = await _database.ref('todos').get();

    if (!snapshot.exists) {
      return [];
    }

    return snapshot.children.map(_fromSnapshot).toList();
  }

  @override
  Future<Todo?> read(String id) async {
    final snapshot = await _database.ref('todos').child(id).get();

    if (!snapshot.exists) {
      return null;
    }

    return _fromSnapshot(snapshot);
  }

  @override
  Future<bool> add(Todo model) async {
    final reference = _database.ref('todos').push();
    final id = reference.key;

    if (id == null) {
      throw StateError('Firebase could not generate a task ID.');
    }

    await reference.set(_toFirebaseMap(model, id));

    model.id = id;
    return true;
  }

  @override
  Future<bool> edit(Todo model) async {
    final id = model.id;
    if (id == null) return false;

    await _database.ref('todos').child(id).update(
      _toFirebaseMap(model, id),
    );

    return true;
  }

  @override
  Future<bool> delete(Todo model) async {
    final id = model.id;
    if (id == null) return false;

    await _database.ref('todos').child(id).remove();

    return true;
  }
}