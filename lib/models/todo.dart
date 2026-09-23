import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool completed;
  @HiveField(4)
  final DateTime? createdAt;
  @HiveField(5)
  final DateTime? updatedAt;
  @HiveField(6)
  final DateTime? dueDate;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    this.completed = false,
    this.createdAt,
    this.updatedAt,
    this.dueDate,
  });

  @override
  String toString() {
    return "$name - ($description)";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': completed ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
    };
  }

    factory Todo.fromMap(Map<String, dynamic> map) {
      final complete = map['complete'];
      final createdAt = map['created_at'];
      final updatedAt = map['updated_at'];
      

    return Todo(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      completed: complete == true || complete == 1,
      createdAt: createdAt == null
          ? null
          : DateTime.parse(createdAt as String),
      updatedAt: updatedAt == null
          ? null
          : DateTime.parse(updatedAt as String),
          dueDate: map['due_date'] == null
          ? null
          : DateTime.parse(map['due_date'] as String),
    );
  }
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  int get typeId => 0;

  @override
  Todo read(BinaryReader reader) {
    return Todo(
      id: reader.read() as int?,
      name: reader.read() as String,
      description: reader.read() as String,
      completed: reader.read() as bool,
      createdAt: reader.read() as DateTime?,
      updatedAt: reader.read() as DateTime?,
      dueDate: reader.read() as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todo todo) {
    writer.write(todo.id);
    writer.write(todo.name);
    writer.write(todo.description);
    writer.write(todo.completed);
    writer.write(todo.createdAt);
    writer.write(todo.updatedAt);
    writer.write(todo.dueDate);
  }
}
