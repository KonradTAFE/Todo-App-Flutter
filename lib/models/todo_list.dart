import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';

class TodoList extends ChangeNotifier{

  final List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todo => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  void remove(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    Todo listTodo = _todos.firstWhere((element)=>element.name == todo.name);
    listTodo = todo;
    notifyListeners();
  }
}