class Todo {
  int? id;
  final String name;
  final String description;
  final bool completed;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    this.completed = false,
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
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    bool? complete = map['complete'] is bool ? map['complete'] : null;
    complete ??= map['complete'] == 1 ? true : false;

    return Todo(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      completed: complete,
    );
  }
}
