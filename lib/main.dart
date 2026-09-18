import 'package:flutter/material.dart';
import 'package:todoapp/models/todo_list.dart';
import 'models/todo.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const TodoApp()));
}


class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Todo App",
      home: TodoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {

final List<Todo> todos = <Todo>[
  Todo(name:"Shopping",description: "Milk, Eggs, Bread"),
  Todo(name:"Soccer",description: "Go play"),
  Todo(name:"Tax",description: "Review tax")
];

int get todosLength => todos.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo\'s \nAll tasks: $todosLength'),
        actions: const [
          Icon(Icons.menu),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Consumer<TodoList>(
            builder: (context, model, child){
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.name),
                    subtitle: Text(todo.description),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
