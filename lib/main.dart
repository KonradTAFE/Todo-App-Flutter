import 'package:flutter/material.dart';

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
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
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
        child: Center(child: Text('Welcome to the Todo App')),
      )
    );
  }
}
