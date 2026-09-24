import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/models/todo.dart';

void main() {
  test('A new task is not completed by default', () {
    final todo = Todo(
      id: '1',
      name: 'Shopping',
      description: 'Buy milk',
    );

    expect(todo.completed, isFalse);
  });

  test('toString includes the name and description', () {
    final todo = Todo(
      id: '1',
      name: 'Shopping',
      description: 'Buy milk',
    );

    expect(todo.toString(), 'Shopping - (Buy milk)');
  });

  test('toMap stores a completed task as 1', () {
    final todo = Todo(
      id: '1',
      name: 'Shopping',
      description: 'Buy milk',
      completed: true,
    );

    final map = todo.toMap();

    expect(map['complete'], 1);
  });

  test('fromMap converts an integer ID to a string', () {
    final todo = Todo.fromMap({
      'id': 7,
      'name': 'Shopping',
      'description': 'Buy milk',
      'complete': 0,
    });

    expect(todo.id, '7');
  });
}