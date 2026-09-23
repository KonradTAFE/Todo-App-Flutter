import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/models/todo_list.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({Key? key, required this.todo}) : super(key: key);

final Todo todo;
  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  late bool _completed;
  final GlobalKey _dismissibleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _completed = widget.todo.completed;
  }

  @override
  void didUpdateWidget(covariant TodoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _completed = widget.todo.completed;
  }

  Future<void> _updateCompleted(bool? value) async {
    if (value == null) return;

    final updatedTodo = Todo(
      id: widget.todo.id,
      name: widget.todo.name,
      description: widget.todo.description,
      completed: value,
    );

    final model = Provider.of<TodoList>(context, listen: false);
    await model.updateTodo(updatedTodo);

    if (!mounted) return;

    setState(() {
      _completed = value;
    });
  }

  Future<void> _deleteTodo() async {
    final model = Provider.of<TodoList>(context, listen: false);
    await model.remove(widget.todo);
  }

  @override
Widget build(BuildContext context) {
  return Dismissible(
    key: _dismissibleKey,
    onDismissed: (direction) async {
      await _deleteTodo();
    },
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    child: Card(
      margin: const EdgeInsets.all(5),
      child: CheckboxListTile(
        title: Text(
          widget.todo.name,
          style: TextStyle(
            decoration: _completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(widget.todo.description),
        value: _completed,
        onChanged: _updateCompleted,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ),
  );
}
}