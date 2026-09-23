class Todo {
  int? id;
  final String name;
  final String description;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
