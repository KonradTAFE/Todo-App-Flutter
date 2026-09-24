import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todoapp/firebase_options.dart';

class FirebaseDatasource {
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

  static Future<FirebaseDatasource> createAsync() async {
    final dataSource = FirebaseDatasource();
    await dataSource.initialise();
    return dataSource;
  }
}