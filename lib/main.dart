import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo_list.dart';
import 'package:todoapp/services/sql_datasource.dart';
import 'package:todoapp/services/todo_datasource.dart';
import 'package:todoapp/views/todo_widget.dart';
import 'package:todoapp/views/add_todo_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<IDataSource>(() => SQLDataSource.createAsync());
  TodoList todos = TodoList();
  await todos.refresh();
  runApp(
    ChangeNotifierProvider(create: (context) => todos, child: const TodoApp()),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: TodoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoDialog(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          Consumer<TodoList>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Not completed: ${model.incompleteCount}'),
              );
            },
          ),
          const Icon(Icons.menu),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Consumer<TodoList>(
            builder: (context, model, child) {
              return RefreshIndicator(
                onRefresh: model.refresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: model.todoCount,
                  itemBuilder: (BuildContext context, int index) {
                    return TodoWidget(key: ValueKey(model.todos[index].id),
                                      todo: model.todos[index]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
