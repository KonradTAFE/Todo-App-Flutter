import 'package:flutter/material.dart';
import 'models/todo.dart';

void main() {
  runApp(const TodoApp());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo\'s'),
        actions: const [
          Icon(Icons.menu),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    )
                  ),
                  padding: const EdgeInsets.all(2.5),
                  child:  Text(todos[index].name.toString(),
                  textAlign: TextAlign.center),
                );
              },)
          
        )),
      );
    
  }
}
