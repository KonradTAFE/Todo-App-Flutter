import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/services/todo_datasource.dart';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = [];

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;
  int get incompleteCount => _todos.where((todo) => !todo.completed).length;

  Future<void> refresh() async {
    IDataSource dataSource = Get.find<IDataSource>();
    List<Todo> savedTodos = await dataSource.browse();
    _todos.clear();
    _todos.addAll(savedTodos);
    notifyListeners();
  }

  Future<void> add(Todo todo) async {
    IDataSource dataSource = Get.find<IDataSource>();
    if (await dataSource.add(todo)) {
      await refresh();
    }
  }

  Future<void> removeAll() async {
    IDataSource dataSource = Get.find<IDataSource>();
    for (Todo todo in List<Todo>.of(_todos)) {
      await dataSource.delete(todo);
    }
    await refresh();
  }

  Future<void> remove(Todo todo) async {
    if (todo.id == null) return;
    IDataSource dataSource = Get.find<IDataSource>();
    if (await dataSource.delete(todo)) {
      await refresh();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    if (todo.id == null) return;
    int index = _todos.indexWhere((element) => element.id == todo.id);
    if (index == -1) return;

    IDataSource dataSource = Get.find<IDataSource>();
    if (await dataSource.edit(todo)) {
      await refresh();
    }
  }
}
